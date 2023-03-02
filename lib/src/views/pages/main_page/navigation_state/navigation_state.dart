class NavigationState {
  NavigationState({
    this.currentIndex = 0,
  });

  final int currentIndex;

  NavigationState copyWith({
    int? currentIndex,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
