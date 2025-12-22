import 'package:OneBrain/models/usage_history_model.dart';
import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:OneBrain/screens/usage_history/cubit/usage_history_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsageHistoryCubit extends Cubit<UsageHistoryState> {
  UsageHistoryCubit() : super(UsageHistoryInitialState());

  static UsageHistoryCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<UsageHistoryItem> usageHistoryList = [];
  Pagination? pagination;

  int currentPage = 1;
  int limit = 100;
  int selectedTimeFilter = 1; // 0 = 1d, 1 = 7d, 2 = 30d
  bool isLoadingMore = false;

  Future<void> fetchUsageHistory({
    bool isLoadMore = false,
    bool isPageNavigation = false,
    int? timeFilter,
  }) async {
    if (timeFilter != null) {
      selectedTimeFilter = timeFilter;
    }
    if (!isLoadMore && !isPageNavigation) {
      emit(UsageHistoryLoadingState());
      currentPage = 1;
      usageHistoryList.clear();
    } else if (isLoadMore) {
      if (isLoadingMore) return;
      isLoadingMore = true;
      emit(UsageHistoryLoadMoreState());
    } else if (isPageNavigation) {
      emit(UsageHistoryLoadingState());
    }

    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Calculate start date based on selected filter
      switch (selectedTimeFilter) {
        case 0: // 1 day
          startDate = endDate.subtract(const Duration(days: 1));
          break;
        case 1: // 7 days
          startDate = endDate.subtract(const Duration(days: 7));
          break;
        case 2: // 30 days
          startDate = endDate.subtract(const Duration(days: 30));
          break;
        default:
          startDate = endDate.subtract(const Duration(days: 7));
      }

      final String startDateStr = startDate.toUtc().toIso8601String();
      final String endDateStr = endDate.toUtc().toIso8601String();

      final url =
          '${RestConstants.usageHistory}?page=$currentPage&limit=$limit&startDate=$startDateStr&endDate=$endDateStr';

      final value = await DioHelper.getData(url: url, isHeader: true);

      if ((value.statusCode ?? 0) == 200 || (value.statusCode ?? 0) == 201) {
        if (value.data != null) {
          final response = UsageHistoryResponse.fromJson(value.data);

          if (response.data != null) {
            if (isLoadMore) {
              usageHistoryList.addAll(response.data!);
            } else {
              usageHistoryList = response.data!;
            }
          }

          pagination = response.pagination;

          emit(UsageHistorySuccessState());
        }
      } else {
        emit(
          UsageHistoryErrorState(
            value.data?["message"] ?? "Failed to load usage history",
          ),
        );
      }
    } catch (error) {
      String errorMessage;
      if (error is DioException) {
        errorMessage =
            error.response?.data?["message"] ?? "Failed to load usage history";
      } else {
        errorMessage = error.toString();
      }
      emit(UsageHistoryErrorState(errorMessage));
    } finally {
      isLoadingMore = false;
    }
  }

  void changeTimeFilter(int index) {
    selectedTimeFilter = index;
    currentPage = 1; // Reset to first page when changing filter
    fetchUsageHistory();
  }

  void loadMoreData() {
    if (pagination != null &&
        currentPage < (pagination?.totalPages ?? 0) &&
        !isLoadingMore) {
      currentPage++;
      fetchUsageHistory(isLoadMore: true);
    }
  }

  void nextPage() {
    if (hasNextPage) {
      currentPage++;
      fetchUsageHistory(isPageNavigation: true);
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      currentPage--;
      fetchUsageHistory(isPageNavigation: true);
    }
  }

  bool get hasNextPage {
    return pagination != null && currentPage < (pagination?.totalPages ?? 0);
  }

  bool get hasPreviousPage {
    return currentPage > 1;
  }

  bool get hasMoreData {
    return pagination != null && currentPage < (pagination?.totalPages ?? 0);
  }

  String get paginationRangeText {
    if (pagination == null || usageHistoryList.isEmpty) return '';

    final int startItem = ((currentPage - 1) * limit) + 1;
    final int endItem = startItem + usageHistoryList.length - 1;
    final int total = pagination?.total ?? 0;

    return '$startItem-$endItem of $total';
  }

  String get currentPageText {
    if (pagination == null) return '1/1';
    return '$currentPage/${pagination?.totalPages ?? 1}';
  }
}
