/// Banker's Rounding (round half to even) para sempre cair em número par.
/// Ex.: 1.5 -> 2, 2.5 -> 2, 3.5 -> 4, 4.49 -> 4, 4.51 -> 5 -> 6 (ajuste par)
num roundToNearestEven(num value) {
  // 1) arredonda com "round half to even"
  final double v = value.toDouble();
  final double floorVal = v.floorToDouble();
  final double frac = (v - floorVal).abs();

  num base;
  if (frac > 0.5) {
    base = v.round(); // longe do .5 normal
  } else if (frac < 0.5) {
    base = v.round(); // normal
  } else {
    // exatamente .5 -> para o par mais próximo
    final isFloorEven = floorVal % 2 == 0;
    base = isFloorEven ? floorVal : floorVal + (v.isNegative ? -1 : 1);
  }

  // 2) garante que o resultado final seja PAR (mesmo quando não veio de .5)
  if (base % 2 != 0) {
    // escolhe o par mais próximo (empate -> sobe)
    final down = base - 1;
    final up = base + 1;
    final d1 = (v - down).abs();
    final d2 = (up - v).abs();
    base = (d2 < d1) ? up : (d1 < d2) ? down : up;
  }
  return base;
}