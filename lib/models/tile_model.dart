class TileModel {
  final String frontText;
  final String backText;
  final num points;
  final String check;
  final num counter; // int에서 num으로 변경
  final bool isNA;

  TileModel({
    required this.frontText,
    required this.backText,
    required this.points,
    required this.check,
    this.counter = 0,
    this.isNA = false,
  });

  TileModel copyWith({
    String? frontText,
    String? backText,
    num? points,
    String? check,
    num? counter, // int에서 num으로 변경
    bool? isNA,
  }) {
    return TileModel(
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      points: points ?? this.points,
      check: check ?? this.check,
      counter: counter ?? this.counter,
      isNA: isNA ?? this.isNA,
    );
  }
}
