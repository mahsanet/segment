class ConnectionMetaModel {
  final String ip;
  final String location;

  ConnectionMetaModel({required this.ip, required this.location});

  factory ConnectionMetaModel.fromRawText(String rawText) {
    final Map<String, String> data = {};

    // Parse the raw text response from Cloudflare
    final lines = rawText.split('\n');
    for (final line in lines) {
      if (line.isEmpty) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        data[parts[0]] = parts[1];
      }
    }

    return ConnectionMetaModel(
      ip: data['ip'] ?? 'Unknown',
      location: data['loc'] ?? 'Unknown',
    );
  }

  String get flagEmoji {
    // Convert country code to emoji flag
    // Each country code is 2 letters, and each letter's unicode
    // regional indicator symbol is 127462 (🇦) plus the letter's position in the alphabet
    if (location.length != 2) return '🌐';

    final firstLetter = location.codeUnitAt(0) - 65 + 127462;
    final secondLetter = location.codeUnitAt(1) - 65 + 127462;

    return String.fromCharCodes([firstLetter, secondLetter]);
  }
}
