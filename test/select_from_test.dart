import 'package:flutter_reactive_ble/src/select_from.dart';
import 'package:flutter_test/flutter_test.dart';

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
