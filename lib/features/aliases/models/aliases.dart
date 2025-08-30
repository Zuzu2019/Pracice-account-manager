// Define Aliases solo si lo necesitas, sino quita esta clase
class Aliases {
  final String local;
  final String remoto;
  final int id;
  Aliases({required this.id, required this.local, required this.remoto});

  factory Aliases.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (var entry in json.entries) entry.key.toLowerCase(): entry.value,
    };

    return Aliases(
      id: int.tryParse(normalized['id']?.toString() ?? '') ?? 0,
      local: normalized['local']?.toString() ?? '',
      remoto: normalized['remoto']?.toString() ?? '',
    );
  }
  // factory Aliases.fromJson(Map<String, dynamic> json) {
  //   return Aliases(
  //     id: json['ID'] != null ? int.parse(json['ID'].toString()) : 0,
  //     local: json['Local']?.toString() ?? '',
  //     remoto: json['Remoto']?.toString() ?? '',
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {'local': local, 'remoto': remoto, 'id': id};
  }

  Map<String, dynamic> toMap() {
    return {'local': local, 'remoto': remoto, 'id': id};
  }
}
