
import 'dart:async';
import 'package:doitys/data_api/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:get/get.dart';


class AuthUtil {
  late String _id;

  String get id => _id;
  late SharedPreferences _prefs;
  final _client = Get.find<SupabaseClient>();
    final _currentAuthor=Get.put(AuthorController());
  Future signUp(String email, String password) async {
    final response = await _client.auth.signUp(email, password);
    if (response.error == null) {
      return response;
    }
    Get.snackbar('hi', response.error!.message);
    return response;
  }

  Future saveUser(id, String email, String name, String displayName,
      String location) async {
    final result = await _client.from('app_users').insert([
      {
        "user_id": id,
        "email": email,
        "name": name,
        "display": displayName,
        "location": location
      }
    ]).execute();
    if (result.error == null) {

      return true;
    }
  }

  Future<GotrueSessionResponse> login(String eml, String pd) async {
    final response = await _client.auth.signIn(email: eml, password: pd);
    return response;
  }

  Future <GotrueResponse> logout() async {
    final response = _client.auth.signOut();
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("session", "");
    return response;
  }

  resetPassword(String email) async {
    var result = await _client.auth.api.resetPasswordForEmail(email);
    if (result.error == null) {
      Get.snackbar('hi', 'we send you an email to reset your password');
    }
  }

  ///get session from local storage
  Future getLocalSession() async {
    _prefs = await SharedPreferences.getInstance();
    var session = _prefs.getString("session");
    return session;
  }
//search
  Future searchUsers(String searchWord)async{
    _id=_client.auth.currentUser!.id;
    var res=await _client.rpc('search_users',params: {'search_word':searchWord,'current_author_id':_id})
        .execute();
    if(res.error==null) {
      var data=res.data;
      print(res.data);
      for(var i=0;i<data.length;i++){
        data[i]['type']='Author';
      }
      print(res.error);
      return data ;
    }
  }
    //search
  Future searchNames(String searchWord)async{
    _id=_client.auth.currentUser!.id;
    var res=await _client.from('app_users')
        .select('name, user_id ,avatar')
        .like('name', '%$searchWord%')
        .execute();
    if(res.error==null) {
      var data=res.data;
      if (kDebugMode) {
        print(res.data);
        print(res.error);
      }

      return data ;
    }
  }

  //search posts
  Future searchPosts(String searchWord)async{
    var res=await _client
        .from('app_posts')
        .select('content, id')
        .like('content', '%$searchWord%')
        .execute();
    if(res.error==null) {
      var data=res.data;
      for(var i=0;i<data.length;i++){
        data[i]['type']='Post';
      }
      return data ;
    }
  }
  //search challenges
  Future searchChallenges(String searchWord)async{
    var res=await _client
        .from('app_challenges')
        .select('content, id')
        .like('content', '%$searchWord%')
        .execute();
    if(res.error==null) {
      var data=res.data;
        for(var i=0;i<data.length;i++){
          data[i]['type']='Challenge';
        }
      return data ;
    }
  }


//recover session
  Future<bool> recoverSession() async {
    print(' try recovering');

    _prefs = await SharedPreferences.getInstance();
    var _session = _prefs.getString("session");
    if(_session==null){
      return false;
    }
    var result = await _client.auth.recoverSession(_session);
    if (result.error != null) {
      return false;
    }
    print('new session ****** :' + result.data!.persistSessionString);
    await _prefs.setString("session", result.data!.persistSessionString);
    return true;
  }

    Future mentionUser({required commentId ,required replayId ,required mentionedId})async{
  var res= await _client.from('app_mentions').insert({
        'comment_id':commentId,
        'replay_id':replayId,
        'mentioned_id':mentionedId,
        'creator_id':_currentAuthor.currentAuthor.id,
   }).execute();

  if(res.error!=null){
    print('mention error ');
    print(res.error!.message);
  }
    }


  Future<bool>autoLogin()async{
    _prefs = await SharedPreferences.getInstance();
    var _email=_prefs.getString('email');
    var _password=_prefs.getString('password');
  var result=await _client.auth.api.signInWithEmail(_email!, _password!);
  if(result.user!=null){
    print('sucsses login');
    return true;}
  print('failed login');
  return false;

  }

  Future isProfileComplete({required var userId}) async {
  final complete=  await _client.from('app_users').select().eq('user_id', userId).execute();
      return complete.data;
  }

}
