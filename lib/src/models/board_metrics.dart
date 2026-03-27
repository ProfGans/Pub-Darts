class BoardMetrics {
  const BoardMetrics({
    required this.center,
    required this.outer,
    required this.doubleOuter,
    required this.doubleInner,
    required this.tripleOuter,
    required this.tripleInner,
    required this.outerBull,
    required this.innerBull,
  });

  factory BoardMetrics.fromSize(double size) {
    final outer = size * 0.47;
    return BoardMetrics(
      center: size / 2,
      outer: outer,
      doubleOuter: outer,
      doubleInner: outer * (162 / 170),
      tripleOuter: outer * (107 / 170),
      tripleInner: outer * (99 / 170),
      outerBull: size * 0.052,
      innerBull: size * 0.025,
    );
  }

  final double center;
  final double outer;
  final double doubleOuter;
  final double doubleInner;
  final double tripleOuter;
  final double tripleInner;
  final double outerBull;
  final double innerBull;
}
