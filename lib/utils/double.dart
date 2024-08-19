import 'dart:math';

extension Precision on double {
  double toPrecision(int n) =>
      (this * pow(10, n)).truncateToDouble() / pow(10, n);
}
