import 'package:OneBrain/models/plan_model.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? googleId;
  final String? profileImage;
  final String? role;
  final bool? banStatus;
  final TokenCounter? tokenCounter;
  final bool? isVip;
  final bool? isVerified;
  final List<dynamic>? notifications;
  final List<dynamic>? purchasedPrompts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final SmsOtp? smsOtp;
  final String? phone;
  final Package? package;
  final Statistics? statistics;
  final LatestTopUp? latestTopUp;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.googleId,
    this.profileImage,
    this.role,
    this.banStatus,
    this.tokenCounter,
    this.isVip,
    this.isVerified,
    this.notifications,
    this.purchasedPrompts,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.smsOtp,
    this.phone,
    this.package,
    this.statistics,
    this.latestTopUp,
  });

  String get getFullName {
    if (firstName != null || lastName != null) {
      return '$firstName $lastName';
    } else {
      return email ?? 'Unknown';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    googleId: json["googleId"],
    profileImage: json["profile_image"],
    role: json["role"],
    banStatus: json["banStatus"],
    tokenCounter:
        json["tokenCounter"] == null
            ? null
            : TokenCounter.fromJson(json["tokenCounter"]),
    isVip: json["isVip"],
    isVerified: json["isVerified"],
    notifications:
        json["notifications"] == null
            ? []
            : List<dynamic>.from(json["notifications"]!.map((x) => x)),
    purchasedPrompts:
        json["purchasedPrompts"] == null
            ? []
            : List<dynamic>.from(json["purchasedPrompts"]!.map((x) => x)),
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    smsOtp: json["smsOTP"] == null ? null : SmsOtp.fromJson(json["smsOTP"]),
    phone: json["phone"],
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
    statistics:
        json["statistics"] == null
            ? null
            : Statistics.fromJson(json["statistics"]),
    latestTopUp:
        json["latestTopUp"] == null
            ? null
            : LatestTopUp.fromJson(json["latestTopUp"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "email": email,
    "googleId": googleId,
    "profile_image": profileImage,
    "role": role,
    "banStatus": banStatus,
    "tokenCounter": tokenCounter?.toJson(),
    "isVip": isVip,
    "isVerified": isVerified,
    "notifications":
        notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x)),
    "purchasedPrompts":
        purchasedPrompts == null
            ? []
            : List<dynamic>.from(purchasedPrompts!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "smsOTP": smsOtp?.toJson(),
    "phone": phone,
    "package": package?.toJson(),
    "statistics": statistics?.toJson(),
    "latestTopUp": latestTopUp?.toJson(),
  };
}

class LatestTopUp {
  final String? currentTopUpPlan;
  final String? currentTopUpPayment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LatestTopUp({
    this.currentTopUpPlan,
    this.currentTopUpPayment,
    this.createdAt,
    this.updatedAt,
  });

  factory LatestTopUp.fromJson(Map<String, dynamic> json) => LatestTopUp(
    currentTopUpPlan: json["current_topUp_plan"],
    currentTopUpPayment: json["current_topUp_payment"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "current_topUp_plan": currentTopUpPlan,
    "current_topUp_payment": currentTopUpPayment,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Package {
  final SubscriptionPlanModel? currentPlan;
  final String? currentPayment;
  final DateTime? validEndOn;
  final DateTime? subscribedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Package({
    this.currentPlan,
    this.currentPayment,
    this.validEndOn,
    this.subscribedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    currentPlan:
        json["current_plan"] == null
            ? null
            : SubscriptionPlanModel.fromJson(json["current_plan"]),
    currentPayment: json["current_payment"],
    validEndOn:
        json["validEndOn"] == null ? null : DateTime.parse(json["validEndOn"]),
    subscribedAt:
        json["subscribedAt"] == null
            ? null
            : DateTime.parse(json["subscribedAt"]),
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "current_plan": currentPlan?.toJson(),
    "current_payment": currentPayment,
    "validEndOn": validEndOn?.toIso8601String(),
    "subscribedAt": subscribedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class SmsOtp {
  final String? otp;
  final DateTime? resendIn;
  final DateTime? expiresIn;

  SmsOtp({this.otp, this.resendIn, this.expiresIn});

  factory SmsOtp.fromJson(Map<String, dynamic> json) => SmsOtp(
    otp: json["otp"],
    resendIn:
        json["resendIn"] == null ? null : DateTime.parse(json["resendIn"]),
    expiresIn:
        json["expiresIn"] == null ? null : DateTime.parse(json["expiresIn"]),
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "resendIn": resendIn?.toIso8601String(),
    "expiresIn": expiresIn?.toIso8601String(),
  };
}

class Statistics {
  final ImageGenerationStatistics? imageGenerationStatistics;

  Statistics({this.imageGenerationStatistics});

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    imageGenerationStatistics:
        json["image_generation_statistics"] == null
            ? null
            : ImageGenerationStatistics.fromJson(
              json["image_generation_statistics"],
            ),
  );

  Map<String, dynamic> toJson() => {
    "image_generation_statistics": imageGenerationStatistics?.toJson(),
  };
}

class ImageGenerationStatistics {
  final num? fluxImageGenerationCount;
  final num? imagexImageGenerationCount;
  final num? nanobananaImageGenerationCount;

  ImageGenerationStatistics({
    this.fluxImageGenerationCount,
    this.imagexImageGenerationCount,
    this.nanobananaImageGenerationCount,
  });

  factory ImageGenerationStatistics.fromJson(Map<String, dynamic> json) =>
      ImageGenerationStatistics(
        fluxImageGenerationCount: json["flux_image_generation_count"],
        imagexImageGenerationCount: json["imagex_image_generation_count"],
        nanobananaImageGenerationCount:
            json["nanobanana_image_generation_count"],
      );

  Map<String, dynamic> toJson() => {
    "flux_image_generation_count": fluxImageGenerationCount,
    "imagex_image_generation_count": imagexImageGenerationCount,
    "nanobanana_image_generation_count": nanobananaImageGenerationCount,
  };
}

class TokenCounter {
  final int? availableTokens;
  final DateTime? nextAvailableReset;
  final int? totalEarnings;
  final int? totalSales;
  final String? id;

  TokenCounter({
    this.availableTokens,
    this.nextAvailableReset,
    this.totalEarnings,
    this.totalSales,
    this.id,
  });

  factory TokenCounter.fromJson(Map<String, dynamic> json) => TokenCounter(
    availableTokens: json["availableTokens"],
    // availableTokens: 0,
    nextAvailableReset:
        json["nextAvailableReset"] == null
            ? null
            : DateTime.parse(json["nextAvailableReset"]),
    totalEarnings: json["totalEarnings"],
    totalSales: json["totalSales"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "availableTokens": availableTokens,
    "nextAvailableReset": nextAvailableReset?.toIso8601String(),
    "totalEarnings": totalEarnings,
    "totalSales": totalSales,
    "_id": id,
  };
}
