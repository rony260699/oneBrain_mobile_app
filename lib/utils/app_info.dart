import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String? versionString;

  static Future<String> getVersionString() async {
    if (versionString != null) return versionString!;
    final info = await PackageInfo.fromPlatform();
    versionString = "V ${info.version}";
    return versionString!;
  }
}
