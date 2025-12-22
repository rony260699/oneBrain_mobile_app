import 'package:OneBrain/screens/payment_billing/cubit/payment_cubit.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/notification_service.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'controllers/profile_menu_controller.dart';
import 'screens/authentication/login/cubit/login_cubit.dart';
import 'screens/home/cubit/home_screen_cubit.dart';
import 'utils/app_constants.dart';
import 'utils/shared_preference_util.dart';
import 'firebase_options.dart';
import 'resources/color.dart';
import 'repo_api/dio_helper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:country_codes/country_codes.dart';
import 'screens/main_app_wrapper.dart';
import 'screens/side_menu/model/ai_list_model.dart';

// List<AiModelListing> arrOfAiModelListing = [];
List<AiTool> arrOfAiTools = []; // List of available AI tools
// List<AiTool> activeAiTools = []; // Currently active AI tools (max 3)
AiModelListing currentAIModel = AiModelListing();
// ChatSubModel currentChatModelSelected = ChatSubModel.fromJson({});
AiModelListing currentModelSelected = AiModelListing();
bool isMessageRunning = false;

// AI Tool Integration Variables
AiTool? currentActiveTool; // Currently active AI tool
String currentToolMode = "chat"; // "chat" or "tool"

// Explore page state
bool isConversationalMode = true; // true = Conversational AI, false = AI Tools
String selectedToolCategory = "All"; // Filter for AI tools

/// Proactively request permission status to make permissions appear in iOS Settings
Future<void> _initializePermissions() async {
  if (Platform.isIOS) {
    try {
      // Check camera permission status (this will make it appear in iOS Settings)
      await Permission.camera.status;

      // Check photo library permission status
      await Permission.photos.status;

      // Check microphone permission status
      await Permission.microphone.status;

      print(
        "📱 iOS permissions initialized - they should now appear in Settings",
      );
    } catch (e) {
      print("📱 Error initializing permissions: $e");
    }
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchro   nous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize permissions proactively for iOS
  await _initializePermissions();

  await NotificationService.init();

  // Set preferred orientations for better UX
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Remove the native splash screen
  FlutterNativeSplash.remove();

  // Configure system UI overlay style but keep original edge-to-edge mode
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Keep original edge-to-edge mode and rely on SafeArea for proper spacing
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await initializeDateFormatting('en_US');
  await EasyLocalization.ensureInitialized();
  await CountryCodes.init();
  await ScreenUtil.ensureScreenSize();
  // await SharedPreferenceUtil.getInstance();
  try {
    await SharedPreferenceUtil.getInstance();
    // runApp(MyApp(prefs: prefs));
  } catch (e, stack) {
    print('Error initializing SharedPreferences: $e\n$stack');
  }
  await DioHelper.init();
  await initPrefs();
  await AIModelService.init();

  // Initialize GetX controllers
  Get.put(ProfileMenuController());

  EasyLocalization.logger.enableLevels = [];

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider<HomeScreenCubit>(
          create: (BuildContext context) => HomeScreenCubit(),
        ),
        BlocProvider<PaymentCubit>(
          create: (BuildContext context) => PaymentCubit(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale(strLocaleEn, ''),
          Locale(strLocaleAr, ''),
        ],
        startLocale: Locale(strLocaleEn, ''),
        saveLocale: true,
        path: 'assets/translations',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final Smartlook smartlook = Smartlook.instance;

  @override
  void initState() {
    super.initState();
    startSmartlook();
  }

  startSmartlook() async {
    await smartlook.preferences.setProjectKey(
      '2569b419fa96923f22a5f94427ac3ac0bf441998',
    );
    Smartlook.instance.sensitivity.changeWidgetClassSensitivity(
      classType: TextField,
      isSensitive: false,
    );
    Smartlook.instance.sensitivity.changeWidgetClassSensitivity(
      classType: TextFormField,
      isSensitive: false,
    );
    await smartlook.start();
  }

  @override
  Widget build(BuildContext context) {
    return SmartlookRecordingWidget(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        // iPhone 14 Pro design size
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        // Performance optimization
        builder:
            (BuildContext context, Widget? child) => GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: MaterialApp(
                title: 'Onebrain',
                navigatorKey: rootNavigatorKey,
                debugShowCheckedModeBanner: false,
                showPerformanceOverlay: false,
                checkerboardRasterCacheImages: false,
                checkerboardOffscreenLayers: false,
                showSemanticsDebugger: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android:
                          FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    },
                  ),
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: colorPrimary,
                  ),
                  useMaterial3: true,
                  brightness: Brightness.light,
                  fontFamily: '.SF Pro Text',
                  // iOS system font
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                darkTheme: ThemeData(
                  primarySwatch: Colors.indigo,
                  primaryColor: const Color(0xFF6366F1),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF6366F1),
                    brightness: Brightness.dark,
                    background: const Color(0xFF0A0E24),
                    surface: const Color(0xFF1E2139),
                  ),
                  inputDecorationTheme: InputDecorationTheme(isDense: true),
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: colorPrimary,
                  ),
                  // Force dark keyboard appearance globally
                  extensions: <ThemeExtension<dynamic>>[],
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android:
                          FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    },
                  ),
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  fontFamily: '.SF Pro Text',
                  // iOS system font
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                themeMode: ThemeMode.dark,
                // home: SharedPreferenceUtil.getBool(isLoginKey) == true ? MainAppWrapper() : LoginScreen(),
                home: MainAppWrapper(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(
                        1.0,
                      ), // Prevent system text scaling
                    ),
                    child: child!,
                  );
                },
              ),
            ),
      ),
    );
  }
}
