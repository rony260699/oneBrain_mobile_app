// import '../model/plan_list_model.dart';

abstract class PaymentStates {}

class PaymentInitialState extends PaymentStates {}

class PaymentLoadingState extends PaymentStates {}

class PaymentSuccessState extends PaymentStates {}

class TabChangedState extends PaymentStates {}

class PaymentErrorState extends PaymentStates {
  final String errorMessage;

  PaymentErrorState(this.errorMessage);
}

/// Get plan List ///
class GetPlanListLoadingState extends PaymentStates {}

class GetPlanListSuccessState extends PaymentStates {
  // final GetPlanListResponse getPlanListResponse;

  GetPlanListSuccessState();
}

class GetPlanListErrorState extends PaymentStates {
  // final GetPlanListResponse getPlanListResponse;

  GetPlanListErrorState();
}
