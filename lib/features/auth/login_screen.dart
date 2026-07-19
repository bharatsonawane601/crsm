import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import 'auth_service.dart';

/// Bilingual sign-in with admin-issued credentials. Split layout on desktop:
/// navy brand panel (left) + form (right). Handles three states — normal login,
/// the forced first-password change, and the "Request ID & password" flow.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _busy = false;

  /// Non-null once a correct sign-in demands a new password: the change ticket.
  String? _changeToken;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _toast(String key, {CrmsToastType type = CrmsToastType.danger}) {
    if (!mounted) return;
    CrmsToast.show(context, title: key.tr(), type: type);
  }

  Future<void> _signIn() async {
    final id = _idCtrl.text.trim();
    final pw = _pwCtrl.text;
    if (id.isEmpty || pw.isEmpty) {
      _toast('access.error.credentials');
      return;
    }
    setState(() => _busy = true);
    final r = await ref.read(authControllerProvider.notifier).login(id, pw);
    if (!mounted) return;
    setState(() => _busy = false);
    _handleResult(r);
  }

  Future<void> _submitNewPassword() async {
    final pw = _newPwCtrl.text;
    final confirm = _confirmCtrl.text;
    if (pw.length < 8) {
      _toast('login.pwTooShort');
      return;
    }
    if (pw != confirm) {
      _toast('login.pwMismatch');
      return;
    }
    setState(() => _busy = true);
    final r = await ref
        .read(authControllerProvider.notifier)
        .changePassword(_changeToken!, pw);
    if (!mounted) return;
    setState(() => _busy = false);
    // On success the root gate swaps this screen out; otherwise show why.
    if (r.outcome != AuthOutcome.ok) {
      _handleResult(r, inChangeFlow: true);
    }
  }

  void _handleResult(AuthResult r, {bool inChangeFlow = false}) {
    switch (r.outcome) {
      case AuthOutcome.ok:
        break; // root gate takes over
      case AuthOutcome.mustChangePassword:
        setState(() {
          _changeToken = r.changeToken;
          _pwCtrl.clear();
        });
      case AuthOutcome.rejected:
        _toast(r.message ?? 'access.error.credentials');
        if (inChangeFlow) return;
      case AuthOutcome.networkError:
        _toast(r.message ?? 'access.error.network');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app.shortTitle'.tr()),
        actions: const [
          DarkModeToggle(),
          SizedBox(width: 8),
          Center(child: LanguageToggle()),
          SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final form = _changeToken != null ? _changeForm() : _loginForm();
          if (constraints.maxWidth < 820) return form;
          return Row(
            children: [
              const Expanded(flex: 4, child: _BrandPanel()),
              Expanded(flex: 6, child: form),
            ],
          );
        },
      ),
    );
  }

  Widget _shell(List<Widget> children) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      );

  Widget _loginForm() {
    final theme = Theme.of(context);
    return _shell([
      Text('login.heading'.tr(), style: theme.textTheme.headlineSmall),
      const SizedBox(height: AppSpacing.s2),
      Text('login.subheading'.tr(),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.s8),
      CrmsTextField(
        label: 'login.idLabel'.tr(),
        controller: _idCtrl,
        prefixIcon: PhosphorIconsRegular.identificationCard,
        nativeEditor: false,
      ),
      const SizedBox(height: AppSpacing.s5),
      CrmsTextField(
        label: 'login.passwordLabel'.tr(),
        controller: _pwCtrl,
        obscureText: true,
        prefixIcon: PhosphorIconsRegular.lock,
        nativeEditor: false,
      ),
      const SizedBox(height: AppSpacing.s8),
      CrmsButton(
        label: _busy ? 'login.signingIn'.tr() : 'login.signIn'.tr(),
        icon: PhosphorIconsRegular.signIn,
        loading: _busy,
        expand: true,
        onPressed: _busy ? null : _signIn,
      ),
      const SizedBox(height: AppSpacing.s6),
      const Divider(),
      const SizedBox(height: AppSpacing.s4),
      Text('login.noAccount'.tr(),
          style: AppType.caption
              .copyWith(color: theme.colorScheme.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.s3),
      CrmsButton(
        label: 'login.requestButton'.tr(),
        icon: PhosphorIconsRegular.userPlus,
        variant: CrmsButtonVariant.secondary,
        expand: true,
        onPressed: _busy ? null : _openRequestSheet,
      ),
    ]);
  }

  Widget _changeForm() {
    final theme = Theme.of(context);
    return _shell([
      Row(children: [
        Icon(PhosphorIconsRegular.shieldCheck,
            color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Text('login.changeTitle'.tr(),
              style: theme.textTheme.headlineSmall),
        ),
      ]),
      const SizedBox(height: AppSpacing.s2),
      Text('login.changeBody'.tr(),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.s8),
      CrmsTextField(
        label: 'login.newPassword'.tr(),
        controller: _newPwCtrl,
        obscureText: true,
        prefixIcon: PhosphorIconsRegular.lock,
        nativeEditor: false,
        helperText: 'login.pwTooShort'.tr(),
      ),
      const SizedBox(height: AppSpacing.s5),
      CrmsTextField(
        label: 'login.confirmPassword'.tr(),
        controller: _confirmCtrl,
        obscureText: true,
        prefixIcon: PhosphorIconsRegular.lockKey,
        nativeEditor: false,
      ),
      const SizedBox(height: AppSpacing.s8),
      CrmsButton(
        label: 'login.changeButton'.tr(),
        icon: PhosphorIconsRegular.check,
        loading: _busy,
        expand: true,
        onPressed: _busy ? null : _submitNewPassword,
      ),
    ]);
  }

  Future<void> _openRequestSheet() async {
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RequestSheet(
        onSubmit: (data) => ref.read(authControllerProvider.notifier).requestAccess(
              name: data.name,
              phone: data.phone,
              designation: data.designation,
              gender: data.gender,
              station: data.station,
              recoveryEmail: data.recoveryEmail,
              note: data.note,
            ),
      ),
    );
    if (sent == true) {
      _toast('login.requestSent', type: CrmsToastType.success);
    } else if (sent == false) {
      _toast('login.requestFailed');
    }
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.policeNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Icon(
                PhosphorIconsRegular.shieldChevron,
                size: 400,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const CrmsLogo(size: 168),
                const SizedBox(height: AppSpacing.s8),
                Text('app.title'.tr(),
                    style: AppType.h1.copyWith(color: Colors.white)),
                const SizedBox(height: AppSpacing.s6),
                Container(
                  padding: const EdgeInsets.only(left: AppSpacing.s4),
                  decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: AppColors.policeKhaki, width: 3)),
                  ),
                  child: Text(
                    'login.quote'.tr(),
                    style: AppType.h3.copyWith(
                      color: AppColors.policeKhakiLight,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text('© Maharashtra Police',
                    style:
                        AppType.caption.copyWith(color: AppColors.policeKhaki)),
                const SizedBox(height: AppSpacing.s4),
                const PoweredByStrip(onDark: true, center: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestData {
  _RequestData(this.name, this.phone, this.designation, this.gender,
      this.station, this.recoveryEmail, this.note);
  final String name, phone, designation, gender, station, recoveryEmail, note;
}

/// The "Request ID & password" form. Returns true/false (sent/failed) to the
/// caller via Navigator.pop, or null if dismissed.
class _RequestSheet extends StatefulWidget {
  const _RequestSheet({required this.onSubmit});
  final Future<bool> Function(_RequestData) onSubmit;

  @override
  State<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<_RequestSheet> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _designation = TextEditingController();
  final _station = TextEditingController();
  final _email = TextEditingController();
  final _note = TextEditingController();
  String _gender = '';
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _designation.dispose();
    _station.dispose();
    _email.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      CrmsToast.show(context,
          title: 'login.requestNeedFields'.tr(), type: CrmsToastType.danger);
      return;
    }
    setState(() => _busy = true);
    final ok = await widget.onSubmit(_RequestData(
      _name.text.trim(),
      _phone.text.trim(),
      _designation.text.trim(),
      _gender,
      _station.text.trim(),
      _email.text.trim(),
      _note.text.trim(),
    ));
    if (!mounted) return;
    Navigator.of(context).pop(ok);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.s8, 0, AppSpacing.s8, AppSpacing.s8 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('login.requestTitle'.tr(),
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.s2),
            Text('login.requestBody'.tr(),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.s6),
            CrmsTextField(
                label: 'login.fName'.tr(), controller: _name, required: true),
            const SizedBox(height: AppSpacing.s4),
            CrmsTextField(
              label: 'login.fPhone'.tr(),
              controller: _phone,
              required: true,
              keyboardType: TextInputType.phone,
              nativeEditor: false,
            ),
            const SizedBox(height: AppSpacing.s4),
            CrmsTextField(
                label: 'login.fDesignation'.tr(), controller: _designation),
            const SizedBox(height: AppSpacing.s4),
            _GenderPicker(
                value: _gender, onChanged: (g) => setState(() => _gender = g)),
            const SizedBox(height: AppSpacing.s4),
            CrmsTextField(
                label: 'login.fStation'.tr(), controller: _station),
            const SizedBox(height: AppSpacing.s4),
            CrmsTextField(
              label: 'login.fRecoveryEmail'.tr(),
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              nativeEditor: false,
            ),
            const SizedBox(height: AppSpacing.s4),
            CrmsTextField(
                label: 'login.fNote'.tr(), controller: _note, maxLines: 2),
            const SizedBox(height: AppSpacing.s6),
            Row(
              children: [
                Expanded(
                  child: CrmsButton(
                    label: 'login.cancel'.tr(),
                    variant: CrmsButtonVariant.secondary,
                    expand: true,
                    onPressed:
                        _busy ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: CrmsButton(
                    label: 'login.submitRequest'.tr(),
                    icon: PhosphorIconsRegular.paperPlaneTilt,
                    loading: _busy,
                    expand: true,
                    onPressed: _busy ? null : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('login.fGender'.tr(),
            style: AppType.caption
                .copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.s2),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'male', label: Text('crime.gender.male'.tr())),
            ButtonSegment(
                value: 'female', label: Text('crime.gender.female'.tr())),
            ButtonSegment(
                value: 'other', label: Text('crime.gender.other'.tr())),
          ],
          selected: {value.isEmpty ? 'male' : value},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}
