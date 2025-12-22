abstract class UsageHistoryState {}

class UsageHistoryInitialState extends UsageHistoryState {}

class UsageHistoryLoadingState extends UsageHistoryState {}

class UsageHistorySuccessState extends UsageHistoryState {}

class UsageHistoryErrorState extends UsageHistoryState {
  final String errorMessage;

  UsageHistoryErrorState(this.errorMessage);
}

class UsageHistoryLoadMoreState extends UsageHistoryState {}
