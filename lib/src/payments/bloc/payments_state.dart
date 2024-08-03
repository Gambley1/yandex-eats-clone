// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'payments_bloc.dart';

enum PaymentsStatus {
  initial,
  loading,
  populated,
  failure,
  processingCard,
  processingCardSuccess,
  processingCardFailure;

  bool get isLoading => this == PaymentsStatus.loading;
  bool get isProcessingCard => this == PaymentsStatus.processingCard;
  bool get isProcessingCardSuccess =>
      this == PaymentsStatus.processingCardSuccess;
  bool get isProcessingCardFailure =>
      this == PaymentsStatus.processingCardFailure;
  bool get isPopulated => this == PaymentsStatus.populated;
  bool get isFailure => this == PaymentsStatus.failure;
}

class PaymentsState extends Equatable {
  const PaymentsState._({required this.status, required this.creditCards});

  const PaymentsState.initial()
      : this._(status: PaymentsStatus.initial, creditCards: const []);

  final PaymentsStatus status;
  final List<CreditCard> creditCards;

  @override
  List<Object?> get props => [status, creditCards];

  PaymentsState copyWith({
    PaymentsStatus? status,
    List<CreditCard>? creditCards,
  }) {
    return PaymentsState._(
      status: status ?? this.status,
      creditCards: creditCards ?? this.creditCards,
    );
  }
}
