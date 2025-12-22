import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import '../resources/color.dart';
import '../screens/side_menu/side_menu_screen.dart';
import '../utils/shared_preference_util.dart';
import '../utils/slide_left_route.dart';
import '../utils/app_exit_service.dart';

abstract class BaseStatefulWidgetState<StateMVC extends StatefulWidget>
    extends State<StateMVC> {
  late ThemeData baseTheme;
  bool shouldHaveSafeArea = true;
  bool resizeToAvoidBottomInset = true;
  final rootScaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;
  bool isBackgroundImage = false;
  bool extendBodyBehindAppBar = false;
  Color? scaffoldBgColor;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  void didChangeDependencies() {
    baseTheme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  void pushAndClearStack(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Future.delayed(Duration(milliseconds: 200)).then(
      (value) => Navigator.of(
        context,
        rootNavigator: shouldUseRootNavigator,
      ).pushAndRemoveUntil(SlideLeftRoute(page: enterPage), (route) => false),
    );
  }

  void pushReplacement(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Future.delayed(Duration(milliseconds: 200)).then(
      (value) => Navigator.of(
        context,
        rootNavigator: shouldUseRootNavigator,
      ).pushReplacement(SlideLeftRoute(page: enterPage)),
    );
  }

  void push(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
    Function? callback,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return enterPage;
        },
      ),
    );
  }

  void clearStackAndPush(
    BuildContext context,
    String targetScreenName, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.of(context, rootNavigator: shouldUseRootNavigator).popUntil((
      route,
    ) {
      // Check if the current route is the target screen
      return route.settings.name == targetScreenName;
    });

    Navigator.of(
      context,
      rootNavigator: shouldUseRootNavigator,
    ).push(SlideLeftRoute(page: enterPage));
  }

  Future<dynamic> pushForResult(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: shouldUseRootNavigator,
    ).push(SlideLeftRoute(page: enterPage));
  }

  void goBack([val]) {
    Navigator.pop(rootScaffoldKey.currentContext!, val);
  }

  bool isRootScreen() {
    final String routeName = ModalRoute.of(context)?.settings.name ?? '';
    final Widget currentWidget = widget;

    return (currentWidget.runtimeType.toString() == 'HomeScreen' ||
            currentWidget.runtimeType.toString() == 'LoginScreen' ||
            routeName == '/' ||
            routeName == '/home' ||
            routeName == '/login') &&
        !Navigator.of(context).canPop();
  }

  void _handleBackPress(bool didPop) {
    if (didPop) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (isRootScreen()) {
      _showExitConfirmationDialog();
    }
  }

  // Show exit confirmation dialog
  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#111827'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: HexColor('#B2B8F6').withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          title: Text(
            'Exit App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to exit one_brain?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HexColor('#3b82f6'), HexColor('#06b6d4')],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppExitService.exitApp();
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = buildBody(context);
    if (shouldHaveSafeArea) {
      bodyContent = SafeArea(
        bottom: true, // This ensures content stays above navigation buttons
        child:
            !isBackgroundImage
                ? bodyContent
                : SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: bodyContent,
                ),
      );
    } else if (isBackgroundImage) {
      bodyContent = Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          // Optimized gradient for better text readability
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000), // Pure black at top for better text visibility
              Color(0xFF000000), // Keep black longer for content area
              Color(0xFF0A0E24), // Deep dark blue starts lower
              Color(0xFF0C1028), // Slightly lighter dark blue at bottom
            ],
            stops: [0.0, 0.7, 0.85, 1.0], // Push blue colors towards bottom
          ),
        ),
        child: bodyContent,
      );
    }

    // return UpgradeAlert(
    //   child: SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //   ),
    // );

    return GestureDetector(
      onTap:
          () => FocusScope.of(
            rootScaffoldKey.currentContext!,
          ).requestFocus(FocusNode()),
      child: PopScope(
        canPop:
            false, // Always handle back button press manually for consistent behavior
        onPopInvokedWithResult: (didPop, result) {
          _handleBackPress(didPop);
        },
        child: UpgradeAlert(
          showIgnore: false,
          showLater: false,
          barrierDismissible: false,
          dialogStyle:
              Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
          upgrader: Upgrader(
            debugLogging: false,
            durationUntilAlertAgain: Duration(seconds: 10),
            debugDisplayAlways: false,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            key: rootScaffoldKey,
            drawer: getAppDrawer(
              context: context,
              rootScaffoldKey: rootScaffoldKey,
            ),
            onDrawerChanged: (value) {
              if (!value) {
                setState(() {});
              }
            },
            extendBody: false,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            backgroundColor: scaffoldBgColor ?? colorWhite,
            appBar: buildAppBar(context),
            body: bodyContent,
            bottomNavigationBar: buildBottomNavigationBar(context),
            floatingActionButton: buildFloatingActionButton(context),
            floatingActionButtonLocation:
                floatingActionButtonLocation ??
                FloatingActionButtonLocation.endDocked,
          ),
        ),
      ),
    );
  }

  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  Widget buildBody(BuildContext context) {
    return widget;
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget? buildFloatingActionButton(BuildContext context) {
    return null;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Widget? getAppDrawer({
  required BuildContext context,
  required GlobalKey<ScaffoldState> rootScaffoldKey,
}) {
  return (SharedPreferenceUtil.getUserData()?.accessToken ?? "") != ""
      ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xff0E0E1A)],
                  stops: [0.8, 1],
                  // tileMode: TileMode.decal,
                ),
              ),
              child: SideMenuScreen(
                closeMenu: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  rootScaffoldKey.currentState?.closeDrawer();
                },
              ),
            ),
          ),
        ),
      )
      : null;
}
