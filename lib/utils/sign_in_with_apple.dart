import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppleSignInService {
  static Future<AppleUser?> signInWithApple() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      debugPrint('Apple Sign-In is only available on iOS/macOS.');
      return null;
    }

    final isAvailable = await SignInWithApple.isAvailable();
    if (!isAvailable) {
      debugPrint('Apple Sign-In is not available on this device.');
      return null;
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      // Decode identity token using jwt_decoder
      final decodedToken = JwtDecoder.decode(credential.identityToken ?? "");

      final user = AppleUser(
        userIdentifier: credential.userIdentifier ?? "",
        email: credential.email ?? decodedToken['email'],
        givenName: credential.givenName ?? decodedToken['given_name'],
        familyName: credential.familyName ?? decodedToken['family_name'],
        identityToken: credential.identityToken ?? "",
        authorizationCode: credential.authorizationCode,
      );

      debugPrint('Apple Sign-In successful: ${user.userIdentifier}');
      return user;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple Sign-In error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected error during Apple Sign-In: $e');
      return null;
    }
  }
}

class AppleUser {
  final String userIdentifier;
  final String? email;
  final String? givenName;
  final String? familyName;
  final String identityToken;
  final String authorizationCode;

  AppleUser({
    required this.userIdentifier,
    this.email,
    this.givenName,
    this.familyName,
    required this.identityToken,
    required this.authorizationCode,
  });

  String get fullName {
    if (givenName != null && familyName != null) {
      return '$givenName $familyName';
    }
    return givenName ?? familyName ?? '';
  }
}
