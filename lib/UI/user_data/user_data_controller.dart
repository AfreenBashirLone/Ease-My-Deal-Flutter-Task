import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../MODEL/user_data.dart';
import '../../UTILS/http_service.dart';

class UserDataController extends GetxController{

  Rxn<UserDataModel> userData = Rxn<UserDataModel>();
  Rx<bool> isDataLoaded = false.obs;
  Rx<bool> isLoading = false.obs;

  Future<UserDataModel?> getUserDataApi(BuildContext context, String url) async {

    var postResponse = await HttpService().get(
        url,
      );


    return UserDataModel.fromJson(jsonDecode(postResponse.body.toString()));
  }

}