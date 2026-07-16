import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import 'io_forms_catalog.dart';

/// A clean, printable A4 rendering of one filled form. Captured to PNG →
/// embedded in a PDF (so Marathi shapes correctly). This is the shared, generic
/// layout; pixel-exact per-form replicas reuse the same [values] later.
class IoFormPrintView extends StatelessWidget {
  const IoFormPrintView({
    super.key,
    required this.spec,
    required this.values,
    required this.parties,
    required this.exhibits,
  });

  final IoFormSpec spec;
  final Map<String, dynamic> values;
  final List<IoParty> parties;
  final List<IoExhibit> exhibits;

  static const _font = 'NotoSansDevanagari';

  @override
  Widget build(BuildContext context) {
    final rows = <IoField>[for (final f in spec.fields) f];
    return Container(
      width: 794,
      color: Colors.white,
      padding: const EdgeInsets.all(28),
      child: DefaultTextStyle(
        style: const TextStyle(
            fontFamily: _font, color: Colors.black, fontSize: 12, height: 1.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(spec.mr,
                  style: const TextStyle(
                      fontFamily: _font,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
            Center(
              child: Text(spec.en,
                  style: const TextStyle(
                      fontFamily: _font, fontSize: 11, color: Colors.black54)),
            ),
            const SizedBox(height: 6),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 6),
            // Field grid: label → value.
            Table(
              border: TableBorder.all(color: Colors.black26),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                for (final f in rows)
                  TableRow(children: [
                    _cell(f.mr, bold: true),
                    _cell(_display(f)),
                  ]),
              ],
            ),
            if (parties.isNotEmpty) ...[
              const SizedBox(height: 12),
              _sectionTitle('संबंधित व्यक्ती / Persons'),
              Table(
                border: TableBorder.all(color: Colors.black26),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  for (final p in parties)
                    TableRow(children: [
                      _cell(_roleMr(p.role), bold: true),
                      _cell(p.name),
                    ]),
                ],
              ),
            ],
            if (exhibits.isNotEmpty && spec.usesExhibits) ...[
              const SizedBox(height: 12),
              _sectionTitle('मुद्देमाल / Seized property'),
              Table(
                border: TableBorder.all(color: Colors.black26),
                columnWidths: const {
                  0: FlexColumnWidth(0.6),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(1.4),
                },
                children: [
                  for (var i = 0; i < exhibits.length; i++)
                    TableRow(children: [
                      _cell('${i + 1}'),
                      _cell(exhibits[i].description),
                      _cell(exhibits[i].value != null
                          ? '₹${exhibits[i].value!.toStringAsFixed(0)}'
                          : ''),
                    ]),
                ],
              ),
            ],
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _signLine('पंच १'),
                _signLine('पंच २'),
                _signLine('तपासी अंमलदार'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _display(IoField f) {
    final v = values[f.id];
    if (v == null) return '';
    if (v is bool) return v ? 'होय / Yes' : 'नाही / No';
    return v.toString();
  }

  Widget _cell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(text,
            style: TextStyle(
                fontFamily: _font,
                fontSize: 12,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
      );

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(t,
            style: const TextStyle(
                fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w700)),
      );

  Widget _signLine(String label) => Column(
        children: [
          Container(width: 130, height: 1, color: Colors.black),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontFamily: _font, fontSize: 11)),
        ],
      );

  String _roleMr(String role) => switch (role) {
        'complainant' => 'फिर्यादी',
        'accused' => 'आरोपी',
        'panch' => 'पंच',
        'deceased' => 'मृत',
        'witness' => 'साक्षीदार',
        'io' => 'तपासी अंमलदार',
        _ => role,
      };
}
