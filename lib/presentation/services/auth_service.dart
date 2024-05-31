import 'dart:convert';
import 'package:firfir_tera/models/User.dart';
import 'package:firfir_tera/models/auth_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService  {
  final String baseUrl ="https://0a8b-213-55-95-236.ngrok-free.app";
  late SharedPreferences sharedPreferences ;
  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  AuthService();

  Future<void> login(String email, String password, BuildContext context) async {
    await initializeSharedPreferences();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 300));
      if (response.statusCode == 201) {
        final responseJson = json.decode(response.body);
        saveUserToSharedPreferences(responseJson['token'], responseJson['role'][0], responseJson['id']);
        context.go('/home');
        
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );
    }
  }

  Future<void> saveUserToSharedPreferences(String token, String role, String userId) async {
    await initializeSharedPreferences();
    
    await sharedPreferences.setString('token', token);
    await sharedPreferences.setString('role', role);
    await sharedPreferences.setString('userId', userId);
    print('saved');
  }
  

  Future registerUser(Map<String, String> data,  String? filePath,BuildContext context) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/signup'));
    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
    }
    request.fields.addAll(data);
    final response = await request.send();
    if (response.statusCode == 201){
        final responseBody = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseBody);  
        saveUserToSharedPreferences(responseJson['token'], responseJson['role'][0], responseJson['id']);
        context.go('/home');
    }
    else{
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.statusCode.toString())),
      );
    }
  }

  Future<Map<String, dynamic>> getUser(String userId) async {   
    print("jere with" + userId); 
  await initializeSharedPreferences();
  final response = await http.get(
    Uri.parse('$baseUrl/user/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
    },
  ).timeout(const Duration(seconds: 300));

  if (response.statusCode == 200) {
    final jsond = jsonDecode(response.body);
    return jsond;
  } else {
    throw Exception('Failed to load user');
  }
}


Future editUser(String? id) async {
    await initializeSharedPreferences();

  return http.patch(
    Uri.parse('$baseUrl/user/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
    },
    body: jsonEncode(json),
  );
}

Future deleteUser(String? id, BuildContext context) async {
    await initializeSharedPreferences();
    
    http.delete(
      Uri.parse('$baseUrl/user/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.getString('token')}',
      },
    );
    sharedPreferences.clear();
    // ignore: use_build_context_synchronously
    context.go('/register_1 ');

    return ;

}

}


