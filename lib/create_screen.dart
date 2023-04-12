import 'dart:io';

void main(List<String> args) {
  final name = args[0];
  if(name.isEmpty) {
    print('Name is empty');
    return;
  }

  String contents = '';
  contents += 'import \'package:flutter/material.dart\';\n';
  contents += 'import \'package:monitor/widgets/screen_widget.dart\';\n\n';
  contents += 'class ${name}SW implements ScreenWidget {\n\n';
  contents += '\t@override\n';
  contents += '\tget widget {\n';
  contents += '\t\treturn SizedBox();\n';
  contents += '\t}\n\n';
  contents += '\t@override\n';
  contents += '\tget editWidget {\n';
  contents += '\t\treturn Column(\n';
  contents += '\t\t\tmainAxisAlignment: MainAxisAlignment.center,\n';
  contents += '\t\t\tchildren: const [\n';
  contents += '\t\t\t\tIcon(Icons.question_mark),\n';
  contents += '\t\t\t\tText(\'$name\')\n';
  contents += '\t\t\t],\n';
  contents += '\t\t);\n';
  contents += '\t}\n';
  contents += '}\n';

  final file = File('./lib/widgets/${nameToFileName(name)}_sw.dart');
  file.writeAsStringSync(contents);

  print('File "$name" created with contents: $contents');
}

String nameToFileName(String name) {
  return name.replaceAllMapped(RegExp(r'(?<!^)[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}').toLowerCase();
}