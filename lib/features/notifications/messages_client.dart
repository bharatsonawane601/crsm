import 'dart:convert';

import 'package:http/http.dart' as http;

import '../access/access_config.dart';

/// A command message received from the central server (sent by CP/DCP/ACP/HQ).
class ServerMessage {
  const ServerMessage({
    required this.id,
    required this.from,
    required this.fromName,
    required this.fromRole,
    required this.target,
    required this.body,
    required this.at,
  });

  final int id;
  final String from;
  final String fromName;
  final String fromRole;

  /// Human target label rendered by the server ("All", "Station: CIDCO", …).
  final String target;
  final String body;
  final DateTime at;

  factory ServerMessage.fromJson(Map<String, dynamic> j) => ServerMessage(
        id: (j['id'] as num).toInt(),
        from: (j['from'] ?? '').toString(),
        fromName: (j['from_name'] ?? '').toString(),
        fromRole: (j['from_role'] ?? '').toString(),
        target: (j['target'] ?? '').toString(),
        body: (j['body'] ?? '').toString(),
        at: DateTime.tryParse((j['at'] ?? '').toString())?.toLocal() ??
            DateTime.now(),
      );
}

/// A user the sender may message individually.
class MessageUser {
  const MessageUser({required this.email, this.name = '', this.scope = ''});
  final String email;
  final String name;
  final String scope;
}

/// HTTP client for the command-messaging endpoints (Go server).
class MessagesClient {
  MessagesClient({http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _uri(String file) => Uri.parse('${AccessConfig.apiBaseUrl}/$file');
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-App-Key': AccessConfig.appKey,
      };

  /// Inbox: messages addressed to this user newer than [sinceId].
  Future<List<ServerMessage>?> fetch({
    required String email,
    int sinceId = 0,
  }) async {
    try {
      final res = await _http
          .post(_uri('messages.php'),
              headers: _headers,
              body: jsonEncode({'email': email, 'since_id': sinceId}))
          .timeout(const Duration(seconds: 20));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return null;
      return [
        for (final m in (json['messages'] as List? ?? []))
          ServerMessage.fromJson((m as Map).cast<String, dynamic>()),
      ];
    } catch (_) {
      return null;
    }
  }

  /// Sends a message. The server enforces the sender's rank/scope; returns the
  /// resolved target label on success, null on failure/denial.
  Future<String?> send({
    required String email,
    required String targetType,
    int? targetId,
    String? targetEmail,
    required String body,
  }) async {
    try {
      final res = await _http
          .post(_uri('messages_send.php'),
              headers: _headers,
              body: jsonEncode({
                'email': email,
                'target_type': targetType,
                'target_id': ?targetId,
                'target_email': ?targetEmail,
                'body': body,
              }))
          .timeout(const Duration(seconds: 20));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return null;
      return (json['target'] ?? '').toString();
    } catch (_) {
      return null;
    }
  }

  /// Users this sender may target individually (scope-filtered server-side).
  Future<List<MessageUser>> users({required String email}) async {
    try {
      final res = await _http
          .post(_uri('messages_users.php'),
              headers: _headers, body: jsonEncode({'email': email}))
          .timeout(const Duration(seconds: 20));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return const [];
      return [
        for (final u in (json['users'] as List? ?? []))
          MessageUser(
            email: ((u as Map)['email'] ?? '').toString(),
            name: (u['name'] ?? '').toString(),
            scope: (u['scope'] ?? '').toString(),
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  void dispose() => _http.close();
}
