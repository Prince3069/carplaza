class AppConstants {
  static const String appName = 'Car Plaza';
  static const String appTagline = 'Your trusted car marketplace in Nigeria';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String carsCollection = 'cars';
  static const String messagesCollection = 'messages';
  static const String paymentsCollection = 'payments';

  // Storage paths
  static const String carImagesPath = 'car_images';
  static const String profileImagesPath = 'profile_images';

  // Commission rate (5%)
  static const double commissionRate = 0.05;

  // Default locations in Nigeria
  static const List<String> nigerianStates = [
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
    'FCT',
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

  // Car brands popular in Nigeria
  static const List<String> popularBrands = [
    'Toyota',
    'Honda',
    'Mercedes',
    'BMW',
    'Lexus',
    'Ford',
    'Nissan',
    'Mitsubishi',
    'Hyundai',
    'Kia',
    'Peugeot',
    'Volkswagen',
    'Audi',
    'Land Rover',
    'Jeep',
    'Chevrolet',
    'Mazda',
    'Volvo',
    'Porsche',
    'Jaguar'
  ];
}
