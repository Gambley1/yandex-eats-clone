part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  populated,
  failure;

  bool get isLoading => this == loading;
  bool get isPopulated => this == populated;
  bool get isFailure => this == failure;
}

enum SearchType {
  popular,
  relevant,
}

class SearchState extends Equatable {
  const SearchState({
    required this.restaurants,
    required this.status,
    required this.searchType,
  });

  const SearchState.initial()
      : this(
          restaurants: const [],
          status: SearchStatus.initial,
          searchType: SearchType.popular,
        );

  final List<Restaurant> restaurants;

  final SearchStatus status;

  final SearchType searchType;

  @override
  List<Object?> get props => [restaurants, status, searchType];

  SearchState copyWith({
    List<Restaurant>? restaurants,
    SearchStatus? status,
    SearchType? searchType,
  }) =>
      SearchState(
        restaurants: restaurants ?? this.restaurants,
        status: status ?? this.status,
        searchType: searchType ?? this.searchType,
      );
}
