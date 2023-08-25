import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/User_model.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _items = [];

  List<UserModel> get items {
    return _items;
  }

  // void addUser(String user_id, UserModel user
  //     ) {
  //   if (_items.containsKey(user_id)) {
  //     _items.update(
  //       user_id,
  //           (existingUser) =>  UserModel(
  //                   user_id: existingUser.user_id,
  //                   user_number: existingUser.user_number,
  //                   user_name: existingUser.user_name,
  //                   user_email: existingUser.user_email,
  //                   company: existingUser.company,
  //                   emirates_id_front: existingUser.emirates_id_front,
  //                   emirates_id_back: existingUser.emirates_id_back,
  //                   emirate_id_expiry_date: existingUser.emirate_id_expiry_date,
  //                   trade_license: existingUser.trade_license,
  //                   trade_license_expiry_date: existingUser.trade_license_expiry_date,
  //                   trn_number: existingUser.trn_number,
  //                   verified: existingUser.verified,
  //               ),
  //     );
  //   } else {
  //     _items.putIfAbsent(
  //       user_id,
  //           () =>  UserModel(
  //                   user_id: DateTime.now().toString(),
  //                   user_number: user.user_number,
  //                   user_name: user.user_name,
  //                   user_email: user.user_email,
  //                   company: user.company,
  //                   emirates_id_front: user.emirates_id_front,
  //                   emirates_id_back: user.emirates_id_back,
  //                   emirate_id_expiry_date: user.emirate_id_expiry_date,
  //                   trade_license: user.trade_license,
  //                   trade_license_expiry_date: user.trade_license_expiry_date,
  //                   trn_number: user.trn_number,
  //                   verified: user.verified,
  //               ),
  //     );
  //   }
  //   notifyListeners();
  // }

  // void updateuser(UserModel users) {
  //   final newuser = UserModel(
  //       user_id: users.user_id,
  //       user_number: users.user_number,
  //       user_name: users.user_name,
  //       user_email: users.user_email,
  //       company: users.company,
  //       emirates_id_front: users.emirates_id_front,
  //       emirates_id_back: users.emirates_id_back,
  //       emirate_id_expiry_date: users.emirate_id_expiry_date,
  //       trade_license: users.trade_license,
  //       trade_license_expiry_date: users.trade_license_expiry_date,
  //       trn_number: users.trn_number,
  //       verified: users.verified,
  //   );
  //   _items.add(newuser);
  //   notifyListeners();
  // }

  void Adduser(UserModel users) {
    final userNumber = UserModel(
      user_id: users.user_id,
      user_number: users.user_number,
      verified: users.verified,
      is_registered: users.is_registered,
    );
    _items.add(userNumber);
    notifyListeners();
  }

  updateUser(
    UserModel user,
    String jwtToken,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['user_number'] = user.user_number;
      map['user_name'] = user.user_name;
      map['user_email'] = user.user_email;
      map['company'] = user.company;
      map['emirates_id_front'] = user.emirates_id_front;
      map['emirates_id_back'] = user.emirates_id_back;
      map['emirate_id_expiry_date'] = user.emirate_id_expiry_date;
      map['trade_license_number'] = user.trade_license_number;
      map['trade_license_number_image'] = user.trade_license_image;
      map['trade_license_expiry_date'] = user.trade_license_expiry_date;
      map['trn_number'] = user.trn_number;
      map['trn_number_image'] = user.trn_number_image;
      // map['verified'] = user.verified.toString();

      http.Response response = await http.post(
        Uri.parse('https://auth.azscrap.com/api/user/user-registration'),
        headers: {
          "x-access-token": jwtToken,
        },
        body: map,
      );
      print(response.body);
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['data']);
      if (json.decode(response.body)['statusCode'] == 200) {
        _items[0] = user;
        notifyListeners();
      }
      return json.decode(response.body)['statusMsg'];
    } catch (error) {
      print(error);
    }
  }

  // void updateUser(UserModel user) {
  //   _items[0] = user;
  //   notifyListeners();
  //   // final userIndex = _items.indexWhere((user) => user.user_id == id);
  //   // if (userIndex >= 0) {
  //   //   _items[userIndex] = user;
  //   //   notifyListeners();
  //   // } else {
  //   //   print('...');
  //   // }
  // }

  Future FetchUser(String number, String token) async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://auth.azscrap.com/api/user/get-user/$number'),
        headers: {
          "x-access-token": token,
        },
        // body: map,
        // body:  json.encode({
        //   'phoneNumber': "0383748377",
        //   'sessionInfo': "this is token info",
        // }),
      );
      final UserData =
          json.decode(response.body)['data'] as Map<String, dynamic>;
      final List<UserModel> loadedUser = [];
      //final List<Product> loadedProducts = [];
      loadedUser.add(UserModel(
        user_id: UserData['_id'],
        user_number: UserData['user_number'],
        user_name: UserData['user_name'],
        user_email: UserData['user_email'],
        company: UserData['company'],
        emirates_id_front: UserData['emirates_id_front'],
        emirates_id_back: UserData['emirates_id_back'],
        emirate_id_expiry_date: UserData['emirate_id_expiry_date'],
        trade_license_number: UserData['trade_license_number'],
        trade_license_image: UserData['trade_license_number_image'],
        trade_license_expiry_date: UserData['trade_license_expiry_date'],
        trn_number: UserData['trn_number'],
        trn_number_image: UserData['trn_number_image'],
        verified: UserData['verified'],
        is_registered: true,
      ));
      _items = loadedUser;
      notifyListeners();
      print("The get user API response start from here");
      // print(response.body);
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['statusCode']);
      // print(json.decode(response.body)['data']);
    } catch (error) {
      print(error);
    }
  }

  UserModel findById() {
    return _items[0];
  }

  EditUser(
    UserModel user,
    String jwtToken,
  ) async {
    try {
      var map = Map<String, dynamic>();
      map['user_number'] = user.user_number;
      map['user_name'] = user.user_name;
      map['user_email'] = user.user_email;
      map['company'] = user.company;
      map['emirates_id_front'] = user.emirates_id_front;
      map['emirates_id_back'] = user.emirates_id_back;
      map['emirate_id_expiry_date'] = user.emirate_id_expiry_date;
      map['trade_license_number'] = user.trade_license_number;
      map['trade_license_number_image'] = user.trade_license_image;
      map['trade_license_expiry_date'] = user.trade_license_expiry_date;
      map['trn_number'] = user.trn_number;
      map['trn_number_image'] = user.trn_number_image;
      // map['verified'] = user.verified.toString();

      http.Response response = await http.post(
        Uri.parse('https://auth.azscrap.com/api/user/edit-user'),
        headers: {
          "x-access-token": jwtToken,
        },
        body: map,
      );
      print(response.body);
      print(json.decode(response.body)['statusMsg']);
      print(json.decode(response.body)['data']);
      if (json.decode(response.body)['statusCode'] == 200) {
        _items[0] = user;
        notifyListeners();
      }
      return json.decode(response.body)['statusMsg'];
    } catch (error) {
      print(error);
    }
  }

  // void EditUser(UserModel user) {
  //   _items[0] = user;
  //   notifyListeners();
  //   // final userIndex = _items.indexWhere((user) => user.user_id == id);
  //   // if (userIndex >= 0) {
  //   //   _items[userIndex] = user;
  //   //   notifyListeners();
  //   // } else {
  //   //   print('...');
  //   // }
  // }

}
