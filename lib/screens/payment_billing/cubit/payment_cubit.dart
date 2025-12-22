import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:OneBrain/screens/payment_billing/cubit/payment_state.dart';
import 'package:OneBrain/screens/payment_billing/model/payment_history_model.dart';
import 'package:OneBrain/models/plan_model.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentInitialState());

  static PaymentCubit get(BuildContext context) => BlocProvider.of(context);

  List<SubscriptionPlanModel> subscriptionPlans = [];
  List<TopUpPlanModel> topUpPlans = [];

  // String generateTranId() {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   final random = DateTime.now().microsecond; // or use Random().nextInt()
  //   return "tran_$timestamp$random";
  // }

  List<PaymentHistory> paymentHistory = [];

  Future<void> getAllPaymentHistory() async {
    try {
      final value = await DioHelper.getData(
        url: RestConstants.userSuccessfulPaymentList,
        isHeader: true,
      );

      if ((value.statusCode ?? 0) == 200 || (value.statusCode ?? 0) == 201) {
        if (value.data["data"] != null) {
          paymentHistory.clear();

          List<PaymentHistory> tempPaymentHistory =
              value.data["data"]
                  .map<PaymentHistory>((e) => PaymentHistory.fromJson(e))
                  .toList();

          paymentHistory.addAll(tempPaymentHistory);
        }
      } else {
        // emit(PaymentErrorState(value.data["message"]));
        return;
      }

      emit(PaymentSuccessState());
    } catch (error) {
      emit(PaymentErrorState(error.toString()));
    } finally {
      emit(PaymentSuccessState());
    }
  }

  void changeTab(int index) {
    selectedTab = index;
    emit(PaymentSuccessState());
  }

  int selectedTab = 0;

  Future<void> getAllPlans() async {
    // emit(PaymentLoadingState());

    try {
      /// USER DATA

      // await getUserData(needLoader: false);

      await ProfileService.getCurrentUser();
      await ProfileService.getChatStatistics();

      /// SUBSCRIPTION
      final subsValue = await DioHelper.getData(
        url: RestConstants.getPlanListUrl,
        isHeader: true,
      );

      if ((subsValue.statusCode ?? 0) == 200 ||
          (subsValue.statusCode ?? 0) == 201) {
        subscriptionPlans.clear();
        if (subsValue.data["data"] is List) {
          final List subsJsonList = subsValue.data["data"];

          List<SubscriptionPlanModel> tempSubsPlans =
              subsJsonList
                  .map((e) => SubscriptionPlanModel.fromJson(e))
                  .toList();

          subscriptionPlans.addAll(
            tempSubsPlans
                .where(
                  (element) => int.parse("${element.price ?? "0"}") > 0,
                  // && element.origin == "bd",
                )
                .toList(),
          );
        }
      } else {
        emit(PaymentErrorState(subsValue.data["message"]));
        return;
      }

      /// TOP-UP
      final topUpValue = await DioHelper.getData(
        url: RestConstants.getTopUpPlanListUrl,
        isHeader: true,
      );

      if ((topUpValue.statusCode ?? 0) == 200 ||
          (topUpValue.statusCode ?? 0) == 201) {
        topUpPlans.clear();
        if (topUpValue.data["data"] is List) {
          final List topUpJsonList = topUpValue.data["data"];

          List<TopUpPlanModel> tempTopUpPlans =
              topUpJsonList.map((e) => TopUpPlanModel.fromJson(e)).toList();

          topUpPlans.addAll(
            tempTopUpPlans
                .where(
                  (element) => int.parse("${element.basePrice ?? "0"}") > 0,
                  // && element.origin == "bd",
                )
                .toList(),
          );
        }
      } else {
        emit(PaymentErrorState(topUpValue.data["message"]));
        return;
      }

      await getAllPaymentHistory();

      emit(PaymentSuccessState());
    } catch (error) {
      emit(PaymentErrorState(error.toString()));
    }
  }

  Future<void> getPaymentHistory() async {
    emit(PaymentLoadingState());

    try {
      await ProfileService.getCurrentUser();

      await getAllPaymentHistory();

      emit(PaymentSuccessState());
    } catch (error) {
      emit(PaymentErrorState(error.toString()));
    }
  }
}
