import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/base_stateful_state.dart';
import '../common_widgets/common_appbar.dart';
import '../resources/color.dart';
import 'common_widgets.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String webUrl;
  final String title;

  const InAppWebViewScreen({
    super.key,
    required this.webUrl,
    required this.title,
  });

  @override
  InAppWebViewScreenState createState() => InAppWebViewScreenState();
}

class InAppWebViewScreenState extends BaseStatefulWidgetState<InAppWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    textZoom: 100,
  );

  @override
  bool get shouldHaveSafeArea => false;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.blue),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // TODO: implement buildAppBar
    return CommonAppBar(
      title: widget.title,
      shouldShowBackButton: true,
      backgroundColor: colorWhite,
    );
  }

  InAppWebViewController? webViewController;

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  Widget buildBody(BuildContext context) {
    return Container(
        color: colorWhite,
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          children: [
            progress < 1.0
                ? SizedBox(
                    height: screenSize.height - (MediaQuery.of(context).viewPadding.top + CommonAppBar().preferredSize.height),
                    child: Center(
                      child: commonLoader(),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: InAppWebView(
                  key: webViewKey,
                  initialSettings: settings,
                  initialUrlRequest: URLRequest(url: WebUri(widget.webUrl)),
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      urlController.text = url;
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = url;
                    });
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    if (kDebugMode) {
                      print(consoleMessage);
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
