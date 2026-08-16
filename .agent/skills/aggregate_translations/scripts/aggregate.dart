import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final outputDirName = args.isNotEmpty ? args.first : 'build/aggregated_locales';
  final outputDir = Directory(outputDirName);

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final List<Directory> localeDirs = [];

  // 1. App-level locales
  final rootLocaleDir = Directory('assets/locales');
  if (rootLocaleDir.existsSync()) {
    localeDirs.add(rootLocaleDir);
  }

  // 2. Package-level locales
  final packagesDir = Directory('packages');
  if (packagesDir.existsSync()) {
    for (final package in packagesDir.listSync().whereType<Directory>()) {
      final packageLocaleDir = Directory('${package.path}/assets/locales');
      if (packageLocaleDir.existsSync()) {
        localeDirs.add(packageLocaleDir);
      }
    }
  }

  final Map<String, Map<String, dynamic>> aggregatedData = {};

  for (final dir in localeDirs) {
    final files = dir.listSync().whereType<File>();

    for (final file in files) {
      if (file.path.endsWith('.json')) {
        final fileName = file.uri.pathSegments.last;
        // e.g. en.i18n.json -> lang = en
        final lang = fileName.split('.').first;

        final content = file.readAsStringSync();
        Map<String, dynamic> jsonMap;
        try {
          jsonMap = json.decode(content);
        } catch (e) {
          print('Error parsing JSON from ${file.path}: $e');
          continue;
        }

        aggregatedData[lang] ??= {};
        aggregatedData[lang] = _deepMerge(aggregatedData[lang]!, jsonMap);
        print('Merged ${file.path} into $lang');
      }
    }
  }

  // 3. Write aggregated data to the output directory
  for (final entry in aggregatedData.entries) {
    final lang = entry.key;
    final data = entry.value;

    final outputFile = File('${outputDir.path}/$lang.json');
    final encoder = JsonEncoder.withIndent('  ');
    outputFile.writeAsStringSync(encoder.convert(data));
    print('✅ Generated ${outputFile.path}');
  }
}

/// Recursively deep merges [source] into [target].
Map<String, dynamic> _deepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
  final result = Map<String, dynamic>.from(target);

  source.forEach((key, value) {
    if (result.containsKey(key) &&
        result[key] is Map<String, dynamic> &&
        value is Map<String, dynamic>) {
      result[key] = _deepMerge(result[key], value);
    } else {
      result[key] = value;
    }
  });

  return result;
}
