import 'dart:convert';
import 'dart:io';

import 'package:doitys/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class AuthorController extends GetxController {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Rx<Author> _currentAuthor = Rx(Author());
  set currentAuthor(Author value) => _currentAuthor.value = value;
  Author get currentAuthor => _currentAuthor.value;

    Rx<Author> _authorView=Rx(Author());
    set authorView(Author value)=>_authorView.value=value;
    Author get authorView=>_authorView.value;
  var authorViewLoading=false.obs;
  final _client = Get.find<SupabaseClient>();

  Future<String?> getCurrentId() async {
    final id = _client.auth.currentUser!.id;
    return id;
  }

  Future<Author> getCurrentAuthor() async {
    var id = _client.auth.currentUser!.id;
    print(id);
    var result =
        await _client.rpc('get_author', params: {'author_id': id}).execute();
    print(result.data);
    if (result.error != null) print("errrrrrrrrror :" + result.error!.message);
    if (result.error == null)
      Get.find<AuthorController>().currentAuthor =
          Author.fromData(result.data[0]);

    final SharedPreferences prefs = await _prefs;
    var jsonMap = currentAuthor.toJson();
    var jsonString = jsonEncode(jsonMap);
    prefs.setString("persistAuthor", jsonString);
    print('get the current user ************* ');
    return Get.find<AuthorController>().currentAuthor;
  }

  Future<Author> getPtUser() async {
    final SharedPreferences prefs = await _prefs;
    var data = jsonDecode(prefs.getString("persistAuthor") ?? "");
    Get.find<AuthorController>().currentAuthor = Author.fromJson(data);
    return Get.find<AuthorController>().currentAuthor;
  }
  Future<Author> getUserView(userId,_currentAuthorId)async{
    authorViewLoading(true);
    var result= await _client.rpc('get_view_author', params: {'author_id': userId,'current_author_id':_currentAuthorId}).single().execute();
    if(result.error==null&&result.data!=null){
      _authorView(Author.fromData(result.data));
      authorView=_authorView.value;
      authorViewLoading(false);
      print(result.data);
      return authorView;
    }else {
      throw FlutterError(result.error!.message);
    }
  }


Future follow(var authorId)async{
  final id = _client.auth.currentUser!.id;
var res= await _client.from('user_following').insert({'user_id':id,'following_id':authorId}).execute();
if (res.error!=null){
  print(res.error!.message);
  throw PlatformException(code: res.error!.message);
}
print(res.data);
}
  Future unfollow(var authorId)async{
    final id = _client.auth.currentUser!.id;
 var res=   await _client.from('user_following').delete().match({'user_id':id,'following_id':authorId}).execute();
    if (res.error!=null){
      throw PlatformException(code: res.error!.message);
    }
    print(res.data);
  }





  Future updateDisplay(String display) async {}

  Future updateBio(String bio) async {}

  Future updateWebsite(String website) async {}

  Future<String?> uploadImage(
      {required File file,
      required String bucket}) async {
    var _id=_client.auth.currentUser!.id;
    print('starting upload ');
    print('*********************');
    print(_id);
    var path =_id+DateTime.now().toString();
    var result = await _client.storage.from(bucket).upload(path,file);
                      if (result.error != null) {
                        print(result.error.toString()+" uploading");
                        Get.snackbar('hi  ', result.error!.message, backgroundColor: Colors.red);}
                        Future.delayed(Duration(microseconds: 300));
                            var imageUrl =  _client.storage.from(bucket).getPublicUrl(path);
                                              print('*****************');
                                              print(imageUrl.data);
                            if (imageUrl.error != null) {
                              print(imageUrl.error.toString()+" get url ");
                              Get.snackbar('hi ', imageUrl.error!.message, backgroundColor: Colors.red);
                            }

                            return imageUrl.data!;
                          }

  Future<bool> updateAvatar({required String? url}) async {
    var id = await getCurrentId();
    if (id != null) {
      var result = await _client
          .from('app_users')
          .update({"avatar": url})
          .eq("user_id", id)
          .execute();
      if (result.error != null) {
        Get.snackbar('hi', result.error!.message);
      }
      Get.snackbar('hi', 'profile image updated');
      return true;
    }
    Get.snackbar('hi', 'something error');
    return false;
  }
}
