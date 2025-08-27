import 'package:practice_acount_manager/features/aliases/models/aliases.dart';

class AliasResponse {
  final int totalCount;
  final int totalPages;
  final List<Aliases> alias;

  AliasResponse({
    required this.totalCount,
    required this.totalPages,
    required this.alias,
  });

  factory AliasResponse.fromJson(Map<String, dynamic> json) {
    final alias =
        (json['Alias'] as List<dynamic>?)
            ?.map((e) => Aliases.fromJson(e))
            .toList() ??
        (json['Items'] as List<dynamic>?)
            ?.map((e) => Aliases.fromJson(e))
            .toList() ??
        [];
    return AliasResponse(
      totalCount: json['TotalCount'] ?? 0,
      totalPages: json['TotalPages'] ?? 1,
      alias: alias, // si es null, lista vacía
    );
  }
}
