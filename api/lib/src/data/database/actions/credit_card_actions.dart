import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

class UpdateCreditCardAction extends Action<DbcreditCardView> {
  UpdateCreditCardAction({
    required this.expiryDate,
    required this.number,
    required this.cvv,
  });

  final String? number;
  final String? expiryDate;
  final String? cvv;

  @override
  Future<void> apply(Session db, DbcreditCardView request) async {
    final queryable = DbcreditCardViewQueryable();
    final tableName = queryable.tableAlias;
    await db.execute(
      '''
      UPDATE $tableName
      SET number = coalesce(@number, number),
          cvv = coalesce(@cvv, cvv),
          expiry_date = coalesce(@expiry_date, expiry_date)
      WHERE number = @number
    ''',
      parameters: {
        'number': request.number,
        'new_number': number,
        'expiry_date': expiryDate,
        'cvv': cvv,
      },
    );
  }
}

extension CreditCardActionsX on DBCreditCardRepository {
  Future<void> updateCreditCard({
    required String? number,
    required String? cvv,
    required String? expiryDate,
    required DbcreditCardView card,
  }) =>
      run(
        UpdateCreditCardAction(
          expiryDate: expiryDate,
          number: number,
          cvv: cvv,
        ),
        card,
      );
}
