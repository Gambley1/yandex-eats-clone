import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'selected_card_cubit.g.dart';
part 'selected_card_state.dart';

class SelectedCardCubit extends HydratedCubit<SelectedCardState> {
  SelectedCardCubit({
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(const SelectedCardState.initial()) {
    _initPayments();
  }

  final PaymentsRepository _paymentsRepository;

  Future<void> _initPayments() async {
    final creditCards = await _paymentsRepository.getCreditCards();
    if (creditCards.isEmpty) return clearCardSelection();
    if (!state.selectedCard.isEmpty) return;
    emit(state.copyWith(selectedCard: creditCards.first));
  }

  Future<void> getSelectedCard() async {
    final creditCards = await _paymentsRepository.getCreditCards();
    if (creditCards.isEmpty) return clearCardSelection();
    emit(state.copyWith(selectedCard: creditCards.first));
  }

  void selectCard(CreditCard card) {
    emit(state.copyWith(selectedCard: card));
  }

  void clearCardSelection() {
    emit(const SelectedCardState.initial());
  }

  @override
  SelectedCardState? fromJson(Map<String, dynamic> json) =>
      SelectedCardState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SelectedCardState state) => state.toJson();
}
