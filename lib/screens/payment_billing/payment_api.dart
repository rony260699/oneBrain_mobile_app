import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';

abstract class PaymentApi {
  static Future<({String gatewayPageURL, String tranId})> makePayment({
    String? planId,
    String? topUpId,
  }) async {
    try {
      assert(
        (planId != null) ^ (topUpId != null),
        'Exactly one of planId or topUpId is required.',
      );
      final body = {
        if (planId != null) 'planId': planId,
        if (topUpId != null) 'topUpId': topUpId,
        "currency": "BDT",
        "location": "bd",
      };

      final res = await DioHelper.postData(
        url: RestConstants.baseUrl + RestConstants.makePayment,
        isHeader: true,
        data: body,
      );

      final data = res.data['data'] as Map<String, dynamic>;

      return (
        gatewayPageURL: data['gatewayPageURL'] as String,
        tranId: data['transaction_id'] as String,
      );
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getPaymentStatus(String tranId) async {
    try {
      final res = await DioHelper.getData(
        url: RestConstants.paymentStatus + tranId,
        isHeader: true,
      );

      return Map<String, dynamic>.from(res.data['data'] as Map);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
