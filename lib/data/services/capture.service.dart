import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class CaptureService {
  /// Captures the widget associated with [repaintBoundaryKey] as a PNG image,
  /// saves it to a temporary file, and returns the [File] instance.
  static Future<File?> capturePng(GlobalKey repaintBoundaryKey) async {
    try {
      // Obtain the RenderRepaintBoundary from the provided GlobalKey.
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Capture the image using the device's pixel ratio for high resolution.
      final context = repaintBoundaryKey.currentContext;
      if (context == null) return null;
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: devicePixelRatio);

      // Convert the captured image to PNG byte data.
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save the PNG bytes to a temporary file.
      final tempDir = await getTemporaryDirectory();
      final fileName = 'capture_${DateTime.now().toIso8601String()}.png';
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }
}
