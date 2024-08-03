import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_api/client.dart';

part 'payments_event.dart';
part 'payments_mixin.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(const PaymentsState.initial()) {
    on<PaymentsUpdateRequested>(_onUpdateRequested);
    on<PaymentsFetchCardsRequested>(_onFetchCardsRequested);
    on<PaymentsCreateCardRequested>(_onCreateCardRequested);
    on<PaymentsDeleteCardRequested>(
      _onDeleteCardRequested,
      transformer: droppable(),
    );
  }

  final PaymentsRepository _paymentsRepository;

  Future<void> _onFetchCardsRequested(
    PaymentsFetchCardsRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PaymentsStatus.loading));
      final creditCards = await _paymentsRepository.getCreditCards();
      emit(
        state.copyWith(
          status: PaymentsStatus.populated,
          creditCards: creditCards,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onCreateCardRequested(
    PaymentsCreateCardRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PaymentsStatus.processingCard));
      final creditCard = await _paymentsRepository.addCreditCard(event.card);
      event.onSuccess?.call(creditCard);
      emit(state.copyWith(status: PaymentsStatus.processingCardSuccess));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.processingCardFailure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onDeleteCardRequested(
    PaymentsDeleteCardRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      await _paymentsRepository
          .deleteCreditCard(event.number)
          .whenComplete(() => event.onComplete?.call());
      emit(state.copyWith(status: PaymentsStatus.populated));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateRequested(
    PaymentsUpdateRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    final update = event.update;
    final previousState = state;

    try {
      final newCreditCards = state.creditCards.updatePayments(
        newCard: update.newCreditCard,
        isDelete: update.type.isDelete,
      );
      emit(
        state.copyWith(
          creditCards: newCreditCards,
          status: PaymentsStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(previousState.copyWith(status: PaymentsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
