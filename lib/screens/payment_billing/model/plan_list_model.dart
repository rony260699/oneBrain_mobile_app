// class PlanListModel {
//   final String planName;
//   final String planType;
//   final double planPrice;
//   final double planMainPrice;
//   final String planCurrency;
//   final String planCurrencySymbol;
//   final String planFeatureTitle;
//   final List<String> arrOfFeatures;
//   final String planFullPrice;
//   final String planLength;
//   final bool isCurrent;
//   final String buyButtonText;

//   const PlanListModel(
//     this.planName,
//     this.planType,
//     this.planPrice,
//     this.planCurrency,
//     this.planCurrencySymbol,
//     this.planFeatureTitle,
//     this.arrOfFeatures,
//     this.planMainPrice,
//     this.planFullPrice,
//     this.planLength,
//     this.isCurrent,
//     this.buyButtonText,
//   );
// }

// /// Get Plan List ///
// class GetPlanListResponse {
//   int? statusCode;
//   List<Data>? data;
//   String? message;
//   bool? success;
//   Meta? meta;

//   GetPlanListResponse({
//     this.statusCode,
//     this.data,
//     this.message,
//     this.success,
//     this.meta,
//   });

//   GetPlanListResponse.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     message = json['message'];
//     success = json['success'];
//     meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['statusCode'] = statusCode;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = message;
//     data['success'] = success;
//     if (meta != null) {
//       data['meta'] = meta!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   String? sId;
//   String? name;
//   String? origin;
//   String? currency;
//   int? price;
//   Null? offerPrice;
//   String? duration;
//   String? interval;
//   String? bestFor;
//   List<Features>? features;
//   bool? isPopular;
//   int? tokens;

//   Data({
//     this.sId,
//     this.name,
//     this.origin,
//     this.currency,
//     this.price,
//     this.offerPrice,
//     this.duration,
//     this.interval,
//     this.bestFor,
//     this.features,
//     this.isPopular,
//     this.tokens,
//   });

//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     origin = json['origin'];
//     currency = json['currency'];
//     price = json['price'];
//     offerPrice = json['offer_price'];
//     duration = json['duration'];
//     interval = json['interval'];
//     bestFor = json['bestFor'];
//     if (json['features'] != null) {
//       features = <Features>[];
//       json['features'].forEach((v) {
//         features!.add(new Features.fromJson(v));
//       });
//     }
//     isPopular = json['isPopular'];
//     tokens = json['tokens'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['name'] = name;
//     data['origin'] = origin;
//     data['currency'] = currency;
//     data['price'] = price;
//     data['offer_price'] = offerPrice;
//     data['duration'] = duration;
//     data['interval'] = interval;
//     data['bestFor'] = bestFor;
//     if (features != null) {
//       data['features'] = features!.map((v) => v.toJson()).toList();
//     }
//     data['isPopular'] = isPopular;
//     data['tokens'] = tokens;
//     return data;
//   }
// }

// class Features {
//   GenerateImageUpTo? generateImageUpTo;

//   Features({this.generateImageUpTo});

//   Features.fromJson(Map<String, dynamic> json) {
//     generateImageUpTo =
//         json['GenerateImageUpTo'] != null
//             ? new GenerateImageUpTo.fromJson(json['GenerateImageUpTo'])
//             : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (generateImageUpTo != null) {
//       data['GenerateImageUpTo'] = generateImageUpTo!.toJson();
//     }
//     return data;
//   }
// }

// class GenerateImageUpTo {
//   ImageX? imageX;
//   ImageX? flux;

//   GenerateImageUpTo({this.imageX, this.flux});

//   GenerateImageUpTo.fromJson(Map<String, dynamic> json) {
//     imageX =
//         json['ImageX'] != null ? new ImageX.fromJson(json['ImageX']) : null;
//     flux = json['Flux'] != null ? new ImageX.fromJson(json['Flux']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (imageX != null) {
//       data['ImageX'] = imageX!.toJson();
//     }
//     if (flux != null) {
//       data['Flux'] = flux!.toJson();
//     }
//     return data;
//   }
// }

// class ImageX {
//   String? title;
//   List<String>? subFeatures;

//   ImageX({this.title, this.subFeatures});

//   ImageX.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     subFeatures = json['subFeatures'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     data['subFeatures'] = subFeatures;
//     return data;
//   }
// }

// class Meta {
//   Meta.fromJson(Map<String, dynamic> json);

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     return data;
//   }
// }
