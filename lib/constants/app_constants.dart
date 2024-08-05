class AppConstants {
  static const String appName = 'JamiiPass';
  static const double appVersion = 1.0;

  // Shared Preference Key
  static const String token = 'token';
  static const String user = 'user';
  static const String userAccount = 'userAccount';
  static const String isLogin = 'is_login';
  static const String isNotFirstLogin = 'is_not_firstLogin';
  static const String language = 'lang';
  static const String isFirstTime = 'isFirstTime';

  // API URLS
  static const String apiBaseUrl = 'http://192.168.37.123:8000/';
  static const String mediaBaseUrl = 'http://192.168.37.123:800192.168.37.1230';
  static const String nidaBaseUrl = 'http://192.168.37.123:5000/api/nida_info';
  static const String verifyPhoneUrl = 'user-management/register';
  static const String apiUserLogin = 'http://192.168.37.123:8000/api/auth/login';
  static const String apiUserRegistration =
      'http://192.168.37.123:8000/api/auth/register';
  static const String apiUserVerifyOtp =
      'http://192.168.37.123:8000/app/citizen/auth/verify_user_otp';
  static const String allEvents = 'api/events';
  static const String tickets = 'api/tickets';
  static const String comments = 'api/comments';
  static const String followers = 'api/follows';
  static const String notifications = 'api/notifications';
  static const String allUsers = 'api/auth/user-information';
}
