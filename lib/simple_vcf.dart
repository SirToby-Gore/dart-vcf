import 'dart:io';

class simple_vcf {
  List<Map<String, String>> contacts = [];

  void addFile(String path) {
    File file = File(path);

    if (!file.existsSync()) {
      stderr.write('No file found under path: $path\n');
      return;
    }

    Map<String, String> contact = {};

    for (String line in file.readAsLinesSync()) {
      if ((line.startsWith('BEGIN:') || line.startsWith('END:')) && contact.isNotEmpty) {
        contacts.add(contact);
        contact = {};
        continue;
      }

      if (
        line.startsWith('N:')
        || line.startsWith('FN:')
        || line.startsWith('TEL;')
        || line.startsWith('CELL:')
        || line.startsWith('EMAIL:')
        || line.startsWith('BDAY:')
        || line.startsWith('ORG:')
      ) {
        contact[line.split(':').first] = line.split(':').last;
        continue;
      }
    }
  }

  void export([String path = '']) {
    IOSink sink;

    if (path.isNotEmpty) {
      File file = File(path);

      if (file.existsSync()) {
        stderr.write('File already exists under path: $path\n');
        return;
      }

      sink = file.openWrite();
    } else {
      sink = stdout;
    }

    for (var contact in contacts) {
      sink.writeln('BEGIN:VCARD');
      sink.writeln('VERSION:2.1');
      
      for (var entry in contact.entries) {
        sink.writeln('${entry.key}:${entry.value}');
      }

      sink.writeln('END:VCARD');
    }

    sink.close();
  }

  void filterUnique(String key) {
    List<String> seen = [];

    List<Map<String, String>> newContacts = [];
  
    for (Map<String, String> contact in contacts) {
      String name = contact[key] ?? '';

      if (seen.contains(name)) {
        continue;
      }

      seen.add(name);

      newContacts.add(contact); 
    }

    contacts = newContacts;
  }

  void sort(String key) {
    contacts.sort(
      (Map<String, String> a, Map<String, String> b) =>
      (a[key] ?? '\u0000').codeUnitAt(0) - (b[key] ?? '\u0000').codeUnitAt(0)
    );
  }

  void map(Map<String, String> Function(Map<String, String>) mappingFunction) {
    contacts = contacts.map(mappingFunction).toList();
  }

  void add(Map<String, String> contact) {
    contacts.add(contact);
  }
}