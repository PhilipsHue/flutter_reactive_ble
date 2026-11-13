// This is a generated file - do not edit.
//
// Generated from bledata.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EstablishBondingInfo_BondState extends $pb.ProtobufEnum {
  static const EstablishBondingInfo_BondState NONE =
      EstablishBondingInfo_BondState._(0, _omitEnumNames ? '' : 'NONE');
  static const EstablishBondingInfo_BondState BONDING =
      EstablishBondingInfo_BondState._(1, _omitEnumNames ? '' : 'BONDING');
  static const EstablishBondingInfo_BondState BONDED =
      EstablishBondingInfo_BondState._(2, _omitEnumNames ? '' : 'BONDED');

  static const $core.List<EstablishBondingInfo_BondState> values =
      <EstablishBondingInfo_BondState>[
    NONE,
    BONDING,
    BONDED,
  ];

  static final $core.List<EstablishBondingInfo_BondState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static EstablishBondingInfo_BondState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EstablishBondingInfo_BondState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
