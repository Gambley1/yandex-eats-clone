// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/api.dart';

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

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      number: json['number'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
    );
  }

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

  Map<String, dynamic> toJson() => {
        'number': number,
        'expiry_date': expiryDate,
        'cvv': cvv,
      };

  @override
  List<Object?> get props => [number, expiryDate, cvv];
}
