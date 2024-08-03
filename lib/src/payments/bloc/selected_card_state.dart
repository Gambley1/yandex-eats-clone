// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'selected_card_cubit.dart';

class CreditCardJsonConverter
    extends JsonConverter<CreditCard, Map<String, dynamic>> {
  const CreditCardJsonConverter();

  @override
  CreditCard fromJson(Map<String, dynamic> json) => CreditCard.fromJson(json);

  @override
  Map<String, dynamic> toJson(CreditCard object) => object.toJson();
}

enum SelectedCardStatus {
  initial,
  loading,
  populated,
  failure;

  bool get isLoading => this == SelectedCardStatus.loading;
  bool get isPopulated => this == SelectedCardStatus.populated;
  bool get isFailure => this == SelectedCardStatus.failure;
}

@JsonSerializable()
class SelectedCardState extends Equatable {
  const SelectedCardState({required this.status, required this.selectedCard});

  const SelectedCardState.initial()
      : this(
          status: SelectedCardStatus.initial,
          selectedCard: const CreditCard.empty(),
        );

  factory SelectedCardState.fromJson(Map<String, dynamic> json) =>
      _$SelectedCardStateFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedCardStateToJson(this);

  final SelectedCardStatus status;
  
  @CreditCardJsonConverter()
  final CreditCard selectedCard;

  @override
  List<Object?> get props => [status, selectedCard];

  SelectedCardState copyWith({
    SelectedCardStatus? status,
    CreditCard? selectedCard,
  }) {
    return SelectedCardState(
      status: status ?? this.status,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}
