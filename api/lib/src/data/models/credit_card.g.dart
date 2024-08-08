// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CreditCard',
      json,
      ($checkedConvert) {
        final val = CreditCard(
          number: $checkedConvert('number', (v) => v as String),
          expiryDate: $checkedConvert('expiry_date', (v) => v as String),
          cvv: $checkedConvert('cvv', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'expiryDate': 'expiry_date'},
    );

Map<String, dynamic> _$CreditCardToJson(CreditCard instance) =>
    <String, dynamic>{
      'number': instance.number,
      'expiry_date': instance.expiryDate,
      'cvv': instance.cvv,
    };
