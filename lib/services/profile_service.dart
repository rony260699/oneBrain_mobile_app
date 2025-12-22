import 'dart:convert';

import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/models/chat_statistics.dart';
import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:OneBrain/screens/authentication/login/login_screen.dart';
import 'package:OneBrain/models/plan_user_model.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/utils/shared_preference_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home/cubit/home_screen_cubit.dart';

SharedPreferences? prefs;

Future<void> initPrefs() async {
  prefs ??= await SharedPreferences.getInstance();
}

class ProfileService {
  static UserModel? _currentUser;

  static String? get phone => _currentUser?.phone;

  static UserModel? get user => _currentUser ?? getUserFromPrefs();

  static bool get canUseNeoModel {
    final bool isDailyCapHit = prefs?.getBool("isDailyCapHit") ?? false;

    final is299Plan = ProfileService.user?.package?.currentPlan?.price == 299;

    if (isDailyCapHit && is299Plan) {
      return true;
    }

    return false;
  }

  static bool isPlanChanged = false;

  static Future<void> getCurrentUser() async {
    try {
      // Return sample user data for UI testing
      final value = await DioHelper.getData(
        url: RestConstants.getCurrentUser,
        isHeader: true,
      );

      if ((value.statusCode ?? 0) == 200 || (value.statusCode ?? 0) == 201) {
        if (value.data["data"] != null) {
          UserModel newUser = UserModel.fromJson(value.data["data"]);
          print("Fetched user data: ${newUser.toJson()}");
          //check with existing user if new user currentplan proice changed then chanhe defaul model otherwise not
          int? previousActivePlanPrice = user?.package?.currentPlan?.price;
          int? newActivePlanPrice = newUser.package?.currentPlan?.price;

          // int? previousAvailableTokens = _currentUser?.tokenCounter?.availableTokens;
          int newAvailableTokens = newUser.tokenCounter?.availableTokens ?? 0;

          _currentUser = newUser;

          if (previousActivePlanPrice != newActivePlanPrice &&
              newActivePlanPrice != null) {
            isPlanChanged = true;

            AIModelService.setDefaultModelByPrice();
          } else {
            isPlanChanged = false;
          }

          if (newAvailableTokens <= 0) {
            AIModelService.getDefaultModelsAfterTokenComplete();
          }

          prefs?.setString("user", jsonEncode(_currentUser?.toJson()));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
  }

  static ChatStatistics? chatStatistics;
  static bool isDailyCapHit = false;

  static Future<void> getChatStatistics() async {
    final value = await DioHelper.getData(
      url:
          "${RestConstants.chatStatistics}?timezoneOffset=${getFormattedTimezoneOffset()}",
      isHeader: true,
    );

    if ((value.statusCode ?? 0) == 201 || (value.statusCode ?? 0) == 200) {
      if (value.data["data"] is Map) {
        chatStatistics = ChatStatistics.fromJson(value.data["data"]);

        if ((chatStatistics?.user?.package?.currentPlan?.price ?? 0) > 0) {
          final bool localIsDailyCapHit =
              prefs?.getBool("isDailyCapHit") ?? false;
          final bool remoteIsDailyCapHit = chatStatistics?.dailyCapHit ?? false;

          prefs?.setBool("isLockedPremiumModel", remoteIsDailyCapHit);

          if (localIsDailyCapHit != remoteIsDailyCapHit) {
            prefs?.setBool("isDailyCapHit", remoteIsDailyCapHit);
          }

          if (localIsDailyCapHit && !remoteIsDailyCapHit) {
            String? lastActiveAIModel = prefs?.getString("lastActiveAIModel");

            if (lastActiveAIModel != null) {
              AIModel? model = AIModelService.allAIModels?.firstWhereOrNull(
                (model) => model.model == lastActiveAIModel,
              );

              AIModelService.setDefaultModel(model);
            }
          }

          if (!localIsDailyCapHit && remoteIsDailyCapHit) {
            prefs?.setString(
              "lastActiveAIModel",
              AIModelService.defaultModelName ?? "",
            );
            AIModelService.setDefaultModelByPrice();
          }
          if (!remoteIsDailyCapHit) {
            isDailyCapHit = false;
          }
          if (isPlanChanged) {
            AIModelService.setDefaultModelByPrice();

            isPlanChanged = false;
          }
        } else {
          isDailyCapHit = chatStatistics?.dailyCapHit ?? false;
        }
      }
    }
  }

  static UserModel? getUserFromPrefs() {
    final String? user = prefs?.getString("user");
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    }
    return null;
  }

  // Update user profile - SIMULATED
  static Future<bool> updateProfile(String? phone) async {
    final value = await DioHelper.putData(
      url: RestConstants.updateProfile,
      data: {'phone': phone},
    );

    if ((value.statusCode ?? 0) == 200 || (value.statusCode ?? 0) == 201) {
      if (value.data["data"] != null) {
        _currentUser = UserModel.fromJson(value.data["data"]);
        return true;
      }
    }
    return false;
    // return _currentUser;
    // Simulate API delay
    // await Future.delayed(const Duration(seconds: 2));

    // Get current user data and update it
    // final currentUser = await getCurrentUser();

    // if (currentUser == null) {
    //   return UserModel();
    // }

    // Return updated user data
    // return UserModel.fromJson({
    //   '_id': currentUser.id,
    //   'name': name ?? currentUser.name,
    //   'email': currentUser.email,
    //   'phone': phone ?? currentUser.phone,
    //   'profile_image': currentUser.profileImage,
    //   'package': currentUser.package?.toJson(),
    //   'createdAt': currentUser.createdAt?.toIso8601String(),
    //   'updatedAt': DateTime.now().toIso8601String(),
    // });
  }

  // Upload profile image - SIMULATED
  static Future<bool?> updateProfileImage(XFile imageFile) async {
    // Simulate upload delay
    // await Future.delayed(const Duration(seconds: 3));

    final value = await DioHelper.putData(
      url: RestConstants.updateProfileImage,
      data: {'profileImage': imageFile},
      isFormData: true,
    );
    // Get current user data
    // final currentUser = await getCurrentUser();

    if (value.statusCode == 200 || value.statusCode == 201) {
      if (value.data["data"] != null) {
        _currentUser = UserModel.fromJson(value.data["data"]);
        return true;
      }
    }
    return false;

    // if (currentUser == null) {
    //   return UserModel();
    // }

    // Simulate successful upload with new image URL
    // return UserModel.fromJson({
    //   '_id': currentUser.id,
    //   'name': currentUser.name,
    //   'email': currentUser.email,
    //   'phone': currentUser.phone,
    //   'profile_image':
    //       'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
    //   'package': currentUser.package?.toJson(),
    //   'createdAt': currentUser.createdAt?.toIso8601String(),
    //   'updatedAt': DateTime.now().toIso8601String(),
    // });
  }

  static Future<bool> deleteAccount(BuildContext context) async {
    final value = await DioHelper.deleteData(url: RestConstants.deleteAccount);
    if (value.statusCode == 200 || value.statusCode == 201) {
      // if (value.data["data"] != null) {
      // SharedPreferenceUtil.clear();
      // _currentUser = UserModel.fromJson(value.data["data"]);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value.data["message"]),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await Future.delayed(const Duration(microseconds: 250));

      Navigator.pop(context);
      await SharedPreferenceUtil.clear();
      await GoogleSignIn().signOut();
      final homeCubit = HomeScreenCubit.get(context);
      homeCubit.clearCubit();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      return true;
      // }
    }
    return false;
  }

  static Future<void> logOut(BuildContext context) async {
    showCupertinoDialogBox(
      context,
      "Are you sure want to logout?",
      isShowCancel: true,
      okText: "Yes",
      (context) async {
        Navigator.pop(context);
        await SharedPreferenceUtil.clear();
        await prefs?.clear();
        _currentUser = null;
        chatStatistics = null;
        await GoogleSignIn().signOut();
        final homeCubit = HomeScreenCubit.get(context);
        homeCubit.clearCubit();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
      cancelText: "No",
    );
  }
}
