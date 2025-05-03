// import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:car_plaza/models/payment_model.dart';
// import 'package:car_plaza/utils/constants.dart';

// class PaystackService {
//   final PaystackPlugin _paystack = PaystackPlugin();

//   Future<void> initialize() async {
//     await _paystack.initialize(
//       publicKey: 'YOUR_PAYSTACK_PUBLIC_KEY',
//     );
//   }

//   Future<PaymentResult> makePayment({
//     required String email,
//     required double amount,
//     required String reference,
//   }) async {
//     try {
//       final charge = Charge()
//         ..email = email
//         ..amount =
//             (amount * 100).toInt() // Paystack uses kobo (multiply by 100)
//         ..reference = reference
//         ..currency = 'NGN';

//       final response = await _paystack.checkout(
//         context as BuildContext,
//         method: CheckoutMethod.card,
//         charge: charge,
//       );

//       if (response.status) {
//         return PaymentResult(
//           success: true,
//           paymentId: response.reference,
//           message: 'Payment successful',
//         );
//       } else {
//         return PaymentResult(
//           success: false,
//           message: response.message ?? 'Payment failed',
//         );
//       }
//     } catch (e) {
//       return PaymentResult(
//         success: false,
//         message: 'Payment error: $e',
//       );
//     }
//   }
// }
