import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Uuid", () {
    group("128-bit", () {
      const sampleText = "00112233-4455-6677-8899-aabbccddeeff";
      const sampleData = [
        0x00,
        0x11,
        0x22,
        0x33,
        0x44,
        0x55,
        0x66,
        0x77,
        0x88,
        0x99,
        0xaa,
        0xbb,
        0xcc,
        0xdd,
        0xee,
        0xff
      ];

      test("parses text", () {
        final uuid = Uuid.parse(sampleText);
        expect(uuid.data, sampleData);
      });

      test("serializes to text", () {
        final uuid = Uuid(sampleData);
        expect(uuid.toString().toLowerCase(), sampleText.toLowerCase());
      });
    });
    group("32-bit", () {
      const sampleText = "00112233";
      const sampleData = [0x00, 0x11, 0x22, 0x33];

      test("parses text", () {
        final uuid = Uuid.parse(sampleText);
        expect(uuid.data, sampleData);
      });

      test("serializes to text", () {
        final uuid = Uuid(sampleData);
        expect(uuid.toString().toLowerCase(), sampleText.toLowerCase());
      });
    });
    group("16-bit", () {
      const sampleText = "0011";
      const sampleData = [0x00, 0x11];

      test("parses text", () {
        final uuid = Uuid.parse(sampleText);
        expect(uuid.data, sampleData);
      });

      test("serializes to text", () {
        final uuid = Uuid(sampleData);
        expect(uuid.toString().toLowerCase(), sampleText.toLowerCase());
      });
    });
  });
}
