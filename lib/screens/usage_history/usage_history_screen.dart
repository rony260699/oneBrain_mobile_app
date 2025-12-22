import 'package:OneBrain/common_widgets/common_appbar.dart';
import 'package:OneBrain/common_widgets/hexcolor.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:OneBrain/models/usage_history_model.dart';
import 'package:OneBrain/resources/color.dart';
import 'package:OneBrain/screens/usage_history/cubit/usage_history_cubit.dart';
import 'package:OneBrain/screens/usage_history/cubit/usage_history_state.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UsageHistoryScreen extends StatelessWidget {
  const UsageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UsageHistoryCubit()..fetchUsageHistory(timeFilter: 0),
      child: const UsageHistoryView(),
    );
  }
}

class UsageHistoryView extends StatelessWidget {
  const UsageHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shouldShowBackButton: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios, color: colorWhite, size: 25.sp),
        ),

        titleWidget: TextWidget(
          text: 'Usage History',
          fontSize: 28.sp,
          color: appBarTitleColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),

        titleFontSize: 18,
        titleFontWeight: FontWeight.w500,
        textColor: Colors.white,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.6, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xff0E0E1A)],
          ),
        ),
        child: BlocBuilder<UsageHistoryCubit, UsageHistoryState>(
          builder: (context, state) {
            final cubit = UsageHistoryCubit.get(context);

            if (state is UsageHistoryLoadingState &&
                cubit.usageHistoryList.isEmpty) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 12,
                ),
              );
            }

            if (state is UsageHistoryErrorState &&
                cubit.usageHistoryList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(
                      state.errorMessage,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => cubit.fetchUsageHistory(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Time filter buttons
                _buildTimeFilterButtons(cubit),

                // Usage history list
                Expanded(
                  child: Stack(
                    children: [
                      cubit.usageHistoryList.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  color: HexColor('#9CA3AF'),
                                  size: 48.sp,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No usage history found',
                                  style: TextStyle(
                                    color: HexColor('#9CA3AF'),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            itemCount: cubit.usageHistoryList.length,
                            itemBuilder: (context, index) {
                              final item = cubit.usageHistoryList[index];
                              return _buildUsageHistoryItem(item);
                            },
                          ),
                      // Center loader during page navigation
                      if (state is UsageHistoryLoadingState &&
                          cubit.usageHistoryList.isNotEmpty)
                        Container(
                          color: Colors.black.withValues(alpha: 0.3),
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 15,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Builder(
                  builder: (context) {
                    final cubit = UsageHistoryCubit.get(context);

                    if (state is UsageHistoryLoadingState &&
                        cubit.usageHistoryList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    if (cubit.usageHistoryList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 16.w,
                        ),
                        margin: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 8.h,
                          top: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(color: Colors.grey.shade800),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // decoration: BoxDecoration(
                        //   color: HexColor('#0F172A'),
                        //   borderRadius: BorderRadius.circular(12.r),
                        //   border: Border.all(color: HexColor('#1E293B')),
                        // ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Range text (e.g., "1-100 of 118") or loader
                            SizedBox(
                              height: 15.h,
                              child: Center(
                                child:
                                    state is UsageHistoryLoadingState
                                        ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 10,
                                        )
                                        : Text(
                                          cubit.paginationRangeText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: HexColor('#9CA3AF'),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                              ),
                            ),
                            if (cubit.currentPageText == '1/1`') ...[
                              SizedBox(height: 8.h),
                              // Navigation row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Previous button
                                  GestureDetector(
                                    onTap:
                                        (state is UsageHistoryLoadingState ||
                                                !cubit.hasPreviousPage)
                                            ? null
                                            : () => cubit.previousPage(),
                                    child: Icon(
                                      Icons.chevron_left,
                                      color:
                                          (state is UsageHistoryLoadingState ||
                                                  !cubit.hasPreviousPage)
                                              ? HexColor('#374151')
                                              : Colors.white,
                                      size: 22.sp,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  // Current page text (e.g., "1/2")
                                  Text(
                                    cubit.currentPageText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  // Next button
                                  GestureDetector(
                                    onTap:
                                        (state is UsageHistoryLoadingState ||
                                                !cubit.hasNextPage)
                                            ? null
                                            : () => cubit.nextPage(),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color:
                                          (state is UsageHistoryLoadingState ||
                                                  !cubit.hasNextPage)
                                              ? HexColor('#374151')
                                              : Colors.white,
                                      size: 22.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      // bottomNavigationBar: BlocBuilder<UsageHistoryCubit, UsageHistoryState>(
      //   builder: (context, state) {

      // ),
    );
  }

  Widget _buildTimeFilterButtons(UsageHistoryCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Text(
            'Time:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 16.w),
          _buildFilterButton(
            label: '1d',
            isSelected: cubit.selectedTimeFilter == 0,
            onTap: () => cubit.changeTimeFilter(0),
          ),
          SizedBox(width: 8.w),
          _buildFilterButton(
            label: '7d',
            isSelected: cubit.selectedTimeFilter == 1,
            onTap: () => cubit.changeTimeFilter(1),
          ),
          SizedBox(width: 8.w),
          _buildFilterButton(
            label: '30d',
            isSelected: cubit.selectedTimeFilter == 2,
            onTap: () => cubit.changeTimeFilter(2),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? HexColor('#1F2937') : null,
          borderRadius: BorderRadius.circular(12.r),
          // border: Border.all(
          //   color: isSelected ? HexColor('#3B82F6') : HexColor('#374151'),
          // ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildUsageHistoryItem(UsageHistoryItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // bg-black/30
        borderRadius: BorderRadius.circular(12), // rounded-lg
        border: Border.all(color: Colors.grey.shade800), // border-gray-800
        // backdrop-blur-sm
        // Use BackdropFilter for blur effect (below)
      ),
      // decoration: BoxDecoration(
      //   color: HexColor('#0F172A'),
      //   borderRadius: BorderRadius.circular(12.r),
      //   border: Border.all(color: HexColor('#1E293B')),
      // ),
      child: Row(
        children: [
          // Model icon
          Center(
            child: SvgPicture.asset(
              AIModelService.getIcon(
                item.metadata?.originalProvider ?? '',
                true,
              ),
              height: 24,
              width: 24,
            ),
          ),
          SizedBox(width: 12.w),

          // Model name and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.model ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      item.formattedDateTime,
                      style: TextStyle(
                        color: HexColor('#9CA3AF'),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('#60A5FA').withValues(alpha: 0.15),
                        border: Border.all(
                          color: HexColor('#60A5FA'),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.service ?? '',
                        style: TextStyle(
                          color: HexColor('#60A5FA'),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Token count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.formattedTokens,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'tokens',
                style: TextStyle(color: HexColor('#9CA3AF'), fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
