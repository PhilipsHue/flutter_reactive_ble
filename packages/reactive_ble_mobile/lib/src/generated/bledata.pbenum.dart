//
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EstablishBondInfo_BondState extends $pb.ProtobufEnum {
  static const EstablishBondInfo_BondState BOND_BONDING = EstablishBondInfo_BondState._(0, _omitEnumNames ? '' : 'BOND_BONDING');
  static const EstablishBondInfo_BondState BOND_BONDED = EstablishBondInfo_BondState._(1, _omitEnumNames ? '' : 'BOND_BONDED');
  static const EstablishBondInfo_BondState BOND_NONE = EstablishBondInfo_BondState._(2, _omitEnumNames ? '' : 'BOND_NONE');

  static const $core.List<EstablishBondInfo_BondState> values = <EstablishBondInfo_BondState> [
    BOND_BONDING,
    BOND_BONDED,
    BOND_NONE,
  ];

  static final $core.Map<$core.int, EstablishBondInfo_BondState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EstablishBondInfo_BondState? valueOf($core.int value) => _byValue[value];

  const EstablishBondInfo_BondState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
