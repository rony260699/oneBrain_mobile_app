class PaymentHistory {
  String? sId;
  String? owner;
  String? valId;
  String? transactionId;
  String? status;
  String? type;
  String? paymentMethod;
  Plan? plan;
  TopUp? topUp;
  int? tokens;
  num? amount;
  String? currency;
  String? bankTranId;
  bool? ipnStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? validEndOn;

  PaymentHistory({
    this.sId,
    this.owner,
    this.valId,
    this.transactionId,
    this.status,
    this.type,
    this.paymentMethod,
    this.plan,
    this.topUp,
    this.tokens,
    this.amount,
    this.currency,
    this.bankTranId,
    this.ipnStatus,
    this.updatedAt,
    this.iV,
    this.validEndOn,
  });
  //convert 12 hour format with am pm with date 08/18/25
  String get formattedPurchaseDateAndTime {
    DateTime date = DateTime.parse(createdAt!).toLocal();
    final hour = date.hour % 12;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}/${date.year} $hour:${date.minute}:${date.second} $amPm';
  }

  String get formattedPurchaseDate {
    DateTime date = DateTime.parse(createdAt!).toLocal();

    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedPurchaseTime {
    DateTime date = DateTime.parse(createdAt!).toLocal();
    final hour = date.hour % 12;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute}:${date.second} $amPm';
  }

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    owner = json['owner'];
    valId = json['val_id'];
    transactionId = json['transaction_id'];
    status = json['status'];
    type = json['type'];
    paymentMethod = json['payment_method'];
    plan =
        json['plan'] != null
            ? json['plan'] is String
                ? Plan.fromJson({"_id": json['plan']})
                : Plan.fromJson(json['plan'])
            : null;
    topUp = json['topUp'] != null ? TopUp.fromJson(json['topUp']) : null;
    tokens = json['tokens'];
    amount = json['amount'];
    currency = json['currency'];
    bankTranId = json['bank_tran_id'];
    ipnStatus = json['ipn_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    validEndOn = json['validEndOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['owner'] = owner;
    data['val_id'] = valId;
    data['transaction_id'] = transactionId;
    data['status'] = status;
    data['type'] = type;
    data['payment_method'] = paymentMethod;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    if (topUp != null) {
      data['topUp'] = topUp!.toJson();
    }
    data['tokens'] = tokens;
    data['amount'] = amount;
    data['currency'] = currency;
    data['bank_tran_id'] = bankTranId;
    data['ipn_status'] = ipnStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['validEndOn'] = validEndOn;
    return data;
  }
}

class Plan {
  String? sId;
  String? name;
  String? origin;
  String? currency;
  int? price;
  int? offerPrice;
  String? duration;
  String? interval;
  String? bestFor;
  List<dynamic>? features;
  bool? isPopular;
  int? tokens;

  Plan({
    this.sId,
    this.name,
    this.origin,
    this.currency,
    this.price,
    this.offerPrice,
    this.duration,
    this.interval,
    this.bestFor,
    this.features,
    this.isPopular,
    this.tokens,
  });

  Plan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    origin = json['origin'];
    currency = json['currency'];
    price = json['price'];
    offerPrice = json['offer_price'];
    duration = json['duration'];
    interval = json['interval'];
    bestFor = json['bestFor'];
    features = json['features'];
    isPopular = json['isPopular'];
    tokens = json['tokens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['origin'] = origin;
    data['currency'] = currency;
    data['price'] = price;
    data['offer_price'] = offerPrice;
    data['duration'] = duration;
    data['interval'] = interval;
    data['bestFor'] = bestFor;
    data['features'] = features;
    data['isPopular'] = isPopular;
    data['tokens'] = tokens;
    return data;
  }
}

class TopUp {
  String? sId;
  String? name;
  int? price;
  int? offerPrice;
  int? tokens;
  int? days;
  String? origin;
  String? currency;
  List<String>? features;
  String? bestFor;

  TopUp({
    this.sId,
    this.name,
    this.price,
    this.offerPrice,
    this.tokens,
    this.days,
    this.origin,
    this.currency,
    this.features,
    this.bestFor,
  });

  TopUp.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    offerPrice = json['offer_price'];
    tokens = json['tokens'];
    days = json['days'];
    origin = json['origin'];
    currency = json['currency'];
    features = json['features'].cast<String>();
    bestFor = json['bestFor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['offer_price'] = offerPrice;
    data['tokens'] = tokens;
    data['days'] = days;
    data['origin'] = origin;
    data['currency'] = currency;
    data['features'] = features;
    data['bestFor'] = bestFor;
    return data;
  }
}
