class SubscriptionPlanModel {
  final String? id;
  final String? name;
  final String? origin;
  final String? currency;
  final int? price;
  final int? offerPrice;
  // final int? basePrice;
  final String? duration;
  final String? interval;
  final String? bestFor;
  final List<dynamic>? features;
  final bool? isPopular;
  final int? tokens;

  SubscriptionPlanModel({
    this.id,
    this.name,
    this.origin,
    this.currency,
    this.price,
    this.offerPrice,
    // this.basePrice,
    this.duration,
    this.interval,
    this.bestFor,
    this.features,
    this.isPopular,
    this.tokens,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json["_id"],
        name: json["name"],
        origin: json["origin"],
        currency: json["currency"],
        price: json["price"] ?? json["base_price"],
        // price: 299,
        offerPrice: json["offer_price"],
        // basePrice: json["base_price"],
        duration: json["duration"],
        interval: json["interval"],
        bestFor: json["bestFor"],
        features:
            json["features"] == null
                ? []
                : List<dynamic>.from(json["features"]!.map((x) => x)),
        isPopular: json["isPopular"],
        tokens: json["tokens"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "origin": origin,
    "currency": currency,
    "price": price,
    "offer_price": offerPrice,
    // "base_price": basePrice,
    "duration": duration,
    "interval": interval,
    "bestFor": bestFor,
    "features":
        features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "isPopular": isPopular,
    "tokens": tokens,
  };
}

///
class TopUpPlanModel {
  final String? id;
  final String? name;
  final int? price;
  final int? basePrice;
  final dynamic offerPrice;
  final int? tokens;
  final int? days;
  final String? origin;
  final String? currency;
  final List<dynamic>? features;
  final String? bestFor;

  TopUpPlanModel({
    this.id,
    this.name,
    this.price,
    this.basePrice,
    this.offerPrice,
    this.tokens,
    this.days,
    this.origin,
    this.currency,
    this.features,
    this.bestFor,
  });

  factory TopUpPlanModel.fromJson(Map<String, dynamic> json) => TopUpPlanModel(
    id: json["_id"],
    name: json["name"],
    price: json["price"],
    basePrice: json["base_price"],
    offerPrice: json["offer_price"],
    tokens: json["tokens"],
    days: json["days"],
    origin: json["origin"],
    currency: json["currency"],
    features:
        json["features"] == null
            ? []
            : List<dynamic>.from(json["features"]!.map((x) => x)),
    bestFor: json["bestFor"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
    "base_price": basePrice,
    "offer_price": offerPrice,
    "tokens": tokens,
    "days": days,
    "origin": origin,
    "currency": currency,
    "features":
        features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "bestFor": bestFor,
  };
}
