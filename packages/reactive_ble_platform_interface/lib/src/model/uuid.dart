import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Representation of a 16, 32 or 128-bit number used to identify BLE services and characteristics.
class Uuid {
  final Uint8List data;

  Uuid(List<int> data) : data = Uint8List.fromList(data);

  factory Uuid.parse(String string) {
    final data = Uint8List(16);

    var byteOffset = 0;
    for (var substringStart = 0; substringStart < string.length;) {
      if (string[substringStart] == "-") {
        substringStart += 1;
        continue;
      }

      if (byteOffset >= 16 || substringStart + 2 > string.length) {
        throw _UuidParseFailure(string);
      }

      final byte = int.tryParse(
        string.substring(substringStart, substringStart + 2),
        radix: 16,
      );
      if (byte == null) throw _UuidParseFailure(string);

      data[byteOffset] = byte;

      byteOffset += 1;
      substringStart += 2;
    }
    if (byteOffset == 2 || byteOffset == 4 || byteOffset == 16) {
      return Uuid(data.buffer.asUint8List(0, byteOffset));
    } else {
      throw _UuidParseFailure(string);
    }
  }

  @override
  String toString() {
    String paddedHex(int num) {
      final text = num.toRadixString(16);
      return text.length < 2 ? "0$text" : text;
    }

    final buffer = StringBuffer();
    final groupLength = [4, 2, 2, 2, 6];
    var group = 0, inGroupOffset = 0;
    for (final octet in data) {
      if (group < groupLength.length && inGroupOffset >= groupLength[group]) {
        buffer.write("-");
        group += 1;
        inGroupOffset = 0;
      }
      buffer.write(paddedHex(octet));
      inGroupOffset += 1;
    }
    return buffer.toString();
  }

  @override
  int get hashCode =>
      data.fold(17, (hash, octet) => 37 * hash + octet.hashCode);

  @override
  bool operator ==(Object other) =>
      other is Uuid &&
      other.runtimeType == runtimeType &&
      const DeepCollectionEquality().equals(other.data, data);
}

@immutable
class _UuidParseFailure implements Exception {
  final String string;

  const _UuidParseFailure(this.string);

  @override
  String toString() => "$runtimeType(\"$string\")";
}
