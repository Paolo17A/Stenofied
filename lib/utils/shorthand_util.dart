import 'dart:convert';

import 'package:flutter/services.dart' as services;

class ShortHandUtil {
  static Map<String, String> vectorMap = {};
  static Future initializeVectorMap() async {
    final manifestContent =
        await services.rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap =
        Map<String, dynamic>.from(json.decode(manifestContent));
    final List<String> filePaths = manifestMap.keys
        .where((String key) => key.contains('assets/vectors/'))
        .toList();
    print('vector files found: ${filePaths.length}');
    for (var filePath in filePaths) {
      String fileName = filePath.split('assets/vectors/').last;
      String extractedLetter = fileName.split('.').first;
      vectorMap[extractedLetter] = filePath;
    }
  }
}
