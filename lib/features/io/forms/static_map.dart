import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

/// Builds a static map PNG centred on [lat]/[lng] by stitching OpenStreetMap
/// tiles (no API key required) and stamping a marker at the centre. Returns null
/// on any network/decoding failure so the caller can fall back to plain
/// coordinates. Used to auto-place a scene map into the Crime Details form's Map
/// box from the GPS captured at the scene.
Future<Uint8List?> fetchStaticMap({
  required double lat,
  required double lng,
  int zoom = 16,
  int width = 620,
  int height = 360,
}) async {
  final n = 1 << zoom;
  final latRad = lat * pi / 180.0;
  final fx = (lng + 180.0) / 360.0 * n;
  final fy = (1 - (log(tan(latRad) + 1 / cos(latRad)) / pi)) / 2 * n;
  final centerX = fx * 256.0;
  final centerY = fy * 256.0;
  final left = centerX - width / 2;
  final top = centerY - height / 2;

  final x0 = (left / 256).floor();
  final x1 = ((left + width) / 256).floor();
  final y0 = (top / 256).floor();
  final y1 = ((top + height) / 256).floor();

  final canvas = img.Image(width: width, height: height);
  img.fill(canvas, color: img.ColorRgb8(233, 233, 233));

  final client = http.Client();
  var placed = 0;
  try {
    for (var tx = x0; tx <= x1; tx++) {
      for (var ty = y0; ty <= y1; ty++) {
        if (tx < 0 || ty < 0 || tx >= n || ty >= n) continue;
        final res = await client.get(
          Uri.parse('https://tile.openstreetmap.org/$zoom/$tx/$ty.png'),
          headers: {'User-Agent': 'CRMS-IO/1.0 (police case records)'},
        ).timeout(const Duration(seconds: 12));
        if (res.statusCode != 200) continue;
        final tile = img.decodePng(res.bodyBytes) ?? img.decodeImage(res.bodyBytes);
        if (tile == null) continue;
        img.compositeImage(canvas, tile,
            dstX: (tx * 256 - left).round(), dstY: (ty * 256 - top).round());
        placed++;
      }
    }
  } catch (_) {
    return null;
  } finally {
    client.close();
  }
  if (placed == 0) return null;

  // Centre marker (a red dot with a white ring).
  final cx = width ~/ 2, cy = height ~/ 2;
  img.fillCircle(canvas, x: cx, y: cy, radius: 8, color: img.ColorRgb8(255, 255, 255));
  img.fillCircle(canvas, x: cx, y: cy, radius: 6, color: img.ColorRgb8(200, 0, 0));
  return Uint8List.fromList(img.encodePng(canvas));
}
