/// Vendor / company branding shown on the welcome and waiting-for-approval
/// screens. Edit these in one place to rebrand.
abstract final class Branding {
  /// The company that builds & supports the software.
  static const String companyName = 'DB Square Technology';

  /// Public website (opened from the "Visit website" button).
  static const String website = 'https://dbsquaretechnology.com';

  /// Shown without the scheme on screen.
  static const String websiteLabel = 'dbsquaretechnology.com';

  /// Support contact details (optional — leave blank to hide a line).
  static const String supportEmail = 'support@dbsquaretechnology.com';
  static const String supportPhone = '';

  /// Asset path for the company logo. Drop the real file here; a styled
  /// fallback is shown until it exists.
  static const String companyLogoAsset = 'assets/images/company_logo.webp';

  /// Maharashtra Police emblem, shown in the app-shell sidebar header. Drop the
  /// official round emblem PNG here; until then a shield icon stands in, so the
  /// build never breaks on a missing file.
  static const String policeLogoAsset = 'assets/images/maharashtra_police.jpg';
}
