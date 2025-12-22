class AIModel {
  String? company;
  String? provider;
  String? changedProvider;
  String? name;
  String? model;
  String? changedModel;
  String? image;
  bool? isNew;
  bool? isFree;
  List<int>? disabledPackages;
  List<String>? includedPackages;
  bool? forPro;
  bool? isActive;
  List<String>? capability;
  List<String>? category;
  List<String>? tags;
  List<String>? features;
  String? systemPrompt;
  String? description;
  num? inputCost;
  num? outputCost;
  bool? isLocked;

  AIModel({
    this.company,
    this.provider,
    this.changedProvider,
    this.name,
    this.model,
    this.changedModel,
    this.image,
    this.isNew,
    this.isFree,
    this.disabledPackages,
    this.includedPackages,
    this.forPro,
    this.isActive,
    this.capability,
    this.category,
    this.tags,
    this.features,
    this.systemPrompt,
    this.description,
    this.inputCost,
    this.outputCost,
    this.isLocked,
  });

  AIModel.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    provider = json['provider'];
    changedProvider = json['changedProvider'];
    name = json['name'];
    model = json['model'];
    changedModel = json['changedModel'];
    image = json['image'];
    isNew = json['isNew'];
    isFree = json['isFree'];
    disabledPackages = json['disabledPackages'].cast<int>();
    includedPackages = json['includedPackages'].cast<String>();
    forPro = json['forPro'];
    isActive = json['isActive'];
    capability = json['capability'].cast<String>();
    category = json['category'].cast<String>();
    tags = json['tags'].cast<String>();
    features = json['features'].cast<String>();
    systemPrompt = json['system_prompt'];
    description = json['description'];
    inputCost = json['inputCost'];
    outputCost = json['outputCost'];
    isLocked = json['isLocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['provider'] = provider;
    data['changedProvider'] = changedProvider;
    data['name'] = name;
    data['model'] = model;
    data['changedModel'] = changedModel;
    data['image'] = image;
    data['isNew'] = isNew;
    data['isFree'] = isFree;
    data['disabledPackages'] = disabledPackages;
    data['includedPackages'] = includedPackages;
    data['forPro'] = forPro;
    data['isActive'] = isActive;
    data['capability'] = capability;
    data['category'] = category;
    data['tags'] = tags;
    data['features'] = features;
    data['system_prompt'] = systemPrompt;
    data['description'] = description;
    data['inputCost'] = inputCost;
    data['outputCost'] = outputCost;
    data['isLocked'] = isLocked;
    return data;
  }
}
