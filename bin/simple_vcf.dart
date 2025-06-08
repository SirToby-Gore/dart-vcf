import 'dart:io';

import 'package:simple_vcf/simple_vcf.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.write('only 1 arg required for path to simple_vcf file\n');
    exit(1);
  }

  simple_vcf()
    ..addFile(arguments[0])
    ..filterUnique('FN')
    ..sort('FN')
    ..map((Map<String, String> contact) {
      List<String> contactName = (contact['FN'] ?? '').split(' ').reversed.toList();

      while (contactName.length < 5) {
        contactName.add('');
      }

      contact['N'] = contactName.join(';');

      return contact;
    })
    ..export()
    ..export('simple_vcf.simple_vcf');
}