import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;

const _categoryColors = {
  'Languages': '0xFF7F52FF', // Kotlin purple
  'Frameworks': '0xFF02569B', // Flutter blue
  'Skills': '0xFF4285F4', // Firebase blue
};

String _escape(String s) => s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

Future<void> main() async {
  final scriptDir = path.dirname(Platform.script.toFilePath());
  final projectRoot = path.dirname(scriptDir);
  final skillsPath = path.join(scriptDir, 'assets', 'skills.json');
  final outputPath = path.join(
    projectRoot,
    'lib',
    'app',
    'constants',
    'data',
    'skill.data.dart',
  );

  final file = File(skillsPath);
  if (!await file.exists()) {
    log('Error: $skillsPath not found.');
    exit(1);
  }

  final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final buffer = StringBuffer();

  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import '../../../core/models/skill.dart';");
  buffer.writeln();
  buffer.writeln('final List<Skill> skillList = <Skill>[');

  var count = 0;
  for (final entry in json.entries) {
    final category = entry.key;
    final color = _categoryColors[category] ?? '0xFF607D8B';
    final skills = entry.value as Map<String, dynamic>;
    for (final skillEntry in skills.entries) {
      final title = skillEntry.key;
      final imageUrl = skillEntry.value as String;
      buffer.writeln('  Skill(');
      buffer.writeln("    title: '${_escape(title)}',");
      buffer.writeln("    image: '${_escape(imageUrl)}',");
      buffer.writeln('    color: const Color($color),');
      buffer.writeln('  ),');
      count++;
    }
  }

  buffer.writeln('];');

  await File(outputPath).writeAsString(buffer.toString());
  log('Updated $outputPath with $count skills.');
}
