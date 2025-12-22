import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/common_widgets/common_appbar.dart';
import 'package:OneBrain/common_widgets/gradient_progress_indicator.dart';
import 'package:OneBrain/resources/image.dart';
import 'package:OneBrain/models/plan_model.dart';
import 'package:OneBrain/screens/payment_billing/payment_api.dart';
import 'package:OneBrain/screens/payment_billing/payment_history_screen.dart';
import 'package:OneBrain/screens/payment_billing/payment_status.dart';
import 'package:OneBrain/screens/payment_billing/payment_web_view.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../resources/color.dart';
import '../../common_widgets/common_widgets.dart';
import '../../common_widgets/text_widget.dart';
import '../../base/base_stateful_state.dart';
import 'cubit/payment_cubit.dart';
import 'cubit/payment_state.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends BaseStatefulWidgetState<PaymentPage> {
  late PaymentCubit paymentCubit;

  @override
  void initState() {
    paymentCubit = PaymentCubit.get(context);
    paymentCubit.selectedTab = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await paymentCubit.getAllPlans();
    });
    super.initState();
  }

  bool _isVideoSectionExpanded = false;

  final List<Color> planColors = [
    Color(0xFF4F46E5),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
  ];

  final Map<int, String> tabList = {0: 'Package', 1: 'Token Cost', 2: 'Top-UP'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shouldShowBackButton: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios, color: colorWhite, size: 25.sp),
        ),
        prefixWidget: Padding(
          padding: EdgeInsets.only(right: 20.sp),
          child: GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryScreen(),
                  ),
                ),
            child: Icon(Icons.history_outlined, color: colorWhite, size: 25.sp),
          ),
        ),
        titleWidget: TextWidget(
          text: 'Billing & Plans',
          fontSize: 28.sp,
          color: appBarTitleColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),

        titleFontSize: 18,
        titleFontWeight: FontWeight.w500,
        textColor: Colors.white,
      ),
      backgroundColor: colorAppBg,
      body: BlocConsumer<PaymentCubit, PaymentStates>(
        listener: (context, state) {
          if (state is PaymentErrorState) {
            showError(message: state.errorMessage);
          }
        },
        builder: (context, state) {
          final user = ProfileService.user;
          final chatStatistics = ProfileService.chatStatistics;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0xFF0A0E24),
                  Color(0xFF0C1028),
                ],
                stops: [0.0, 0.7, 0.85, 1.0],
              ),
            ),
            child:
                state is PaymentSuccessState
                    ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp),
                              child: Row(
                                spacing: 16.sp,
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    tabList.entries
                                        .map(
                                          (entry) => GestureDetector(
                                            onTap:
                                                () => paymentCubit.changeTab(
                                                  entry.key,
                                                ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xff10151C),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color:
                                                      paymentCubit.selectedTab ==
                                                              entry.key
                                                          ? colorWhite
                                                          : Colors.transparent,
                                                  width: 1.sp,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.sp,
                                                vertical: 8.sp,
                                              ),
                                              child: TextWidget(
                                                text: entry.value,
                                                fontSize: 14.sp,
                                                color:
                                                    paymentCubit.selectedTab ==
                                                            entry.key
                                                        ? colorWhite
                                                        : appBarTitleColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ),

                        if (paymentCubit.selectedTab == 0)
                          // Content
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.sp,
                                vertical: 10.sp,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20.sp),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      // color: Color(0xff10151C),
                                      borderRadius: BorderRadius.circular(
                                        20.sp,
                                      ),
                                      border: Border.all(
                                        color: Color(0xff52525B),
                                        width: 1.sp,
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff000000),
                                          Color(0xff1C1D34).withOpacity(0.63),
                                        ],
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10.sp),
                                        TextWidget(
                                          text: 'Current Subscription',
                                          fontSize: 24.sp,
                                          color: colorWhite,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto',
                                        ),

                                        heightBox(10),
                                        TextWidget(
                                          text:
                                              'Manage your active plan and monitor usage',
                                          fontSize: 14.sp,
                                          color: Color(0xff9CA3AF),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                        ),

                                        heightBox(20),
                                        Row(
                                          children: [
                                            TextWidget(
                                              text:
                                                  user
                                                      ?.package
                                                      ?.currentPlan
                                                      ?.name ??
                                                  'Free',
                                              fontSize: 20.sp,
                                              color: colorWhite,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.sp,
                                                vertical: 4.sp,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xff111827),
                                                borderRadius:
                                                    BorderRadius.circular(4.sp),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextWidget(
                                                    text: '☑',
                                                    fontSize: 12.sp,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  TextWidget(
                                                    text: ' ACTIVE',
                                                    fontSize: 12.sp,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        heightBox(20),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextWidget(
                                            text: 'CHAT DAILY USAGE',
                                            fontSize: 14.sp,
                                            color: colorWhite,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),

                                        heightBox(8),

                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(13.sp),
                                          decoration: BoxDecoration(
                                            color: Color(0xff111827),
                                            border: Border.all(
                                              color: Color(0xff52525B),
                                              width: 1.sp,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.sp,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          '${chatStatistics?.valideDailySpentTokens.toString().toINFormat()}/${chatStatistics?.dailyCap.toString().toINFormat()}',
                                                      fontSize: 20.sp,
                                                      color: colorWhite,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    TextWidget(
                                                      text: ' tokens',
                                                      fontSize: 12.sp,
                                                      color: Color(0xff9CA3AF),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              heightBox(14),

                                              // Usage Progress
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                    text: 'Usage',
                                                    fontSize: 12.sp,
                                                    color: Color(0xff9CA3AF),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  TextWidget(
                                                    text:
                                                        '${getUsage(chatStatistics?.dailyCap ?? 0, (chatStatistics?.remainingDailyCapTokens ?? 0))}% left',
                                                    fontSize: 12.sp,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ],
                                              ),
                                              heightBox(8),
                                              GradientProgressBar(
                                                colors: [
                                                  Color(0xff94C5FD),
                                                  Color(0xff122149),
                                                ],
                                                value:
                                                    double.parse(
                                                      "${getUsage(chatStatistics?.dailyCap ?? 0, chatStatistics?.remainingDailyCapTokens ?? 0)}",
                                                    ) /
                                                    100,
                                              ),
                                              if (chatStatistics?.dailyCapHit ??
                                                  false) ...[
                                                heightBox(4),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextWidget(
                                                    text:
                                                        'Available at ${chatStatistics?.resetAtFormatted}',
                                                    fontSize: 9.sp,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        heightBox(28),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextWidget(
                                            text: 'TOKEN BALANCE',
                                            fontSize: 14.sp,
                                            color: Color(0xffD1D5DB),
                                            fontWeight: FontWeight.w700,

                                            fontFamily: 'Roboto',
                                          ),
                                        ),

                                        heightBox(5),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextWidget(
                                            text:
                                                'Your available tokens for premium AI features',
                                            fontSize: 14.sp,
                                            color: Color(0xff9CA3AF),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),

                                        heightBox(20),

                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(13.sp),
                                          decoration: BoxDecoration(
                                            color: Color(0xff111827),
                                            border: Border.all(
                                              color: Color(0xff52525B),
                                              width: 1.sp,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.sp,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          '${user?.tokenCounter?.availableTokens.toString().toINFormat()}',
                                                      fontSize: 20.sp,
                                                      color: colorWhite,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    TextWidget(
                                                      text: ' tokens',
                                                      fontSize: 12.sp,
                                                      color: Color(0xff9CA3AF),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              heightBox(14),

                                              // Usage Progress
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                    text: 'Usage',
                                                    fontSize: 12.sp,
                                                    color: Color(0xff9CA3AF),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  TextWidget(
                                                    text:
                                                        '${getUsage((user?.package?.currentPlan?.tokens ?? chatStatistics?.dailyCap ?? 0), (user?.tokenCounter?.availableTokens ?? 0))}% left',
                                                    fontSize: 12.sp,
                                                    color: colorWhite,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ],
                                              ),
                                              heightBox(8),
                                              LinearProgressIndicator(
                                                value: double.parse(
                                                  "${getUsage((user?.package?.currentPlan?.tokens ?? chatStatistics?.dailyCap ?? 0), (user?.tokenCounter?.availableTokens ?? 0)) / 100}",
                                                ),
                                                backgroundColor: Color(
                                                  0xff52525B,
                                                ),
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xffFFFFFF)),
                                                minHeight: 8,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ],
                                          ),
                                        ),
                                        heightBox(12),
                                        if (user?.package?.validEndOn !=
                                            null) ...[
                                          Row(
                                            children: [
                                              TextWidget(
                                                text: 'CURRENT PRICING',
                                                fontSize: 14.sp,
                                                color: colorWhite,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                              ),
                                              Spacer(),
                                              TextWidget(
                                                text:
                                                    "৳${user?.package?.currentPlan?.price ?? ""}",
                                                fontSize: 26.sp,
                                                color: colorWhite,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                              ),
                                            ],
                                          ),
                                          heightBox(8),
                                        ],
                                        heightBox(4),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextWidget(
                                            text: 'PLAN EXPIRES',
                                            fontSize: 14.sp,
                                            color: Color(0xffD1D5DB),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        heightBox(12),

                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(13.sp),
                                          decoration: BoxDecoration(
                                            color: Color(0xff111827),
                                            border: Border.all(
                                              color: Color(0xff52525B),
                                              width: 1.sp,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.sp,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [
                                                    TextWidget(
                                                      text: 'EXPIRES',
                                                      fontSize: 12.sp,
                                                      color: colorWhite,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    Spacer(),
                                                    TextWidget(
                                                      text: _formatShortDate(
                                                        user
                                                            ?.package
                                                            ?.validEndOn,
                                                      ),
                                                      fontSize: 12.sp,
                                                      color: Color(0xff9CA3AF),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              heightBox(14),

                                              // Usage Progress
                                              if (user?.package?.validEndOn ==
                                                  null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextWidget(
                                                    text:
                                                        'No expiration date set',
                                                    fontSize: 12.sp,
                                                    color: Color(0xff9CA3AF),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                )
                                              else
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      text: 'Time left',
                                                      fontSize: 12.sp,
                                                      color: Color(0xff9CA3AF),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    Builder(
                                                      builder: (context) {
                                                        int remainingDay =
                                                            remainingDays(
                                                              user
                                                                      ?.package
                                                                      ?.validEndOn ??
                                                                  DateTime.now(),
                                                            );
                                                        return TextWidget(
                                                          text:
                                                              '${remainingDay}d remaining',
                                                          fontSize: 12.sp,
                                                          color: colorWhite,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Roboto',
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              heightBox(8),

                                              if (user?.package?.validEndOn ==
                                                  null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextWidget(
                                                    text: 'No expiration date',
                                                    fontSize: 12.sp,
                                                    color: Color(0xff9CA3AF),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                )
                                              else
                                                LinearProgressIndicator(
                                                  value:
                                                      remainingDays(
                                                        user
                                                                ?.package
                                                                ?.validEndOn ??
                                                            DateTime.now(),
                                                      ) /
                                                      30,
                                                  backgroundColor: Color(
                                                    0xff52525B,
                                                  ),
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xffFFFFFF)),
                                                  minHeight: 8,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  heightBox(20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextWidget(
                                      text: 'Packages',
                                      fontSize: 24.sp,
                                      color: colorWhite,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  heightBox(16),

                                  ...(paymentCubit.subscriptionPlans
                                      .map((plan) => _buildPlanCard(plan))
                                      .toList()),

                                  _buildPaymentMethodsCard(),

                                  heightBox(80),
                                ],
                              ),
                            ),
                          ),

                        if (paymentCubit.selectedTab == 1)
                          // Content
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.sp,
                                vertical: 15.sp,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.sp,
                                    ),
                                    child: TextWidget(
                                      text:
                                          'So How Much Tokens Per Generation Cost?',
                                      fontSize: 20.sp,
                                      color: colorWhite,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Roboto',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  heightBox(20),

                                  // Token Pricing Chart
                                  _buildTokenPricingCard(),

                                  heightBox(40),
                                ],
                              ),
                            ),
                          ),

                        if (paymentCubit.selectedTab == 2)
                          // Content
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.sp,
                                vertical: 15.sp,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: TextWidget(
                                      text: 'Need More Tokens?',
                                      fontSize: 24.sp,
                                      color: colorWhite,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),

                                  heightBox(10),
                                  TextWidget(
                                    text:
                                        'Running low on tokens? Buy more anytime! Use them with any AI model included in your plan. Available after subscribing to any package above.',
                                    fontSize: 9.sp,
                                    color: Color(0xff9CA3AF),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                    textAlign: TextAlign.center,
                                  ),

                                  heightBox(20),

                                  // Top-Up Tokens Section
                                  _buildTopUpTokensSection(),

                                  heightBox(20),

                                  // Payment Methods
                                  _buildPaymentMethodsCard(),

                                  heightBox(20),

                                  // // Recent Transactions
                                  // _buildTransactionsCard(),
                                  heightBox(40),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                    : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF000000),
                            Color(0xFF000000),
                            Color.fromARGB(255, 20, 22, 30),
                            Color(0xFF0C1028), // Blue shade
                          ],
                        ),
                      ),
                      child: Center(child: commonLoader()),
                    ),
          );
        },
      ),
    );
  }

  int getUsage(int total, int limit) {
    // print("total $total limit $limit");

    int multiple = limit * 100;
    // print("multiple $multiple");
    // print("limit $limit");

    if (total == 0) {
      return 100;
    }

    int result = (multiple ~/ total);
    // print("result $result");
    return result;
  }

  int remainingDays(DateTime targetDate) {
    final today = DateTime.now();

    // Remove time portion to avoid partial-day differences
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final targetDateOnly = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    final difference = targetDateOnly.difference(todayDateOnly).inDays;
    if (difference < 0) {
      return 0;
    }
    return difference + 1;
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    final isActive = ProfileService.user?.package?.currentPlan?.id == plan.id;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 26.sp, left: 20.sp, right: 20.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF1C1D34).withOpacity(0.63)],
        ),
        border: Border.all(
          color: isActive ? colorWhite : Color(0xFF52525B),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextWidget(
                    text: plan.name?.trim() ?? "",
                    fontSize: 20.sp,
                    color: colorWhite,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                  ),
                ),
                // Badge
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      text:
                          '৳${plan.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',

                      fontSize: 20.sp,
                      color: Color(0xFFD1D5DB),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                    TextWidget(
                      text: '/ Monthly',
                      fontSize: 8.sp,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                  ],
                ),
              ],
            ),

            heightBox(10),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 9.sp),

              decoration: BoxDecoration(
                color: Color(0xFF10151C),

                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: TextWidget(
                  text:
                      '${plan.tokens.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Pro Tokens',
                  fontSize: 14.sp,
                  color: colorWhite,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            heightBox(10),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 9.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive ? colorWhite : Color(0xFF52525B),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _selectedLoadingPlan,
                  builder: (context, value, child) {
                    if (_selectedLoadingPlan.value == plan.id) {
                      return CupertinoActivityIndicator();
                    }
                    return TextWidget(
                      text:
                          isActive ? '☑ Current Active Plan' : '🚀 Get Started',
                      fontSize: 16.sp,
                      color: colorWhite,

                      fontWeight: FontWeight.w600,
                      onTap:
                          isActive || _selectedLoadingPlan.value.isNotEmpty
                              ? null
                              : () => _onSelectPlan(plan.id ?? ''),
                    );
                  },
                ),
              ),
            ),

            heightBox(16),

            FeaturesList(features: plan.features ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpTokensSection() {
    bool hasActivePlan = ProfileService.user?.package?.currentPlan?.id != null;
    return Column(
      spacing: 24.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        paymentCubit.topUpPlans.length,
        (index) => Opacity(
          opacity: hasActivePlan ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !hasActivePlan,
            child: _buildTopUpPackageCard(
              paymentCubit.topUpPlans[index],
              index,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpPackageCard(TopUpPlanModel package, int index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF1C1D34).withOpacity(0.63)],
        ),
        border: Border.all(color: Color(0xFF52525B), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextWidget(
                  text: package.name ?? "",
                  fontSize: 20.sp,
                  color: colorWhite,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
              ),
              // Badge
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextWidget(
                    text:
                        '৳${package.basePrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',

                    fontSize: 20.sp,
                    color: Color(0xFFD1D5DB),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                  ),
                  TextWidget(
                    text: '/ Valid Until Subscription Expiry',
                    fontSize: 8.sp,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                  ),
                ],
              ),
            ],
          ),

          heightBox(16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 9.sp),
            decoration: BoxDecoration(
              color: Color(0xFF10151C),

              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: TextWidget(
                text:
                    '${package.tokens.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Pro Tokens',
                fontSize: 14.sp,
                color: colorWhite,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
              ),
            ),
          ),

          heightBox(10),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 9.sp),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF52525B),
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: _selectedLoadingPlan,
                builder: (context, value, child) {
                  if (_selectedLoadingPlan.value == package.id) {
                    return CupertinoActivityIndicator();
                  }
                  return TextWidget(
                    text: '🛒  Purchase',
                    fontSize: 16.sp,
                    color: colorWhite,
                    fontWeight: FontWeight.w600,
                    onTap:
                        _selectedLoadingPlan.value.isNotEmpty
                            ? null
                            : () => _onPurchaseTopUp(package.id ?? ""),
                  );
                },
              ),
            ),
          ),

          heightBox(16),

          ...package.features
                  ?.map(
                    (e) => Padding(
                      padding: EdgeInsets.only(left: 48.sp),
                      child: TextWidget(
                        text: '• ${e.toString()}',
                        fontSize: 13.sp,
                        color: Color(0xFFD1D5DB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ],
      ),
    );
  }

  Widget _buildTokenPricingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Image and Upscaler Section
        _buildPricingCategory('AI Image and Upscaler', [
          _buildPricingItem('ImageX', {
            'Low': '4,024 / 5,854 tokens',
            'Medium': '15,366 / 23,049 tokens',
            'High': '61,098 / 91,585 tokens',
          }),
          _buildPricingItem('Flux', {
            'Flux Pro': '732 tokens',
            'Flux Pro 1.1': '5,488 tokens',
            'Kontext Pro 2.0': '14,634 tokens',
          }),
          _buildPricingItem('Nano Banana', {}, value: '14,634 tokens'),
          _buildPricingItem('Image Restorer', {
            'Kontext Restore': '19,512 tokens',
          }),
        ], isActive: true),

        heightBox(16),

        // AI Video Generation Section (Expandable)
        _buildExpandablePricingCategory(),

        heightBox(16),

        // AI Text & Music Section
        _buildPricingCategory('AI Text to Speech & Music', [
          _buildPricingItem('Udio AI', {}, value: '20,122'),
          _buildPricingItem('ElevenLabs', {
            "Flash v2.5 - 10s": "5,080",
            "Turbo v2.5 - 10s": "5,080",
            "Sound Effects - 10s": "24,440",
          }),
        ]),

        heightBox(16),

        // AI Detector Section
        _buildPricingCategory('AI Detector', [
          _buildPricingItem('Humanizer', {}, value: '300 per word'),
          _buildPricingItem('AI Detector', {}, value: '30 per word'),
        ]),
      ],
    );
  }

  Widget _buildPricingCategory(
    String title,
    List<Widget> items, {
    bool isActive = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Color(0xff10151C),
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(
          color: isActive ? colorWhite : Color(0xff52525B),
          width: 1.sp,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff000000), Color(0xff1C1D34).withOpacity(0.63)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            fontSize: 14.sp,
            color: colorWhite,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
          heightBox(8),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: items),
        ],
      ),
    );
  }

  Widget _buildExpandablePricingCategory() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Color(0xff52525B), width: 1.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff000000),
            Color(0xff1C1D34).withValues(alpha: 0.63),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'AI Video Generation',
            fontSize: 14.sp,
            color: colorWhite,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
          heightBox(8),
          // Always visible items
          _buildPricingItem('Veo3', {}, value: '20,00,000 tokens'),
          _buildPricingItem('RunwayML', {
            '5s': '97,561 tokens',
            '10s': '1,95,122 tokens',
          }),

          // Expandable items
          if (_isVideoSectionExpanded) ...[
            _buildPricingItem('KlingAI', {
              'STD v1.6 - 5s': '1,01,463 tokens',
              'STD v1.6 - 10s': '2,02,927 tokens',
              'PRO v1.6 - 5s': '1,79,512 tokens',
              'PRO v1.6 - 10s': '3,58,049 tokens',
              'PRO v2.0 - 5s': '3,74,146 tokens',
              'PRO v2.0 - 10s': '7,49,268 tokens',
              'STD v2.1 - 5s': '97,561 tokens',
              'STD v2.1 - 10s': '195,122 tokens',
              'PRO v2.1 - 5s': '175,610 tokens',
              'PRO v2.1 - 10s': '351,220 tokens',
            }),
            _buildPricingItem('Vgen', {
              '5s, 540P': '1,09,756 tokens',
              '5s, 720P': '1,46,341 tokens',
              '8s, 540P': '2,19,582 tokens',
              '8s, 720P': '2,92,682 tokens',
            }),
            _buildPricingItem('Seedance', {
              'Pro 480p - 5s': '54,878 tokens',
              'Pro 1080p - 5s': '2,74,390 tokens',
              'Pro 1080p - 10s': '548,780 tokens',
              'Lite 480p - 5s': '32,927 tokens',
              'Lite 480p - 10s': '65,854 tokens',
              'Lite 720p - 5s': '65,854 tokens',
              'Lite 720p - 10s': '131,707 tokens',
            }),
            _buildPricingItem('Hailuo', {
              '6s': '36,585 tokens',
              '10s': '54,878 tokens',
            }),
            _buildPricingItem('Wan', {
              '480p': '18,293 tokens',
              '720p': '40,244 tokens',
            }),
          ],

          // Expand/Collapse button
          heightBox(12),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVideoSectionExpanded = !_isVideoSectionExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 8.sp,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Color(0xff4B55634D), width: 1),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isVideoSectionExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Color(0xffD1D5DB),
                        size: 16.sp,
                      ),
                      widthBox(6),
                      TextWidget(
                        text:
                            _isVideoSectionExpanded
                                ? 'See Less'
                                : 'See More (20 more lines)',
                        fontSize: 12.sp,
                        color: Color(0xffD1D5DB),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingItem(
    String name,
    Map<String, String> options, {
    String? value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              getSVGIcon(name),

              SizedBox(width: 6.sp),
              TextWidget(
                text: name,
                fontSize: 14.sp,
                color: colorWhite,
                fontWeight: FontWeight.w500,
              ),
              if (value != null)
                Expanded(
                  flex: 3,
                  child: TextWidget(
                    text: value,
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
          heightBox(4),
          Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.sp,
              children:
                  options.entries
                      .map(
                        (option) => Row(
                          children: [
                            TextWidget(
                              text: '• ${option.key}',
                              fontSize: 12.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 6.sp),
                            Expanded(
                              flex: 3,
                              child: TextWidget(
                                text: '${option.value}',
                                fontSize: 12.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff10151C),
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Color(0xff52525B), width: 1.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff000000), Color(0xff1C1D34).withOpacity(0.63)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        children: [
          TextWidget(
            text: 'Secure Payment Partners',
            fontSize: 17.sp,
            color: colorWhite,
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto',
          ),

          heightBox(16),
          TextWidget(
            text:
                'We partner with trusted payment providers to ensure your transactions are safe and secure.',
            fontSize: 10.sp,
            color: Color(0xff6B7280),
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
            textAlign: TextAlign.center,
          ),

          heightBox(16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Color(0xff06060B),
              border: Border.all(color: Color(0xff52525B), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 1.8,
              child: Center(
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.sp,
                  mainAxisSpacing: 16.sp,
                  childAspectRatio: 3 / 2,
                  children:
                      [
                        PNGImages.payment1,
                        PNGImages.payment2,
                        PNGImages.payment3,
                        PNGImages.payment4,
                        PNGImages.payment5,
                        PNGImages.payment6,
                      ].map<Widget>((e) {
                        return AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.asset(e),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatShortDate(DateTime? date) {
    if (date == null) {
      return "";
    }
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }

  final ValueNotifier<String> _selectedLoadingPlan = ValueNotifier<String>("");

  Future<void> _onSelectPlan(String planId) async {
    try {
      _selectedLoadingPlan.value = planId;

      await startPaymentFlow(context: context, planId: planId);

      _selectedLoadingPlan.value = "";
    } catch (e) {
      _selectedLoadingPlan.value = "";
    } finally {
      _selectedLoadingPlan.value = "";
    }
  }

  Future<void> _onPurchaseTopUp(String packageId) async {
    try {
      _selectedLoadingPlan.value = packageId;

      await startPaymentFlow(context: context, topUpId: packageId);

      _selectedLoadingPlan.value = "";
    } catch (e) {
      _selectedLoadingPlan.value = "";
    } finally {
      _selectedLoadingPlan.value = "";
    }
  }

  Future<void> retryPayment(String? planId) async {
    Navigator.pop(context);
    await Future.delayed(Duration.zero, () {});
    startPaymentFlow(context: context, planId: planId);
    return;
  }

  Future<void> startPaymentFlow({
    required BuildContext context,
    String? planId,
    String? topUpId,
  }) async {
    final session = await PaymentApi.makePayment(
      planId: planId,
      topUpId: topUpId,
    );

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder:
            (_) => PaymentWebViewPage(
              gatewayPageURL: session.gatewayPageURL,
              tranId: session.tranId,
            ),
      ),
    );

    await ProfileService.getCurrentUser();
    await ProfileService.getChatStatistics();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));

    if (result == null) {
      push(
        context,
        enterPage: PaymentStatus(
          isSuccess: false,
          onRetry: () => retryPayment(planId),
        ),
      );
      return;
    }

    final status = result['status'] as String? ?? 'UNKNOWN';
    final bool timeout = result['timeout'] == true;

    if (status == 'COMPLETED') {
      push(context, enterPage: PaymentStatus());
      // await paymentCubit.getUserData();
      await paymentCubit.getAllPaymentHistory();
    } else if (status == 'NOT_FOUND') {
      push(
        context,
        enterPage: PaymentStatus(
          isSuccess: false,
          onRetry: () => retryPayment(planId),
        ),
      );
    } else if (timeout) {
      push(
        context,
        enterPage: PaymentStatus(
          isSuccess: false,
          title: "Timeout",
          description:
              "Your payment has been failed due to timeout, please try again",
          onRetry: () => retryPayment(planId),
        ),
      );
    } else {
      push(
        context,
        enterPage: PaymentStatus(
          isSuccess: false,
          onRetry: () => retryPayment(planId),
        ),
      );
    }
  }
}

class FeaturesList extends StatelessWidget {
  final List<dynamic> features;
  final Color colorWhite = Colors.white;

  const FeaturesList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          features.map((feature) {
            if (feature is String && feature.isNotEmpty) {
              // ✅ Simple String Feature
              return _buildFeatureRow(feature.trim());
            } else if (feature is Map<String, dynamic> && feature.isNotEmpty) {
              // ✅ Handle Map Feature
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      feature.entries.map((entry) {
                        return _buildMapEntry(entry.key, entry.value);
                      }).toList(),
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
    );
  }

  /// Render single feature row
  Widget _buildFeatureRow(String text, {bool isTitle = false}) {
    String formatTitle(String key) {
      return key
          .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
          .replaceAllMapped(
            RegExp(r'([A-Z])([A-Z][a-z])'),
            (m) => '${m[1]} ${m[2]}',
          )
          .trim();
    }

    String displayText = isTitle ? formatTitle(text) : text;

    if (text.toLowerCase().contains("unlimited") ||
        text.toLowerCase().contains("everything") ||
        text.toLowerCase().contains("own")) {
      return Text(
        "☑ $displayText",
        style: TextStyle(
          fontSize: 13.sp,
          color: Color(0xFFD1D5DB),
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isTitle) getSVGIcon(displayText),
          if (!isTitle) SizedBox(width: 8.w),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: isTitle ? 14.sp : 12.sp,
                color: isTitle ? colorWhite : Color(0xFFD1D5DB),
                fontWeight: isTitle ? FontWeight.w600 : FontWeight.w500,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Render Map entries (nested cases)
  Widget _buildMapEntry(String title, dynamic value) {
    if (value is List) {
      // ✅ Case: value is a List (e.g., VideoGenerationModels)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureRow(title, isTitle: true),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                value.map<Widget>((item) {
                  return _buildFeatureRow(item.toString());
                }).toList(),
          ),
        ],
      );
    } else if (value is Map) {
      // ✅ Case: nested Map (e.g., ImageGenerationModels with subcategories)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureRow(title, isTitle: true),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                value.entries.map<Widget>((subEntry) {
                  if (subEntry.value is List) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (subEntry.value as List).map<Widget>((item) {
                            return item.toString().isEmpty
                                ? SizedBox.shrink()
                                : _buildFeatureRow(item.toString());
                          }).toList(),
                    );
                  } else {
                    return _buildFeatureRow(
                      "${subEntry.key}: ${subEntry.value}",
                    );
                  }
                }).toList(),
          ),
        ],
      );
    } else {
      // ✅ Fallback for direct string or number
      return _buildFeatureRow(value.toString());
    }
  }
}

Widget getSVGIcon(String icon) {
  String? iconPath = getSVGIconPath(icon);

  if (iconPath == null) {
    return const SizedBox.shrink();
  }

  if (iconPath.contains(".png")) {
    return Image.asset(iconPath, height: 12.sp, width: 12.sp);
  }

  return SvgPicture.asset(
    iconPath,
    // colorFilter: ColorFilter.mode(colorWhite, BlendMode.srcIn),
    height: 12.sp,
    width: 12.sp,
  );
}

String? getSVGIconPath(String icon) {
  String? iconPath;
  if (icon.toLowerCase().contains("chatgpt")) {
    iconPath = "assets/ai_icon/chatgpt-white.svg";
  } else if (icon.toLowerCase().contains("gemini")) {
    iconPath = "assets/ai_icon/gemini.svg";
  } else if (icon.toLowerCase().contains("deepseek")) {
    iconPath = "assets/ai_icon/deepseek.svg";
  } else if (icon.toLowerCase().contains("grok")) {
    iconPath = "assets/ai_icon/grok-white.svg";
  } else if (icon.toLowerCase().contains("claude")) {
    iconPath = "assets/ai_icon/cloude-white.svg";
  } else if (icon.toLowerCase().contains("llama")) {
    iconPath = "assets/ai_icon/llama.svg";
  } else if (icon.toLowerCase().contains("qwen")) {
    iconPath = "assets/ai_icon/qwen-white.svg";
  } else if (icon.toLowerCase().contains("mistral")) {
    iconPath = "assets/ai_icon/mistral.svg";
  } else if (icon.toLowerCase().contains("flux")) {
    iconPath = "assets/ai_icon/flux.svg";
  } else if (icon.toLowerCase().contains("restorer")) {
    iconPath = "assets/ai_icon/flux.svg";
  } else if (icon.toLowerCase().contains("kontext")) {
    iconPath = "assets/ai_icon/flux.svg";
  } else if (icon.toLowerCase().contains("perplexity")) {
    iconPath = "assets/ai_icon/perplexity.svg";
  } else if (icon.toLowerCase().contains("imagex")) {
    iconPath = "assets/icons/logo.svg";
  } else if (icon.toLowerCase().contains("runwayml")) {
    iconPath = "assets/ai_icon/runway_ml.svg";
  } else if (icon.toLowerCase().contains("vgen")) {
    iconPath = "assets/ai_icon/vgen.svg";
  } else if (icon.toLowerCase().contains("seedance")) {
    iconPath = "assets/ai_icon/seedance.png";
    // iconPath = "assets/ai_icon/kling.svg";
  } else if (icon.toLowerCase().contains("kling")) {
    iconPath = "assets/ai_icon/kling.svg";
  } else if (icon.toLowerCase().contains("hailuo")) {
    iconPath = "assets/ai_icon/hailuo.svg";
  } else if (icon.toLowerCase().contains("wan")) {
    iconPath = "assets/ai_icon/wan.svg";
  } else if (icon.toLowerCase().contains("udio")) {
    iconPath = "assets/ai_icon/udioai.svg";
  } else if (icon.toLowerCase().contains("elevenlabs")) {
    iconPath = "assets/ai_icon/elevenlabs.svg";
  } else if (icon.toLowerCase().contains("humanizer")) {
    iconPath = "assets/ai_icon/humanizer.svg";
  } else if (icon.toLowerCase().contains("veo3")) {
    iconPath = "assets/ai_icon/google.svg";
  } else if (icon.toLowerCase().contains("banana")) {
    iconPath = "assets/ai_icon/google.svg";
  } else if (icon.toLowerCase().contains("ai detector")) {
    iconPath = "assets/ai_icon/humanizer.svg";
  } else if (icon.toLowerCase().contains("sora")) {
    iconPath = "assets/ai_icon/sora_ai.svg";
  }
  return iconPath;
}
