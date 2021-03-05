import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import 'app_user.dart';
import 'hive_store.dart';

class UserRepository {
  final HiveStore _hiveStore;
  HiveStore get hiveStore => _hiveStore;

  static initHiveStore(hiveBox) => HiveStore(hiveBox: hiveBox);
  UserRepository({
    @required Box hiveBox,
  }) : _hiveStore = initHiveStore(hiveBox);

  Future<AppUser> signIn({String username, String password}) async {
    AppUser appUser = AppUser(username: username);
    // username-password, see https://www.notion.so/Mobile-Application-Developer-Apply-Project-d3c839c30a47430a805cc14b8ee4262a

    String reqUrl = "https://aodapi.eralpsoftware.net/login/apply";
    Map<String, String> reqHeaders = Map()
      ..putIfAbsent("Accept", () => "application/json")
      ..putIfAbsent("Content-Type", () => "application/json");

    try {
      final response = await http.post(
        Uri.parse(reqUrl),
        headers: reqHeaders,
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ),
      );

      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (responseMap["status"] == "success") {
        appUser.uid =
            responseMap.containsKey("userId") ? responseMap["userId"] : null;
        appUser.token =
            responseMap.containsKey("token") ? responseMap["token"] : null;
      } else {
        appUser.extData = Map()
          ..putIfAbsent("ERROR", () => responseMap["message"]);
      }
    } catch (ex) {
      appUser.extData = Map()..putIfAbsent("ERROR", () => "${ex.toString()}");
      print(ex);
    }

    if (appUser.uid != null) {
      _hiveStore.save("APP_USER", appUser);
    }

    return appUser;
  }

  signOut() {
    _hiveStore.clear();
  }

  bool isSignedIn() {
    return _hiveStore.contains("APP_USER");
  }
}
