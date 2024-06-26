//
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EstablishBondingInfo_BondState extends $pb.ProtobufEnum {
  static const EstablishBondingInfo_BondState NONE = EstablishBondingInfo_BondState._(0, _omitEnumNames ? '' : 'NONE');
  static const EstablishBondingInfo_BondState BONDING = EstablishBondingInfo_BondState._(1, _omitEnumNames ? '' : 'BONDING');
  static const EstablishBondingInfo_BondState BONDED = EstablishBondingInfo_BondState._(2, _omitEnumNames ? '' : 'BONDED');

  static const $core.List<EstablishBondingInfo_BondState> values = <EstablishBondingInfo_BondState> [
    NONE,
    BONDING,
    BONDED,
  ];

  static final $core.Map<$core.int, EstablishBondingInfo_BondState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EstablishBondingInfo_BondState? valueOf($core.int value) => _byValue[value];

  const EstablishBondingInfo_BondState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
