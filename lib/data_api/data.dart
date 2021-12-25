import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:get/get.dart';

class DataServices {
  final _client = Get.find<SupabaseClient>();


  Future<String?> uploadImage(
      {required File file, required String bucket}) async {
    var _id = _client.auth.currentUser!.id;
    print('starting upload ');
    print('*********************');
    print(_id);
    var path = _id + DateTime.now().toString();
    var result = await _client.storage.from(bucket).upload(path, file);
    if (result.error != null) {
      print(result.error.toString() + " uploading");
      Get.snackbar('hi  ', result.error!.message, backgroundColor: Colors.red);
    }
    Future.delayed(const Duration(microseconds: 300));
    var imageUrl = _client.storage.from(bucket).getPublicUrl(path);
    print('*****************');
    print(imageUrl.data);
    if (imageUrl.error != null) {
      print(imageUrl.error.toString() + " get url ");
      Get.snackbar('hi ', imageUrl.error!.message, backgroundColor: Colors.red);
    }

    return imageUrl.data!;
  }

  Future<String?> uploadVideo(
      {required File file, required String bucket}) async {
    var _id = _client.auth.currentUser!.id;
    print('starting upload ');
    print('*********************');
    print(_id);
    var path = _id + DateTime.now().toString();
    var result = await _client.storage.from(bucket).upload(path, file);
    if (result.error != null) {
      print(result.error.toString() + " uploading");
      Get.snackbar('hi  ', result.error!.message, backgroundColor: Colors.red);
    }
    Future.delayed(const Duration(microseconds: 300));
    var videoUrl = _client.storage.from(bucket).getPublicUrl(path);
    print('*****************');
    print(videoUrl.data);
    if (videoUrl.error != null) {
      print(videoUrl.error.toString() + " get url ");
      Get.snackbar('hi ', videoUrl.error!.message, backgroundColor: Colors.red);
    }

    return videoUrl.data!;
  }
}
