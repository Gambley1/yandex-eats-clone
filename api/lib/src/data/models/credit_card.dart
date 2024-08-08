import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'credit_card.g.dart';

@JsonSerializable()

/// User credit card model
class CreditCard extends Equatable {
  /// {@macro credit_card}
  const CreditCard({
    required this.number,
    required this.expiryDate,
    required this.cvv,
  });

  const CreditCard.empty()
      : number = '',
        expiryDate = '',
        cvv = '';

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);

  factory CreditCard.fromView(DbcreditCardView creditCard) => CreditCard(
        number: creditCard.number,
        expiryDate: creditCard.expiryDate,
        cvv: creditCard.cvv,
      );

  /// Associated credit card number
  final String number;

  /// Associated credit card expiryDate date
  final String expiryDate;

  /// Associated credit card cvv code
  final String cvv;

  bool get isEmpty => this == const CreditCard.empty() || number.isEmpty;

  Map<String, dynamic> toJson() => _$CreditCardToJson(this);

  @override
  List<Object?> get props => [number, expiryDate, cvv];
}
