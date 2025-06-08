# Example
```dart
simple_vcf()
..addFile('contacts.simple_vcf') // reads the file at `contacts.simple_vcf`
..filterUnique('FN') // drops any duplicates with the same value on key for `FN`
..sort('FN') // sorts the contacts by their value at `FN`
..map((Map<String, String> contact) {
    List<String> contactName = (contact['FN'] ?? '').split(' ').reversed.toList();

    while (contactName.length < 5) {
        contactName.add('');
    }

    contact['N'] = contactName.join(';');

    return contact;
})
..export() // prints to stdout
..export('contacts_2.simple_vcf'); // exports to the file at `contacts_2.simple_vcf`
```