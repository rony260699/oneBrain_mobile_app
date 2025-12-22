import 'dart:io';
import 'package:OneBrain/models/plan_user_model.dart';
import 'package:OneBrain/screens/authentication/verify_otp/add_phone_number.dart';
import 'package:OneBrain/screens/authentication/verify_otp/choose_otp_method_screen.dart';
import 'package:OneBrain/screens/authentication/verify_otp/otp_verify_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../common_widgets/app_utils.dart';
import '../../../../models/current_user_model.dart';
import '../../../../repo_api/dio_helper.dart';
import '../../../../repo_api/rest_constants.dart';
import '../../../../resources/strings.dart';
import '../../../../utils/shared_preference_util.dart';
import '../../../../utils/sign_in_with_apple.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isAppleLoading = false;
  AppleUser? appleUser;

  final TextEditingController txtEmail = TextEditingController();
  final FocusNode focusEmail = FocusNode();

  final TextEditingController txtPassword = TextEditingController();
  final FocusNode focusPassword = FocusNode();
  bool isPasswordHide = true;

  String emailAdded = "";
  String mobile = "";
  late bool isEmailSelected = true;

  void clearAll() {
    txtEmail.clear();
    txtPassword.clear();
    emit(LoginInitialState());
  }

  RegExp regExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  bool isValidLogin(String email) {
    if (email.isEmpty || email == "") {
      showError(message: pleaseEnterEmail.tr());
      return false;
    } else if (!regExp.hasMatch(email)) {
      showError(message: pleaseEnterValidEmail.tr());
      return false;
    }
    return true;
  }

  String ensurePlusPrefix(String input) {
    if (!input.startsWith('+')) {
      return '+$input';
    }
    return input;
  }

  Future<void> loginAPI(
    String email,
    BuildContext context,
    String? phone,
  ) async {
    if (isValidLogin(email)) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['email'] = email;
      if (phone != null) {
        data['phone'] = phone;
      }

      emit(LoginLoadingState());

      final response = await DioHelper.postData(
        url: RestConstants.searchAccount,
        data: data,
      );

      if ((response.statusCode ?? 0) == 200) {
        String action = response.data["data"]["action"];
        String message = response.data["data"]["message"] ?? "";
        UserModel userModel = UserModel.fromJson(
          response.data["data"]?['user'] ?? {},
        );

        if (action == "existing_user" || action == "new_user_created") {
          bool isVerified = userModel.isVerified ?? false;

          if (isVerified) {
            bool? result = await showDialog(
              context: context,
              builder:
                  (builder) => ChooseOtpMethodScreen(
                    mobile: userModel.phone ?? "",
                    email: userModel.email ?? "",
                    sendOtp: (value) async {
                      bool isSent = await sendOTP(
                        email: userModel.email ?? "",
                        phone: userModel.phone ?? "",
                        isEmail: value,
                      );
                      if (isSent) {
                        bool? result = await showDialog(
                          context: context,
                          builder:
                              (builder) => OtpVerifyScreen(
                                isEmail: value,
                                phoneNumber: userModel.phone,
                                email: email,
                                verifyTapped: (otp) async {
                                  bool result = await verifyOTPNew(
                                    otp,
                                    userModel.phone ?? "",
                                    userModel.email ?? "",
                                    value,
                                  );
                                  return result;
                                },

                                resendTapped: () async {
                                  return await reSendOTP(
                                    email: email,
                                    phone: userModel.phone,
                                    isEmail: value,
                                  );
                                },
                              ),
                        );

                        return (result ?? false);
                      }

                      return false;
                    },
                  ),
            );

            if (result ?? false) {
              emit(LoginSuccessState());
            }
          } else {
            bool? result = await showDialog(
              context: context,
              builder:
                  (builder) => OtpVerifyScreen(
                    isEmail: false,
                    phoneNumber: userModel.phone,
                    email: email,
                    verifyTapped: (otp) async {
                      bool result = await verifyOTPNew(
                        otp,
                        userModel.phone ?? "",
                        userModel.email ?? "",
                        false,
                      );
                      return result;
                    },
                    resendTapped: () async {
                      return await reSendOTP(
                        email: userModel.email,
                        phone: userModel.phone,
                        isEmail: false,
                      );
                    },
                  ),
            );

            if (result ?? false) {
              emit(LoginSuccessState());
            }
          }
        } else if (action == "user_not_found") {
          await showDialog(
            context: context,
            builder:
                (builder) => AddPhoneNumber(
                  onSubmit: (dialCode, phoneNumber) async {
                    await loginAPI(email, context, "$dialCode$phoneNumber");
                    return true;
                  },
                ),
          );
        }
      } else {
        emit(LoginErrorState(response.data["message"]));
      }
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId:
            Platform.isAndroid
                ? null
                : "819281876920-qua0q2b4umvh95uqechon126968tg6cb.apps.googleusercontent.com",
        serverClientId:
            "819281876920-g91r7mabjsssp81l1o3lgo4gjv0jqpth.apps.googleusercontent.com",
      );

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign in canceled by user');
        return;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        print('Google Id Token : ${googleAuth.idToken}');
        print('Google Access Token : ${googleAuth.accessToken}');

        await DioHelper.postData(
              url: RestConstants.googleLoginUrl,
              data: {'idToken': googleAuth.idToken},
              isHeader: false,
            )
            .then((value) async {
              print("Search account response: ${value.data}");
              if ((value.statusCode ?? 0) == 200) {
                Map data = value.data["data"];
                if (data.isNotEmpty) {
                  UserModel user = UserModel.fromJson(data["user"]);

                  String accessToken = data["accessToken"];

                  if (user.phone == null) {
                    showSuccess(
                      message:
                          "Success! Please add your phone number to proceed.",
                    );

                    String? phoneNumber;

                    bool result =
                        await showDialog(
                          context: context,
                          builder:
                              (builder) => AddPhoneNumber(
                                onSubmit: (dialCode, number) async {
                                  phoneNumber = "$dialCode$number";
                                  return await addPhoneNumber(
                                    phoneNumber ?? "",
                                    accessToken,
                                  );
                                },
                              ),
                        ) ??
                        false;

                    if (result) {
                      await showDialog(
                        context: context,
                        builder:
                            (builder) => OtpVerifyScreen(
                              isEmail: false,
                              phoneNumber: phoneNumber,
                              email: user.email ?? "",
                              verifyTapped: (otp) async {
                                bool result = await verifyPhoneNumberOTP(
                                  otp,
                                  phoneNumber ?? "",
                                  user.email ?? "",
                                );
                                return result;
                              },

                              resendTapped: () async {
                                return await reSendOTP(
                                  email: user.email,
                                  phone: phoneNumber,
                                  isEmail: false,
                                );
                              },
                            ),
                      );
                    } else {
                      googleSignIn.signOut();
                    }
                  } else {
                    // if (!isMobileVerified) {
                    //   showSuccess(
                    //     message: "Account found! Please verify your identity.",
                    //   );
                    //   await showDialog(
                    //     context: context,
                    //     builder:
                    //         (builder) => OtpVerifyScreen(
                    //           isEmail: false,
                    //           phoneNumber: user.phone ?? "",
                    //           email: user.email ?? "",
                    //           verifyTapped: (otp) async {
                    //             bool result = await verifyPhoneNumberOTP(
                    //               otp,
                    //               user.phone ?? "",
                    //               user.email ?? "",
                    //             );
                    //             return result;
                    //           },
                    //           resendTapped: () async {
                    //             return await reSendOTP(
                    //               email: user.email,
                    //               phone: user.phone,
                    //               isEmail: false,
                    //             );
                    //           },
                    //         ),
                    //   );
                    // } else {
                    showSuccess(
                      message: "Signed in successfully! Welcome back.",
                    );
                    LoggedInUserModel loginResponse =
                        LoggedInUserModel.fromJson(value.data["data"]);

                    await SharedPreferenceUtil.saveUserData(
                      userData: loginResponse,
                    );
                    emit(LoginSuccessState());
                    // }
                  }
                } else {
                  showSuccess(message: "Please create account to continue");
                  emit(LoginNewAccountState());
                }
              } else {
                emit(LoginErrorState(value.data["message"]));
              }
            })
            .catchError((error) {
              emit(LoginErrorState(extractErrorMessage(error)));
            });
      }
    } catch (e, s) {
      print("Error: $e");
      print("Stack trace: $s");
    }
  }

  Future<bool> addPhoneNumber(String phoneNumber, String token) async {
    final Map<String, dynamic> data = {"phone": phoneNumber, "token": token};

    try {
      final response = await DioHelper.postData(
        url: RestConstants.addPhoneNumberAfterGoogleSignup,
        data: data,
      );
      if ((response.statusCode ?? 0) == 200) {
        return true;
      } else {
        emit(LoginErrorState(response.data["message"]));
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  //Verify Add Phone Number OTP
  Future<bool> verifyPhoneNumberOTP(
    String otp,
    String phone,
    String email,
  ) async {
    final Map<String, dynamic> data = {
      "phone": phone,
      "otp": otp,
      "email": email,
      "type": "sms",
    };

    emit(LoginLoadingState());

    try {
      final response = await DioHelper.postData(
        url: RestConstants.verifyAddPhoneNumberOTP,
        data: data,
      );
      if ((response.statusCode ?? 0) == 200) {
        showSuccess(message: "${response.data["message"]}");

        LoggedInUserModel loginResponse = LoggedInUserModel.fromJson(
          response.data["data"],
        );

        await SharedPreferenceUtil.saveUserData(userData: loginResponse);
        emit(LoginSuccessState());
        return true;
      } else {
        emit(LoginErrorState(response.data["message"]));
        return false;
      }
    } catch (error) {
      showError(message: extractErrorMessage(error));
      return false;
    }
  }

  Future<bool> verifyOTPNew(
    String otp,
    String phone,
    String email,
    bool isEmail,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{
      "phone": phone,
      "otp": otp,
      "email": email,
    };

    try {
      final response = await DioHelper.postData(
        url:
            isEmail ? RestConstants.verifyEmailOTP : RestConstants.verifySMSOTP,
        data: data,
      );
      if ((response.statusCode ?? 0) == 200) {
        showSuccess(message: "${response.data["message"]}");
        LoggedInUserModel loginResponse = LoggedInUserModel.fromJson(
          response.data["data"],
        );
        SharedPreferenceUtil.saveUserData(userData: loginResponse);
        return true;
      } else {
        emit(LoginErrorState(response.data["message"]));
        return false;
      }
    } catch (error) {
      emit(LoginErrorState(extractErrorMessage(error)));
      showError(message: extractErrorMessage(error));
    }
    return false;
  }

  Future<bool> sendOTP({
    String? email,
    String? phone,
    required bool isEmail,
  }) async {
    final Map<String, dynamic> data = {"email": email, "phone": phone};

    try {
      final response = await DioHelper.postData(
        url: isEmail ? RestConstants.sendEmailOTP : RestConstants.sendSMSOTP,
        data: data,
      );
      if ((response.statusCode ?? 0) == 200) {
        showSuccess(message: "${response.data["message"]}");

        return true;
      } else {
        emit(LoginErrorState(response.data["message"]));
        return false;
      }
    } catch (e) {
      emit(LoginErrorState(extractErrorMessage(e)));
      return false;
    }
  }

  Future<bool> reSendOTP({
    String? email,
    String? phone,
    required bool isEmail,
  }) async {
    final Map<String, dynamic> data = {"email": email, "phone": phone};

    try {
      final response = await DioHelper.postData(
        url:
            isEmail ? RestConstants.reSendEmailOTP : RestConstants.reSendSMSOTP,
        data: data,
      );
      if ((response.statusCode ?? 0) == 200) {
        showSuccess(message: "${response.data["message"]}");

        return true;
      } else {
        emit(LoginErrorState(response.data["message"]));
        return false;
      }
    } catch (e) {
      emit(LoginErrorState(extractErrorMessage(e)));
      return false;
    }
  }
}
