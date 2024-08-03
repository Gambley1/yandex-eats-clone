// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'selected_card_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedCardState _$SelectedCardStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SelectedCardState',
      json,
      ($checkedConvert) {
        final val = SelectedCardState(
          status: $checkedConvert(
              'status', (v) => $enumDecode(_$SelectedCardStatusEnumMap, v)),
          selectedCard: $checkedConvert(
              'selected_card',
              (v) => const CreditCardJsonConverter()
                  .fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'selectedCard': 'selected_card'},
    );

Map<String, dynamic> _$SelectedCardStateToJson(SelectedCardState instance) =>
    <String, dynamic>{
      'status': _$SelectedCardStatusEnumMap[instance.status]!,
      'selected_card':
          const CreditCardJsonConverter().toJson(instance.selectedCard),
    };

const _$SelectedCardStatusEnumMap = {
  SelectedCardStatus.initial: 'initial',
  SelectedCardStatus.loading: 'loading',
  SelectedCardStatus.populated: 'populated',
  SelectedCardStatus.failure: 'failure',
};
