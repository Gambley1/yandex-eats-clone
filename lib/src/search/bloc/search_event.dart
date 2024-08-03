part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
}

final class SearchTermChanged extends SearchEvent {
  const SearchTermChanged({this.searchTerm = ''});

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}
