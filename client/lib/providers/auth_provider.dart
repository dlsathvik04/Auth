import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _authStatus = false;
  String _currentPhone = "";
  String _authToken = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AuthProvider() {
    fetchSharedPrefs();
  }

  void setAuthStatus(bool auth) {
    _authStatus = auth;
    notifyListeners();
  }

  bool get authStatus {
    return _authStatus;
  }

  Future<void> setSharedPrefs() async {
    final prefs = await _prefs;
    prefs.setBool('authStatus', _authStatus);
    prefs.setString('authToken', _authToken);
    prefs.setString('currentPhone', _currentPhone);
  }

  Future<void> fetchSharedPrefs() async {
    final prefs = await _prefs;
    _authStatus = prefs.getBool('authStatus') ?? false;
    _authToken = prefs.getString('authToken') ?? "";
    _currentPhone = prefs.getString('authToken') ?? "";
    notifyListeners();
  }

  Future<void> logOut() async {
    _authStatus = false;
    _currentPhone = "";
    _authToken = "";
    await setSharedPrefs();
    notifyListeners();
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    final body = jsonEncode(<String, String>{
      'password': password,
      'phoneNumber': phoneNumber,
    });
    final header = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse('http://10.0.2.2:8000/users/login');

    try {
      var res = await http.post(url, body: body, headers: header).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception("Cant reach server");
        },
      );
      if (res.statusCode == 200) {
        _authToken = json.decode(res.body)["authToken"];
        _authStatus = true;
        _currentPhone = phoneNumber;
        await setSharedPrefs();
        // print(_authToken);
        // print("login called");
        notifyListeners();
      } else {
        // print(res.body);
        throw Exception(res.body);
      }
    } catch (err) {
      rethrow;
      // print(err);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String password,
    required String houseNo,
    required String streetName,
    required String pinCode,
    required String phoneNumber,
    required String email,
  }) async {
    final body = jsonEncode(<String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'houseNo': houseNo,
      'streetName': streetName,
      'pinCode': pinCode,
      'phoneNumber': phoneNumber,
      'email': email,
    });
    final header = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse('http://10.0.2.2:8000/users/register');
    try {
      var res = await http.post(url, body: body, headers: header).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception("Cant reach server");
        },
      );
      if (res.statusCode == 200) {
        _authToken = json.decode(res.body)["authToken"];
        _authStatus = true;
        _currentPhone = phoneNumber;
        await setSharedPrefs();
        notifyListeners();
      } else {
        throw Exception(res.body);
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> sendOTP({required String phoneNumber}) async {
    final body = jsonEncode(<String, String>{
      'phoneNumber': phoneNumber,
    });
    final header = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse('http://10.0.2.2:8000/users/forgotPassword');

    try {
      var res = await http.post(url, body: body, headers: header).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception("Cant reach server");
        },
      );
      if (res.statusCode == 200) {
        _currentPhone = phoneNumber;
        await setSharedPrefs();
        // print(_authToken);
        // print("login called");
      } else {
        // print(res.body);
        throw Exception(res.body);
      }
    } catch (err) {
      rethrow;
      // print(err);
    }
  }

  Future<void> changePassword({
    required String otp,
    required String newPassword,
  }) async {
    final body = jsonEncode(<String, String>{
      'phoneNumber': _currentPhone,
      'otp': otp,
      'newPassword': newPassword,
    });
    final header = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse('http://10.0.2.2:8000/users/changePassword');

    try {
      var res = await http.post(url, body: body, headers: header).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception("Cant reach server");
        },
      );
      if (res.statusCode == 200) {
        _authStatus = false;
        notifyListeners();
      } else {
        throw Exception(res.body);
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> dummyLogin() async {
    _authStatus = true;
    _authToken = "nope";
    _currentPhone = "123456789";
    await setSharedPrefs();
    notifyListeners();
  }

  // Future<void> dummyLogout() async {
  //   _authStatus = false;
  //   _authToken = "";
  //   _currentPhone = "123456789";
  //   await setSharedPrefs();
  //   notifyListeners();
  // }
}
