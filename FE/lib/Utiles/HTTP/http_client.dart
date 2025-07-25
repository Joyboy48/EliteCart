import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import '../../Utiles/constants/api_constants.dart';

class HttpHelper {
  static const String _baseUrl = ApiConstants.baseUrl + '/users';

  static Future<http.Response> getRequest(String endpoint) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(Uri.parse('$_baseUrl$endpoint'));
    return response;
  }

  //register
  static Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String username,
      String phoneNumber,
      String email,
      String password) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  //login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  //logout
  static Future<Map<String, dynamic>> logout(String token) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // This is correct
      },
    );

    return _handleResponse(response);
  }

  //
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    return {
      'statusCode': response.statusCode,
      'body': decoded,
    };
  }

  Future<void> sendRequestWithToken(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
    } else {
      print(
          'Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return await handleAuthResponse(response);
  }

  Future<Map<String, dynamic>> updateUserProfile(
      String token, Map<String, dynamic> updatedData) async {
    final url = Uri.parse("$_baseUrl/profile");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(updatedData),
    );

    final body = jsonDecode(response.body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  Future<Map<String, dynamic>> uploadProfilePicture(
      String token, File imageFile) async {
    final url = Uri.parse("$_baseUrl/upload-avatar");

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.files
        .add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final body = jsonDecode(response.body);

      return {'statusCode': response.statusCode, 'body': body};
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'error': 'Error uploading image: $e'}
      };
    }
  }

  Future<Map<String, dynamic>> addAddress(
      String token, Map<String, dynamic> addressData) async {
    final url = Uri.parse("$_baseUrl/address");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(addressData),
    );

    final body = jsonDecode(response.body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  Future<List<Map<String, dynamic>>> getUserAddresses(String token) async {
    final url = Uri.parse("$_baseUrl/addresses");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['addresses'] != null) {
      return List<Map<String, dynamic>>.from(body['addresses']);
    } else {
      throw Exception("Failed to load addresses");
    }
  }

  Future<Map<String, dynamic>> updateAddress(
      String token, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/address/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body)
    };
  }

// Delete address by ID
  Future<Map<String, dynamic>> deleteAddress(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/address/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  static Future<Map<String, dynamic>> handleAuthResponse(
      http.Response response) async {
    // If token expired, clear and redirect
    if (response.statusCode == 401 && response.body.contains('jwt expired')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      HelperFunctions.showSnackBar('Session expired. Please log in again.');
      Get.offAll(() => loginPage());
      return {
        'statusCode': 401,
        'body': {'error': 'jwt expired'}
      };
    }
    // Otherwise, decode as usual
    final decoded = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'body': decoded,
    };
  }
}
