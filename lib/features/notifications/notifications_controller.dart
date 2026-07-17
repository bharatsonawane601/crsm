import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/db/database_provider.dart';
import '../auth/auth_service.dart';
import 'messages_client.dart';

/// A locally-computed case alert (chargesheet deadline / stale investigation).
class CaseAlert {
  const CaseAlert({
    required this.crimeId,
    required this.fir,
    required this.kind,
    this.daysLeft,
    this.daysStale,
  });

  final int crimeId;

  /// "123/2025" display label.
  final String fir;

  /// deadline | overdue | stale
  final String kind;

  /// Days until the chargesheet deadline (deadline kind; negative never used —
  /// overdue carries the positive overdue count instead).
  final int? daysLeft;

  /// Days since the last edit (stale kind).
  final int? daysStale;
}

class NotificationsState {
  const NotificationsState({
    this.messages = const [],
    this.alerts = const [],
    this.lastReadId = 0,
    this.loading = false,
  });

  final List<ServerMessage> messages;
  final List<CaseAlert> alerts;
  final int lastReadId;
  final bool loading;

  int get unreadMessages =>
      messages.where((m) => m.id > lastReadId).length;

  /// Badge = unread messages + urgent case alerts (overdue or ≤7 days left).
  int get badge =>
      unreadMessages +
      alerts
          .where((a) =>
              a.kind == 'overdue' ||
              (a.kind == 'deadline' && (a.daysLeft ?? 99) <= 7))
          .length;

  NotificationsState copyWith({
    List<ServerMessage>? messages,
    List<CaseAlert>? alerts,
    int? lastReadId,
    bool? loading,
  }) =>
      NotificationsState(
        messages: messages ?? this.messages,
        alerts: alerts ?? this.alerts,
        lastReadId: lastReadId ?? this.lastReadId,
        loading: loading ?? this.loading,
      );
}

/// Feeds the top-bar bell: command messages from seniors (server inbox) +
/// the brain's pending-case alerts (chargesheet deadlines, stale cases).
class NotificationsController extends Notifier<NotificationsState> {
  final _client = MessagesClient();

  @override
  NotificationsState build() {
    // First refresh shortly after startup (auth needs a beat to restore).
    Future.delayed(const Duration(seconds: 5), refresh);
    return const NotificationsState();
  }

  String? get _email => ref.read(authControllerProvider).value?.email;

  String get _prefsKey => 'crms.messages.lastRead.${_email ?? ''}';

  /// Pulls the server inbox and recomputes local case alerts.
  Future<void> refresh() async {
    final email = _email;
    if (email == null || email.isEmpty) return;
    state = state.copyWith(loading: true);

    final prefs = await SharedPreferences.getInstance();
    final lastRead = prefs.getInt(_prefsKey) ?? 0;

    final messages = await _client.fetch(email: email) ?? state.messages;
    final alerts = await _computeAlerts();

    state = NotificationsState(
      messages: messages,
      alerts: alerts,
      lastReadId: lastRead,
      loading: false,
    );
  }

  /// Marks all current messages read (called when the center is opened).
  Future<void> markRead() async {
    if (state.messages.isEmpty) return;
    final maxId = state.messages
        .map((m) => m.id)
        .reduce((a, b) => a > b ? a : b);
    if (maxId <= state.lastReadId) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, maxId);
    state = state.copyWith(lastReadId: maxId);
  }

  /// Brain: chargesheet deadlines (Sessions 90 / JMFC 60 days from
  /// registration, unless a chargesheet is already filed) and stale
  /// investigations (undetected, untouched for 90+ days).
  Future<List<CaseAlert>> _computeAlerts() async {
    final db = ref.read(databaseProvider);
    final crimes = await db.select(db.crimes).get();
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final deadlines = <CaseAlert>[];
    final stale = <CaseAlert>[];

    for (final c in crimes) {
      final fir = '${c.firNo}/${c.year}';
      final stage = c.caseStage;
      final chargesheeted = stage.contains('chargesheet');

      final window = switch (c.courtType) {
        'sessions' => 90,
        'jmfc' => 60,
        _ => null,
      };
      if (window != null && c.dateRegistered != null && !chargesheeted) {
        final deadline = c.dateRegistered!.add(Duration(days: window));
        final left = deadline.difference(day).inDays;
        if (left < 0) {
          deadlines.add(CaseAlert(
              crimeId: c.id, fir: fir, kind: 'overdue', daysLeft: -left));
        } else if (left <= 15) {
          deadlines.add(CaseAlert(
              crimeId: c.id, fir: fir, kind: 'deadline', daysLeft: left));
        }
      }

      if (c.status != 'detected' && !chargesheeted) {
        final idle = today.difference(c.updatedAt).inDays;
        if (idle >= 90) {
          stale.add(CaseAlert(
              crimeId: c.id, fir: fir, kind: 'stale', daysStale: idle));
        }
      }
    }

    // Most urgent first: overdue (worst first), closest deadlines, stalest.
    deadlines.sort((a, b) {
      if (a.kind != b.kind) return a.kind == 'overdue' ? -1 : 1;
      if (a.kind == 'overdue') return (b.daysLeft ?? 0) - (a.daysLeft ?? 0);
      return (a.daysLeft ?? 0) - (b.daysLeft ?? 0);
    });
    stale.sort((a, b) => (b.daysStale ?? 0) - (a.daysStale ?? 0));
    return [...deadlines, ...stale.take(30)];
  }

  MessagesClient get client => _client;
}

final notificationsControllerProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
        NotificationsController.new);
