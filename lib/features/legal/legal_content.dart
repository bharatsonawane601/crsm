import '../../core/branding.dart';

/// Legal documents shown in Settings → Legal & About. These are general
/// templates tailored for CRMS; have them reviewed by a lawyer before relying
/// on them for a specific deployment.
abstract final class LegalContent {
  /// Last revision date shown on each document.
  static const String effectiveDate = '21 June 2026';

  static const String _company = Branding.companyName; // DB Square Technology
  static const String _site = Branding.websiteLabel;
  static const String _email = Branding.supportEmail;

  // -------------------------------------------------------------------------
  static String get privacyPolicy => '''
PRIVACY POLICY
$_company — CRMS (Crime Records Management System)
Effective date: $effectiveDate

1. Who we are
CRMS is software developed and maintained by $_company ("we", "us"). The
police unit/department operating the software is the owner ("controller") of
the records entered into it; $_company acts only as the technology provider
("processor").

2. Data the software handles
• Account / sign-in: your Google account email (and name/photo) used to sign
  in and to be approved for access.
• Device identifier: a one-way hardware ID (HWID) used only to lock a licence
  to one computer and prevent unauthorised copying.
• Case records: FIR/crime data you enter (complainant, accused, sections,
  property, investigation, attachments, custom fields, etc.).
• Sensitive identifiers (Aadhaar, PAN): when entered, these are encrypted
  (AES) before being stored.

3. Where data is stored
All case data is stored locally on the police computer in an encrypted
database. The software is offline-first. If Google Drive sync is enabled, an
encrypted copy is placed in your chosen Drive folder and uploaded by Google
Drive under the department's own Google account.

4. What we do NOT do
• We do not sell, rent, or share your case data with third parties.
• We do not transmit your case records to $_company's servers. Only your
  sign-in email + device ID are sent to the access/licence server to verify
  approval and subscription status.

5. Security
Data at rest is encrypted; sensitive identifiers use additional field-level
encryption. Access requires Google sign-in, admin approval, a per-device lock,
and a 6-digit launch PIN. Keep your PIN and backups confidential.

6. Retention
Case records remain until the department deletes them or removes the software.
Backups exist until you delete them. Sign-in/licence records are kept while the
account is active.

7. Your responsibilities (department)
As the data controller, the operating department is responsible for lawful use,
access control, retention schedules, and responding to any legal/RTI requests
regarding the records it stores.

8. Contact
Questions about this policy or the software: $_email
Website: $_site
''';

  // -------------------------------------------------------------------------
  static String get termsLicense => '''
TERMS OF USE & SOFTWARE LICENCE (EULA)
$_company — CRMS (Crime Records Management System)
Effective date: $effectiveDate

1. Licence
$_company grants the authorised department/officer a non-exclusive,
non-transferable licence to use CRMS on approved devices for official policing
work, for the duration of a valid, paid subscription/approval.

2. Restrictions
You may not: (a) copy, resell, sublicence, rent, or distribute the software;
(b) reverse engineer, decompile, or attempt to extract source code; (c) remove
or alter branding, copyright, or licence notices; (d) bypass the access,
device-lock, PIN, or subscription controls; (e) use the software for any
unlawful purpose.

3. Access, devices & subscription
Access is granted by administrator approval and is locked to one device per
account (HWID). Use beyond an expired subscription, on an unapproved device, or
with revoked access may be blocked. Mandatory updates may be required to keep
using the software.

4. Ownership
The software, its design, code, and all intellectual property remain the
exclusive property of $_company. Case data entered by the department remains
the property of that department.

5. Updates
The software may check for and install updates. Updates may add, change, or
remove features and are provided under these same terms.

6. Disclaimer of warranty
The software is provided "AS IS" without warranties of any kind. $_company does
not warrant that it will be error-free or uninterrupted. The department is
responsible for the accuracy of the records it enters and for keeping backups.

7. Limitation of liability
To the maximum extent permitted by law, $_company shall not be liable for any
indirect, incidental, or consequential loss, loss of data, or loss arising from
misuse, unauthorised access, or failure to maintain backups. Total liability is
limited to the fees paid for the current subscription term.

8. Termination
This licence ends automatically if its terms are breached or the subscription
lapses. On termination you must stop using the software.

9. Governing law
These terms are governed by the laws of India, with jurisdiction in the courts
of Maharashtra, unless otherwise agreed in a separate written contract.

10. Contact
$_email — $_site
''';

  // -------------------------------------------------------------------------
  static String get copyrightPatent => '''
COPYRIGHT, TRADEMARK & PATENT NOTICE
$_company — CRMS (Crime Records Management System)
Effective date: $effectiveDate

© ${_year()} $_company. All rights reserved.

1. Copyright
CRMS, including its source code, user interface, design, layouts, reports,
templates, icons, and documentation, is the original work of $_company and is
protected by the Copyright Act, 1957 (India) and applicable international
copyright law. Unauthorised copying, distribution, or modification is
prohibited.

2. Trademarks
"CRMS", the CRMS logo, and "$_company" (name and logo) are trademarks of
$_company. They may not be used without prior written permission.

3. Patent / proprietary rights
The methods, workflows, and technical implementation of CRMS — including its
access-approval, device-locking, subscription, and update mechanisms — are the
proprietary intellectual property of $_company. All rights, including any
patent rights that may apply, are reserved. Any patents or applications, where
filed, remain the property of $_company.

4. Third-party components
This software uses open-source components (e.g. the Flutter framework and
related libraries), each under its own licence. Those licences are respected
and the components remain the property of their respective owners.

5. Reservation of rights
No part of CRMS may be reproduced, distributed, reverse-engineered, or used to
create derivative works without the express written consent of $_company.

6. Contact
For licensing, permissions, or IP enquiries: $_email — $_site
''';

  static int _year() => DateTime.now().year;
}
