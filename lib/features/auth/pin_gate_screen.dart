import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import 'auth_service.dart';
import 'pin_service.dart';

/// Sits between the access-approved gate and the app shell. On first run after
/// approval it asks the user to create a 6-digit PIN; on every later launch it
/// asks for that PIN. Calls [onUnlocked] once the PIN is accepted/created.
class PinGateScreen extends ConsumerStatefulWidget {
  const PinGateScreen({super.key, required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  ConsumerState<PinGateScreen> createState() => _PinGateScreenState();
}

enum _PinStep { loading, create, confirm, enter }

class _PinGateScreenState extends ConsumerState<PinGateScreen> {
  final _pin = PinService();
  final _controller = TextEditingController();
  final _focus = FocusNode();

  _PinStep _step = _PinStep.loading;
  String _firstEntry = '';
  String? _error;
  bool _busy = false;

  /// Seconds left of the failed-attempts lockout; 0 = entry allowed.
  int _lockSeconds = 0;
  Timer? _lockTimer;

  String get _email =>
      ref.read(authControllerProvider).value?.email ?? '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final has = await _pin.hasPinFor(_email);
    if (!mounted) return;
    setState(() => _step = has ? _PinStep.enter : _PinStep.create);
    if (has) await _refreshLockout();
    _focus.requestFocus();
  }

  /// Reads the persistent lockout and, while active, ticks a 1s countdown.
  Future<void> _refreshLockout() async {
    final left = await _pin.remainingLockout();
    if (!mounted) return;
    setState(() => _lockSeconds = left.inSeconds);
    _lockTimer?.cancel();
    if (left > Duration.zero) {
      _lockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        setState(() {
          _lockSeconds = (_lockSeconds - 1).clamp(0, 1 << 31);
          if (_lockSeconds == 0) {
            t.cancel();
            _error = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _reset() {
    _controller.clear();
    setState(() {});
    _focus.requestFocus();
  }

  Future<void> _submit() async {
    final value = _controller.text;
    if (value.length != PinService.pinLength) {
      setState(() => _error = 'pin.tooShort'.tr());
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });

    switch (_step) {
      case _PinStep.create:
        _firstEntry = value;
        setState(() {
          _step = _PinStep.confirm;
          _busy = false;
        });
        _reset();
      case _PinStep.confirm:
        if (value != _firstEntry) {
          setState(() {
            _step = _PinStep.create;
            _busy = false;
            _error = 'pin.mismatch'.tr();
            _firstEntry = '';
          });
          _reset();
          return;
        }
        await _pin.setPin(_email, value);
        if (!mounted) return;
        widget.onUnlocked();
      case _PinStep.enter:
        if (_lockSeconds > 0) {
          setState(() => _busy = false);
          return;
        }
        final ok = await _pin.verify(_email, value);
        if (!mounted) return;
        if (ok) {
          widget.onUnlocked();
        } else {
          await _refreshLockout();
          if (!mounted) return;
          setState(() {
            _busy = false;
            _error = _lockSeconds > 0 ? null : 'pin.wrong'.tr();
          });
          _reset();
        }
      case _PinStep.loading:
        break;
    }
  }

  ({String title, String body, String cta}) get _copy => switch (_step) {
        _PinStep.create => (
            title: 'pin.createTitle'.tr(),
            body: 'pin.createBody'.tr(),
            cta: 'pin.set'.tr(),
          ),
        _PinStep.confirm => (
            title: 'pin.confirmTitle'.tr(),
            body: 'pin.confirmBody'.tr(),
            cta: 'pin.set'.tr(),
          ),
        _ => (
            title: 'pin.enterTitle'.tr(),
            body: 'pin.enterBody'.tr(),
            cta: 'pin.unlock'.tr(),
          ),
      };

  @override
  Widget build(BuildContext context) {
    if (_step == _PinStep.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final copy = _copy;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CrmsLogo(size: 84),
                const SizedBox(height: AppSpacing.s6),
                Icon(PhosphorIconsRegular.lockKey,
                    size: 36,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: AppSpacing.s4),
                Text(copy.title, textAlign: TextAlign.center, style: AppType.h2),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  copy.body,
                  textAlign: TextAlign.center,
                  style: AppType.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.s6),
                _PinBoxes(
                  controller: _controller,
                  focusNode: _focus,
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                  onCompleted: (_) => _submit(),
                ),
                if (_lockSeconds > 0) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Text(
                    'pin.lockedOut'
                        .tr(namedArgs: {'seconds': '$_lockSeconds'}),
                    textAlign: TextAlign.center,
                    style: AppType.bodySm
                        .copyWith(color: AppColors.dangerRed),
                  ),
                ] else if (_error != null) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Text(_error!,
                      style: AppType.bodySm
                          .copyWith(color: AppColors.dangerRed)),
                ],
                const SizedBox(height: AppSpacing.s6),
                CrmsButton(
                  label: copy.cta,
                  expand: true,
                  loading: _busy,
                  onPressed: _lockSeconds > 0 ? null : _submit,
                ),
                const SizedBox(height: AppSpacing.s3),
                CrmsButton(
                  label: 'pin.useDifferentAccount'.tr(),
                  variant: CrmsButtonVariant.ghost,
                  icon: PhosphorIconsRegular.signOut,
                  expand: true,
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Six boxes backed by a single hidden field, so physical-keyboard typing and
/// paste both work on desktop.
class _PinBoxes extends StatelessWidget {
  const _PinBoxes({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  static const _len = PinService.pinLength;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: focusNode.requestFocus,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_len, (i) {
                  final filled = i < value.text.length;
                  final active = i == value.text.length && focusNode.hasFocus;
                  return Container(
                    width: 44,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: active ? AppColors.policeNavy : scheme.outline,
                        width: active ? 2 : 1,
                      ),
                    ),
                    child: Text(filled ? '●' : '',
                        style: AppType.h2.copyWith(color: scheme.onSurface)),
                  );
                }),
              );
            },
          ),
          // Transparent capture field on top of the boxes.
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: _len * 52,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: _len,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_len),
                ],
                onChanged: (v) {
                  onChanged(v);
                  if (v.length == _len) onCompleted(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
