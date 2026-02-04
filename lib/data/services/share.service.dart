import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  /// Shares a file using the share_plus package.
  static Future<void> shareFile(String filePath,
      {String? text, String? subject}) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: text,
        subject: subject,
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }
}
