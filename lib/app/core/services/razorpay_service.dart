import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();

  RazorpayService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required BuildContext context,
  }) {
    var options = {
      'key': 'rzp_test_1234567890', // Replace with your Razorpay Key
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': name,
      'description': description,
      'prefill': {'contact': '9876543210', 'email': 'example@test.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint(" Payment Successful: ${response.paymentId}");
    // TODO: Trigger success callback or event
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint(" Payment Failed: ${response.message}");
    // TODO: Trigger failure callback or event
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("ℹ External Wallet: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}
