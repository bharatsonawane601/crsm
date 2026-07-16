import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/update/update_models.dart';
import 'package:crms/features/update/update_service.dart';

void main() {
  final svc = UpdateService();

  group('versionToBuild (must match the PHP versionToBuild on the server)', () {
    test('maps major.minor.patch to one comparable integer', () {
      expect(svc.versionToBuild('1.0.0'), 1000000);
      expect(svc.versionToBuild('1.12.6'), 1012006);
      expect(svc.versionToBuild('2.0.0'), 2000000);
    });

    test('ignores the +build suffix', () {
      expect(svc.versionToBuild('1.12.6+28'), svc.versionToBuild('1.12.6'));
    });

    test('ordering is monotonic across releases', () {
      expect(svc.versionToBuild('1.12.6') > svc.versionToBuild('1.12.5'), isTrue);
      expect(svc.versionToBuild('1.13.0') > svc.versionToBuild('1.12.99'), isTrue);
      expect(svc.versionToBuild('2.0.0') > svc.versionToBuild('1.999.999'), isTrue);
    });

    test('non-numeric / empty parts degrade to 0, never throw', () {
      expect(svc.versionToBuild(''), 0);
      expect(svc.versionToBuild('abc'), 0);
      expect(svc.versionToBuild('1'), 1000000);
    });
  });

  group('AppRelease.fromJson (version.php payload)', () {
    test('parses a full mandatory release', () {
      final r = AppRelease.fromJson({
        'version': '1.13.0',
        'build': 1013000,
        'notes': 'Fixes',
        'mandatory': true,
        'sha256': 'ABCDEF',
        'url': 'https://x/api/releases/crms-setup-1.13.0.exe',
      });
      expect(r.version, '1.13.0');
      expect(r.build, 1013000);
      expect(r.mandatory, isTrue);
      expect(r.sha256, 'ABCDEF');
    });

    test('mandatory accepts int 1 and string "1"/"true"', () {
      expect(AppRelease.fromJson({'version': '1', 'mandatory': 1}).mandatory,
          isTrue);
      expect(AppRelease.fromJson({'version': '1', 'mandatory': '1'}).mandatory,
          isTrue);
      expect(
          AppRelease.fromJson({'version': '1', 'mandatory': 'true'}).mandatory,
          isTrue);
      expect(AppRelease.fromJson({'version': '1', 'mandatory': 0}).mandatory,
          isFalse);
    });

    test('blank sha256 becomes null (no false checksum check)', () {
      expect(AppRelease.fromJson({'version': '1', 'sha256': ''}).sha256, isNull);
    });
  });
}
