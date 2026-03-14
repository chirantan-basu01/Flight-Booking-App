import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';

class BoardingPassExport {
  static final ScreenshotController _screenshotController = ScreenshotController();

  static ScreenshotController get controller => _screenshotController;

  /// Capture and save boarding pass as high-resolution image to gallery
  static Future<String?> saveToGallery(BuildContext context) async {
    try {
      // Check if we have permission to access gallery
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        // Request permission
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permission denied. Please allow photo access in settings.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return null;
        }
      }

      // Capture with high pixel ratio for scannable barcode quality
      final Uint8List? image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 100),
      );

      if (image == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to capture boarding pass'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      }

      // Save to temporary file first
      final directory = await getTemporaryDirectory();
      final fileName = 'boarding_pass_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(image);

      // Save to gallery using Gal
      await Gal.putImage(filePath, album: 'Boarding Passes');

      return filePath;
    } on GalException catch (e) {
      debugPrint('Gal error: ${e.type.name}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.type.name}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error saving boarding pass: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  /// Share boarding pass
  static Future<void> share(BuildContext context) async {
    try {
      final Uint8List? image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 100),
      );

      if (image == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to capture boarding pass'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Save to temporary directory for sharing
      final directory = await getTemporaryDirectory();
      final fileName = 'boarding_pass_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(image);

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'My Boarding Pass',
        subject: 'Boarding Pass',
      );
    } catch (e) {
      debugPrint('Error sharing boarding pass: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share boarding pass'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}