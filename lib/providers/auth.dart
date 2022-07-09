import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nicov1/helper/http_post.dart';
import 'package:nicov1/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../configs/connection_api.dart';

class Auth with ChangeNotifier {
  String? _token, _email, _name, _jabatan, _keterangan, _area;
  DateTime? _expireDate;
  Timer? _authTimer;
  bool? _disclaimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get email {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _email!;
    }
    return null;
  }

  String? get name {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _name != null) {
      return _name!;
    }
    return null;
  }

  String? get jabatan {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _jabatan != null) {
      return _jabatan!;
    }
    return null;
  }

  String? get area {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _area;
    }
    return null;
  }

  bool? get disclaimer {
    return _disclaimer;
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData') ?? "") as Map<String?, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiry']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];
    _email = extractedData['email'];
    _name = extractedData['nama'];
    _jabatan = extractedData['jabatan'];
    _keterangan = extractedData['keterangan'];
    _area = extractedData['area'];
    _expireDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> disclaimerOff() async {
    _disclaimer = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _email = null;
    _name = null;
    _jabatan = null;
    _keterangan = null;
    _area = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> _authenticate(String email, String password) async {
    try {
      final body = json.encode({
        "email": email,
        "password": password,
      });
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse(ConnectionApi.baseUrl('user/login'));
      final connection = await http.post(
        url,
        body: body,
        headers: headers,
      );
      final response = json.decode(connection.body);
      if (response['email'] == null) {
        throw HttpException(response['message']);
      }
      _token = response['token'];
      _email = response['email'];
      _name = response['name'];
      _jabatan = response['jabatan'];
      _keterangan = response['keterangan'];
      _area = response['area'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: response['expires'],
        ),
      );
      _disclaimer = true;

      _autoLogout();
      notifyListeners();

      final sp = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'email': _email,
        'nama': _name,
        'jabatan': _jabatan,
        'keterangan': _keterangan,
        'area': _area,
        'expiry': _expireDate?.toIso8601String(),
      });
      sp.setString('userData', userdata);
      sp.setBool('disclaimer', _disclaimer!);
    } catch (error) {
      throw (error);
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
