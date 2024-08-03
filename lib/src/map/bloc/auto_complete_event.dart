part of 'auto_complete_bloc.dart';

sealed class AutoCompleteEvent extends Equatable {
  const AutoCompleteEvent();

  @override
  List<Object> get props => [];
}

final class AutoCompleteFetchRequested extends AutoCompleteEvent {
  const AutoCompleteFetchRequested({this.searchTerm = ''});

  final String searchTerm;
}
