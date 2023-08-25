import 'package:razorpay_flutter/razorpay_flutter.dart';

RazorpayMethod(Razorpay _razorpay,int total,String description,String phone,String email){
  var options = {
    'key': 'rzp_test_864jf5OoKDSQuT',
    'amount': (total*100).toString(), //in the smallest currency sub-unit.
    'name': 'Metro Mate.',
    'currency':'INR',
    'description': '${description} Metro Ticket',
    'timeout': 120, // in seconds
    'prefill': {
      'contact': '$phone',
      'email': '${email}@gmail.com'
    },
  };
  _razorpay.open(options);
}

Events(Razorpay _razorpay,_handlePaymentSuccess,_handlePaymentError,_handleExternalWallet){
  // _razorpay = Razorpay();
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
}