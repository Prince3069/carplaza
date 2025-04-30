// HELPER FUNCTIONS
import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, y hh:mm a').format(date);
  }

  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
