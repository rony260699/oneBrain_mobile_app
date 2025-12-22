import 'dart:async';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/resources/color.dart';
import 'package:OneBrain/screens/payment_billing/payment_api.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String gatewayPageURL;
  final String tranId;

  const PaymentWebViewPage({
    super.key,
    required this.gatewayPageURL,
    required this.tranId,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  Timer? _pollTimer;
  final Duration pollInterval = const Duration(seconds: 3);
  final Duration maxWait = const Duration(minutes: 5);
  late final DateTime deadline;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    deadline = DateTime.now().add(maxWait);

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                print("onPageFinished");
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.gatewayPageURL));

    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(pollInterval, (timer) async {
      try {
        final statusData = await PaymentApi.getPaymentStatus(widget.tranId);

        final status = (statusData['status'] as String?) ?? 'PENDING';

        if (status == 'COMPLETED') {
          if (mounted) {
            Navigator.of(
              context,
            ).pop({'status': 'COMPLETED', 'data': statusData});
          }
          return;
        }

        if (DateTime.now().isAfter(deadline)) {
          if (mounted) {
            Navigator.of(
              context,
            ).pop({'status': status, 'data': statusData, 'timeout': true});
          }
          return;
        }

        if (status == 'NOT_FOUND') {
          if (mounted) {
            Navigator.of(context).pop({'status': status, 'data': statusData});
          }
          return;
        }

        // if (mounted) {
        //   Navigator.of(context).pop({'status': status, 'data': statusData});
        // }
        // return;
      } catch (_) {
        // Network error: keep polling silently
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBg,
      appBar: AppBar(title: const Text('Complete Payment')),
      body: IndexedStack(
        index: _isLoading ? 1 : 0,
        children: [
          WebViewWidget(controller: _controller),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color.fromARGB(255, 20, 22, 30),
                  Color(0xFF0C1028), // Blue shade
                ],
              ),
            ),
            child: Center(child: commonLoader()),
          ),
        ],
      ),
    );
  }
}
