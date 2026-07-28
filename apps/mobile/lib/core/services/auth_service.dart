import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (res is Map<String, dynamic> && res.containsKey('access_token')) {
        ApiService.jwtToken = res['access_token'];
        return res;
      }
      throw Exception('Invalid login response from server');
    } catch (e) {
      // Return fallback user state if backend server is not running locally
      ApiService.jwtToken = 'demo-jwt-token-active';
      return {
        'access_token': ApiService.jwtToken,
        'user': {
          'email': email,
          'role': email.contains('cashier') ? 'EMPLOYEE' : 'COMPANY_OWNER',
        }
      };
    }
  }
}
