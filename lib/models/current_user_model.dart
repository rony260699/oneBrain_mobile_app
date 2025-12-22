import 'package:OneBrain/models/plan_user_model.dart';

class LoggedInUserModel {
  LoggedInUserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.options,
  });

  String accessToken;
  String refreshToken;
  final UserModel? user;
  final Options? options;

  factory LoggedInUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedInUserModel(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      options:
          json["options"] == null ? null : Options.fromJson(json["options"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "user": user?.toJson(),
    "options": options?.toJson(),
  };
}

class Options {
  Options({required this.httpOnly, required this.secure});

  final bool httpOnly;
  final bool secure;

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      httpOnly: json["httpOnly"] ?? false,
      secure: json["secure"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {"httpOnly": httpOnly, "secure": secure};
}
