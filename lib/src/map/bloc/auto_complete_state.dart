// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'auto_complete_bloc.dart';

enum AutoCompleteStatus {
  initial,
  loading,
  populated,
  failure;

  bool get isLoading => this == AutoCompleteStatus.loading;
  bool get isPopulated => this == AutoCompleteStatus.populated;
}

class AutoCompleteState extends Equatable {
  const AutoCompleteState._({
    required this.status,
    required this.autoCompletes,
  });

  const AutoCompleteState.initial()
      : this._(status: AutoCompleteStatus.initial, autoCompletes: const []);

  final AutoCompleteStatus status;
  final List<AutoComplete> autoCompletes;

  @override
  List<Object?> get props => [status, autoCompletes];

  AutoCompleteState copyWith({
    AutoCompleteStatus? status,
    List<AutoComplete>? autoCompletes,
  }) {
    return AutoCompleteState._(
      status: status ?? this.status,
      autoCompletes: autoCompletes ?? this.autoCompletes,
    );
  }
}
