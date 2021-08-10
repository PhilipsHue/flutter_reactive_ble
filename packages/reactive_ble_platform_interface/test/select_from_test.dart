import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_ble_platform_interface/src/select_from.dart';

void main() {
  group("selectFrom", () {
    _Enum sut(int? raw) =>
        selectFrom(_Enum.values, index: raw, fallback: (raw) => _Enum.unknown);

    test("selects a value by index", () {
      expect(sut(1), _Enum.a);
    });

    test("uses the fallback given a negative index", () {
      expect(sut(-1), _Enum.unknown);
    });

    test("uses the fallback given an out of range index", () {
      expect(sut(3), _Enum.unknown);
    });

    test("uses the fallback given a null index", () {
      expect(sut(null), _Enum.unknown);
    });
  });
}

enum _Enum { unknown, a }
