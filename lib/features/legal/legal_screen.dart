import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/branding.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/platform/open_url.dart';
import 'legal_content.dart';

/// Which legal document to display.
enum LegalDoc { privacy, terms, copyright }

/// Full-screen reader for a single legal document.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  String get _title => switch (doc) {
        LegalDoc.privacy => 'legal.privacy'.tr(),
        LegalDoc.terms => 'legal.terms'.tr(),
        LegalDoc.copyright => 'legal.copyright'.tr(),
      };

  String get _body => switch (doc) {
        LegalDoc.privacy => LegalContent.privacyPolicy,
        LegalDoc.terms => LegalContent.termsLicense,
        LegalDoc.copyright => LegalContent.copyrightPatent,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(_body, style: AppType.body),
                  const SizedBox(height: AppSpacing.s6),
                  TextButton.icon(
                    onPressed: () => openUrl(Branding.website),
                    icon: const Icon(PhosphorIconsRegular.globe, size: 16),
                    label: Text(Branding.websiteLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pushes the reader for [doc].
void openLegal(BuildContext context, LegalDoc doc) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => LegalScreen(doc: doc)),
  );
}
