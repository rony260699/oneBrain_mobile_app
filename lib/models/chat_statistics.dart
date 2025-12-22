import 'package:OneBrain/models/plan_user_model.dart';
import 'package:intl/intl.dart';

class ChatStatistics {
  int? remainingTokens;
  String? nextAvailableReset;
  UserModel? user;
  int? dailyCap;
  int? dailySpentTokens;
  bool? dailyCapHit;
  DateTime? resetAt;
  SuggestedModel? suggestedModel;

  ChatStatistics({
    this.remainingTokens,
    this.nextAvailableReset,
    this.user,
    this.dailyCap,
    this.dailySpentTokens,
    this.dailyCapHit,
    this.resetAt,
    this.suggestedModel,
  });

  ChatStatistics.fromJson(Map<String, dynamic> json) {
    remainingTokens = json['remainingTokens'];
    nextAvailableReset = json['nextAvailableReset'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    dailyCap = json['dailyCap'];
    dailySpentTokens = json['dailySpentTokens'] ?? 0;
    dailyCapHit = json['dailyCapHit'];
    resetAt = DateTime.tryParse(json['resetAt']?.toString() ?? '');
    suggestedModel =
        json['suggestedModel'] != null
            ? SuggestedModel.fromJson(json['suggestedModel'])
            : null;
  }

  int get valideDailySpentTokens {  
    if ((dailySpentTokens ?? 0) > (dailyCap ?? 0)) return dailyCap!;
    return dailySpentTokens!;
  }

  String? get resetAtFormatted {
    //5:30:00 AM.
    //convert to 12 hour format
    if (resetAt == null) return null;
    String formattedTime = DateFormat('hh:mm a').format(resetAt!.toLocal());
    return formattedTime;
  }

  int get remainingDailyCapTokens {
    return (dailyCap ?? 0) - (valideDailySpentTokens);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remainingTokens'] = remainingTokens;
    data['nextAvailableReset'] = nextAvailableReset;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['dailyCap'] = dailyCap;
    data['dailySpentTokens'] = dailySpentTokens;
    data['dailyCapHit'] = dailyCapHit;
    data['resetAt'] = resetAt;
    if (suggestedModel != null) {
      data['suggestedModel'] = suggestedModel!.toJson();
    }
    return data;
  }
}

class SmsOTP {
  String? otp;
  String? resendIn;
  String? expiresIn;

  SmsOTP({this.otp, this.resendIn, this.expiresIn});

  SmsOTP.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    resendIn = json['resendIn'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['resendIn'] = resendIn;
    data['expiresIn'] = expiresIn;
    return data;
  }
}

class Statistics {
  ImageGenerationStatistics? imageGenerationStatistics;

  Statistics({this.imageGenerationStatistics});

  Statistics.fromJson(Map<String, dynamic> json) {
    imageGenerationStatistics =
        json['image_generation_statistics'] != null
            ? ImageGenerationStatistics.fromJson(
              json['image_generation_statistics'],
            )
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageGenerationStatistics != null) {
      data['image_generation_statistics'] = imageGenerationStatistics!.toJson();
    }
    return data;
  }
}

class ImageGenerationStatistics {
  FluxImageGeneration? fluxImageGeneration;
  FluxImageGeneration? imagexImageGeneration;
  FluxImageGeneration? nanobananaImageGeneration;

  ImageGenerationStatistics({
    this.fluxImageGeneration,
    this.imagexImageGeneration,
    this.nanobananaImageGeneration,
  });

  ImageGenerationStatistics.fromJson(Map<String, dynamic> json) {
    fluxImageGeneration =
        json['flux_image_generation'] != null
            ? FluxImageGeneration.fromJson(json['flux_image_generation'])
            : null;
    imagexImageGeneration =
        json['imagex_image_generation'] != null
            ? FluxImageGeneration.fromJson(json['imagex_image_generation'])
            : null;
    nanobananaImageGeneration =
        json['nanobanana_image_generation'] != null
            ? FluxImageGeneration.fromJson(json['nanobanana_image_generation'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fluxImageGeneration != null) {
      data['flux_image_generation'] = fluxImageGeneration!.toJson();
    }
    if (imagexImageGeneration != null) {
      data['imagex_image_generation'] = imagexImageGeneration!.toJson();
    }
    if (nanobananaImageGeneration != null) {
      data['nanobanana_image_generation'] = nanobananaImageGeneration!.toJson();
    }
    return data;
  }
}

class FluxImageGeneration {
  int? count;

  FluxImageGeneration({this.count});

  FluxImageGeneration.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class Package {
  Null? currentPlan;
  Null? currentPayment;
  String? validEndOn;
  String? subscribedAt;
  String? createdAt;
  String? updatedAt;

  Package({
    this.currentPlan,
    this.currentPayment,
    this.validEndOn,
    this.subscribedAt,
    this.createdAt,
    this.updatedAt,
  });

  Package.fromJson(Map<String, dynamic> json) {
    currentPlan = json['current_plan'];
    currentPayment = json['current_payment'];
    validEndOn = json['validEndOn'];
    subscribedAt = json['subscribedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_plan'] = currentPlan;
    data['current_payment'] = currentPayment;
    data['validEndOn'] = validEndOn;
    data['subscribedAt'] = subscribedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class SuggestedModel {
  String? provider;
  String? model;

  SuggestedModel({this.provider, this.model});

  SuggestedModel.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider'] = provider;
    data['model'] = model;
    return data;
  }
}
