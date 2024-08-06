class TileModel {
  final String frontText;
  final String backText;
  final String system;
  final num counter; // int에서 num으로 변경
  final bool isNA;

  TileModel({
    required this.frontText,
    required this.backText,
    required this.system,
    this.counter = 0,
    this.isNA = false,
  });

  TileModel copyWith({
    String? frontText,
    String? backText,
    String? system,
    num? counter, // int에서 num으로 변경
    bool? isNA,
  }) {
    return TileModel(
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      system: system ?? this.system,
      counter: counter ?? this.counter,
      isNA: isNA ?? this.isNA,
    );
  }
}
