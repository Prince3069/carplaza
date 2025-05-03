// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:car_plaza/models/payment_model.dart';
// import 'package:car_plaza/utils/constants.dart';

// class PaymentService {
//   final FirebaseFunctions _functions = FirebaseFunctions.instance;

//   Future<PaymentResult> initiateEscrowPayment({
//     required String carId,
//     required String buyerId,
//     required String sellerId,
//     required double amount,
//   }) async {
//     try {
//       final callable = _functions.httpsCallable('initiateEscrowPayment');
//       final result = await callable.call({
//         'carId': carId,
//         'buyerId': buyerId,
//         'sellerId': sellerId,
//         'amount': amount,
//         'commissionRate': AppConstants.commissionRate,
//       });

//       return PaymentResult(
//         success: true,
//         paymentId: result.data['paymentId'],
//         message: 'Payment initiated successfully',
//       );
//     } catch (e) {
//       return PaymentResult(
//         success: false,
//         message: 'Payment failed: ${e.toString()}',
//       );
//     }
//   }

//   Future<PaymentResult> confirmDelivery(String paymentId) async {
//     try {
//       final callable = _functions.httpsCallable('confirmDelivery');
//       await callable.call({'paymentId': paymentId});
//       return PaymentResult(success: true, message: 'Delivery confirmed');
//     } catch (e) {
//       return PaymentResult(
//         success: false,
//         message: 'Confirmation failed: ${e.toString()}',
//       );
//     }
//   }

//   Future<PaymentResult> cancelPayment(String paymentId) async {
//     try {
//       final callable = _functions.httpsCallable('cancelPayment');
//       await callable.call({'paymentId': paymentId});
//       return PaymentResult(success: true, message: 'Payment cancelled');
//     } catch (e) {
//       return PaymentResult(
//         success: false,
//         message: 'Cancellation failed: ${e.toString()}',
//       );
//     }
//   }
// }

// class PaymentResult {
//   final bool success;
//   final String? paymentId;
//   final String message;

//   PaymentResult({
//     required this.success,
//     this.paymentId,
//     required this.message,
//   });
// }
