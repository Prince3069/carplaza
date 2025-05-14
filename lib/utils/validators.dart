// TODO Implement this library.
class Validators {
  // Required field validator
  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Price validation (Nigerian Naira)
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a price';
    }

    // Remove any commas or currency symbols
    final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

    final price = double.tryParse(cleanValue);
    if (price == null) {
      return 'Enter a valid amount';
    }

    if (price <= 0) {
      return 'Price must be greater than zero';
    }

    if (price > 1000000000) {
      // 1 billion Naira upper limit
      return 'Price seems too high';
    }

    return null;
  }

  // Year validation (1900-current year + 1)
  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a year';
    }

    final year = int.tryParse(value);
    final currentYear = DateTime.now().year;

    if (year == null) {
      return 'Enter a valid year';
    }

    if (year < 1900 || year > currentYear + 1) {
      return 'Year must be between 1900 and ${currentYear + 1}';
    }

    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Phone number validation (Nigeria specific)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a phone number';
    }

    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Nigerian phone numbers are typically 11 digits starting with 0
    if (digitsOnly.length != 11 || !digitsOnly.startsWith('0')) {
      return 'Enter a valid Nigerian phone number';
    }

    return null;
  }

  // Location validation (Nigeria specific)
  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a location';
    }

    final nigerianStates = [
      'Abia',
      'Adamawa',
      'Akwa Ibom',
      'Anambra',
      'Bauchi',
      'Bayelsa',
      'Benue',
      'Borno',
      'Cross River',
      'Delta',
      'Ebonyi',
      'Edo',
      'Ekiti',
      'Enugu',
      'Gombe',
      'Imo',
      'Jigawa',
      'Kaduna',
      'Kano',
      'Katsina',
      'Kebbi',
      'Kogi',
      'Kwara',
      'Lagos',
      'Nasarawa',
      'Niger',
      'Ogun',
      'Ondo',
      'Osun',
      'Oyo',
      'Plateau',
      'Rivers',
      'Sokoto',
      'Taraba',
      'Yobe',
      'Zamfara'
    ];

    final isState = nigerianStates
        .any((state) => value.toLowerCase().contains(state.toLowerCase()));

    if (!isState && !value.toLowerCase().contains('nigeria')) {
      return 'Please enter a Nigerian location';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }

    return null;
  }
}
