#!/usr/bin/env dart

import 'dart:io';

/// Dart Barrel File Generator
///
/// This script automatically generates barrel files (index files) for Dart projects.
/// A barrel file exports all Dart files in a directory, making imports cleaner.
///
/// Usage:
///   dart barrel_generator.dart [directory]
///
/// Example:
///   dart barrel_generator.dart lib/screens
///   dart barrel_generator.dart lib/widgets
///   dart barrel_generator.dart lib/services

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    // ignore: avoid_print
    print('Usage: dart barrel_generator.dart <directory>');
    // ignore: avoid_print
    print('Example: dart barrel_generator.dart lib/screens');
    exit(1);
  }

  final directoryPath = arguments[0];
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    // ignore: avoid_print
    print('Error: Directory "$directoryPath" does not exist.');
    exit(1);
  }

  generateBarrelFile(directory);
}

void generateBarrelFile(Directory directory) {
  final dirPath = directory.path;
  final dirName = directory.path.split('/').last;

  // ignore: avoid_print
  print('Generating barrel file for: $dirPath');

  // Get all .dart files in the directory (excluding the barrel file itself)
  final dartFiles = directory
      .listSync()
      .whereType<File>()
      .where(
        (file) =>
            file.path.endsWith('.dart') &&
            !file.path.endsWith('$dirName.dart') &&
            !file.path.contains('/.'),
      )
      .toList();

  if (dartFiles.isEmpty) {
    // ignore: avoid_print
    print('No Dart files found in $dirPath');
    return;
  }

  // Sort files alphabetically
  dartFiles.sort((a, b) => a.path.compareTo(b.path));

  // Generate export statements
  final exports = <String>[];
  for (final file in dartFiles) {
    final fileName = file.path.split('/').last;
    exports.add("export '$fileName';");
  }

  // Create barrel file content
  final barrelContent =
      '''
// Barrel file for $dirName
// Generated automatically - do not edit manually

${exports.join('\n')}
''';

  // Write barrel file
  final barrelFile = File('$dirPath/$dirName.dart');
  barrelFile.writeAsStringSync(barrelContent);

  // ignore: avoid_print
  print('✅ Created: ${barrelFile.path}');
  // ignore: avoid_print
  print('   Exported ${dartFiles.length} files:');
  for (final file in dartFiles) {
    final fileName = file.path.split('/').last;
    // ignore: avoid_print
    print('   - $fileName');
  }
}
