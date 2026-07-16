import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Opens a full-screen on-screen signature pad. Returns the signature as PNG
/// bytes, or null if cancelled / empty.
Future<Uint8List?> showSignaturePad(BuildContext context) {
  return showDialog<Uint8List>(
    context: context,
    builder: (_) => const Dialog.fullscreen(child: _SignaturePad()),
  );
}

class _SignaturePad extends StatefulWidget {
  const _SignaturePad();

  @override
  State<_SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<_SignaturePad> {
  final _boundaryKey = GlobalKey();
  final List<List<Offset>> _strokes = [];

  void _start(Offset p) => setState(() => _strokes.add([p]));
  void _move(Offset p) => setState(() {
        if (_strokes.isNotEmpty) _strokes.last.add(p);
      });

  Future<void> _done() async {
    if (_strokes.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final boundary = _boundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.5);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    Navigator.pop(context, data?.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('io.signature'.tr()),
        actions: [
          TextButton(
            onPressed: () => setState(_strokes.clear),
            child: Text('io.clear'.tr()),
          ),
          FilledButton(
            onPressed: _done,
            child: Text('common.save'.tr()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RepaintBoundary(
          key: _boundaryKey,
          child: Container(
            color: Colors.white,
            child: GestureDetector(
              onPanStart: (d) => _start(d.localPosition),
              onPanUpdate: (d) => _move(d.localPosition),
              child: CustomPaint(
                painter: _SignaturePainter(_strokes),
                size: Size.infinite,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);
  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      for (var i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
      if (stroke.length == 1) {
        canvas.drawPoints(ui.PointMode.points, [stroke.first], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => true;
}
