import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/common_widgets/common_appbar.dart';
import 'package:OneBrain/screens/payment_billing/model/payment_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/color.dart';
import '../../common_widgets/common_widgets.dart';
import '../../common_widgets/text_widget.dart';
import '../../base/base_stateful_state.dart';
import 'cubit/payment_cubit.dart';
import 'cubit/payment_state.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState
    extends BaseStatefulWidgetState<PaymentHistoryScreen> {
  late PaymentCubit paymentCubit;

  @override
  void initState() {
    paymentCubit = PaymentCubit.get(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await paymentCubit.getPaymentHistory();
    });
    super.initState();
  }

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

        titleWidget: TextWidget(
          text: 'Payment History',
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
                        // Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(15.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.sp),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xff10151C),
                                    borderRadius: BorderRadius.circular(20.sp),
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
                                      TextWidget(
                                        text: 'Transactions and Receipts',
                                        fontSize: 18.sp,
                                        color: colorWhite,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),

                                      heightBox(10),
                                      TextWidget(
                                        text:
                                            'View all your payment transactions and receipts',
                                        fontSize: 14.sp,
                                        color: Color(0xff9CA3AF),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                        textAlign: TextAlign.center,
                                      ),

                                      heightBox(20),

                                      _buildTransactionsCard(),
                                    ],
                                  ),
                                ),
                                heightBox(80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                    : Center(child: commonLoader()),
          );
        },
      ),
    );
  }

  int getUsage(int total, int limit) {
    // print("total $total limit $limit");

    int multiple = total * 100;
    // print("multiple $multiple");
    // print("limit $limit");

    if (limit == 0) {
      return 100;
    }

    int result = (multiple ~/ limit);
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
    return difference;
  }

  Widget _buildTransactionsCard() {
    return Column(
      spacing: 16.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          paymentCubit.paymentHistory
              .map(
                (e) => _buildTransaction(
                  e.type == 'TopUp' ? e.topUp?.name ?? '' : e.plan?.name ?? '',
                  '৳${e.amount}',
                  e,
                  true,
                ),
              )
              .toList(),
    );
  }

  Widget _buildTransaction(
    String plan,
    String amount,
    PaymentHistory paymentHistory,
    bool success,
  ) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xff10151C),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Color(0xff52525B), width: 1.sp),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff000000), Color(0xff1C1D34).withOpacity(0.63)],
          stops: [0.0, 1.0],
        ),
      ),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: paymentHistory.formattedPurchaseDate,
                    fontSize: 14.sp,
                    color: colorWhite,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                  TextWidget(
                    text: paymentHistory.formattedPurchaseTime,
                    fontSize: 10.sp,
                    color: Color(0xff9CA3AF),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ],
              ),
              Spacer(),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xff111827),
                  // color: Colors.amber,
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                child: TextWidget(
                  text: '☑ ${paymentHistory.status}',
                  fontSize: 12.sp,
                  color: colorWhite,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),

          heightBox(12),

          _buildTransactionDetails(title: "Amount", value: amount),
          _buildTransactionDetails(
            title: "Type",
            value: paymentHistory.type ?? "",
          ),
          _buildTransactionDetails(
            title: "Method",
            value: paymentHistory.paymentMethod ?? "",
          ),
          _buildTransactionDetails(
            title: "Transaction ID",
            value: paymentHistory.transactionId ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontSize: 12.sp,
            color: Color(0xff9CA3AF),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: TextWidget(
              text: value,
              fontSize: 12.sp,
              color: colorWhite,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
