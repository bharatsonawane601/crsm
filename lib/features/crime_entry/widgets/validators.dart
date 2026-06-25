import 'package:easy_localization/easy_localization.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Localized field validators (PROJECT.md rule 6 — every form is validated).
/// Messages come from the i18n files so they switch with the language.
class V {
  V._();

  /// Required, non-empty.
  static String? required(String? value) =>
      FormBuilderValidators.required(errorText: 'validation.required'.tr())(
          value);

  /// Optional integer (empty is allowed).
  static String? optInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return FormBuilderValidators.integer(errorText: 'validation.number'.tr())(
        value);
  }

  /// Optional decimal number (for ₹ values).
  static String? optNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return FormBuilderValidators.numeric(errorText: 'validation.number'.tr())(
        value);
  }

  /// Optional 10-digit mobile.
  static String? optMobile(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return FormBuilderValidators.match(
      RegExp(r'^\d{10}$'),
      errorText: 'validation.mobile'.tr(),
    )(value);
  }

  /// Optional 12-digit Aadhaar (allows spaces, validates the digits).
  static String? optAadhaar(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\s'), '');
    return FormBuilderValidators.match(
      RegExp(r'^\d{12}$'),
      errorText: 'validation.aadhaar'.tr(),
    )(digits);
  }

  /// Optional email.
  static String? optEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return FormBuilderValidators.email(errorText: 'validation.email'.tr())(
        value);
  }
}
