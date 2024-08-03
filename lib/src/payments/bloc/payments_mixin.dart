part of 'payments_bloc.dart';

/// Represents the different types of data updates.
///
/// This enum defines three types of data updates: create, delete, and update.
/// It also provides convenient boolean getters to check the type of the update.
/// - `isCreate` returns true if the update is of type create.
/// - `isDelete` returns true if the update is of type delete.
enum DataUpdateType {
  create,
  delete;

  bool get isCreate => this == DataUpdateType.create;
  bool get isDelete => this == DataUpdateType.delete;
}

/// {@template data_update}
/// Represents a data update.
///
/// This class encapsulates information about a data update, including the new
/// credit card and the type of update.
/// The boolean getters `isCreate` and `isDelete` can be used to
/// check the type of the update.
///
/// Example usage:
/// ```dart
/// final update = DataUpdate(newCreditCard: card, type: DataUpdateType.update);
/// final isCreate = update.isCreate;
/// final isDelete = update.isDelete;
/// ```
///
/// See also:
/// - `CreditCard` class for representing a credit card
/// - `DataUpdateType` enum for representing the type of a data update
/// {@endtemplate}
sealed class DataUpdate {
  const DataUpdate({
    required this.newCreditCard,
    required this.type,
  });

  final CreditCard newCreditCard;
  final DataUpdateType type;

  bool get isCreate => type.isCreate;
  bool get isDelete => type.isDelete;
}

/// {@template feed_data_update}
/// Represents a data update for the payments.
///
/// This class extends the [DataUpdate] class .It is specifically used for
/// updating the payments sheet.
/// data.
/// {@endtemplate}
final class PaymentsDataUpdate extends DataUpdate {
  const PaymentsDataUpdate({required super.newCreditCard, required super.type});
}

mixin PaymentsMixin {}

extension on List<CreditCard> {
  List<CreditCard> updatePayments({
    required CreditCard? newCard,
    bool isDelete = false,
  }) {
    if (newCard == null) {
      logD('No `newCard` was provided. '
          'Return the original list without any modifications');
      return this;
    }
    if (isDelete) {
      final index = indexWhere((item) => item.number == newCard.number);
      return this..removeAt(index);
    }

    return this..insert(0, newCard);
  }
}
