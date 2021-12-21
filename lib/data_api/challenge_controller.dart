

import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/models/challenge_model.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

enum Joining{
  wait,start,failed,success
}


class ChallengeController extends  GetxController{
  var challengeList=<Challenge>[].obs;
  List<Challenge> data=[];
  var userChallengeList=<Challenge>[].obs;
  List<Challenge> response=[];
  var isLoading=true.obs;
  var joining='wait'.obs;
  final currentUserController=Get.find<AuthorController>();

    final _client=Get.find<SupabaseClient>();

   getMoreChallenges()async{

     var currentId=_client.auth.currentUser!.id;
    var result=await _client.rpc('get_more_challenges',params: {'author_id':currentId,'start_offset':challengeList.length}).execute();
    print('try to get more challenges ');
    if(result.error==null){

     var x= List<Challenge>.from(result.data.map((i)=>Challenge.fromData(i!)).toList());
     data.insertAll(0, x);
     challengeList.value=data;
    }
    return challengeList;
  }

  void getAllChallenges()async{
    var currentId=_client.auth.currentUser!.id;
    var result=await _client.rpc('get_challenges',params: {'author_id':currentId}).execute();

    if(result.error==null){
    data=List<Challenge>.from(result.data.map((i)=>Challenge.fromData(i!)).toList());
    print('************************');
    challengeList.value=data;

     isLoading(false);
     }else{
       Get.snackbar("sorry", result.error!.message);
       isLoading(true);
     }


  }

  void getUserChallenge()async{
    var currentId=_client.auth.currentUser!.id;
    try{
      isLoading(true);
      var result=await _client.rpc('get_author_challenges',params: {'author_id':currentId}).execute();
      print(result.data);
      response=List<Challenge>.from(result.data.map((i)=>Challenge.fromJson(i!)).toList());
      userChallengeList.value=response;
      print('geted user challenges');
    } finally {
      isLoading(false);
    }
  }

  Future add(Challenge challenge)async{
    final _currentId=currentUserController.currentAuthor.id;

       var result=  await _client.from('app_challenges').insert([{
            'title':challenge.title,
            'content':challenge.content,
            'image':challenge.image,
            'video':challenge.video,
            'start_at':challenge.startsAt,
            'end_at':challenge.endsAt,
            'days':challenge.days,
            'creator_id':_currentId,
          }],).execute();
       if(result.error==null){
         print('result:   ');
         print(result.data);
         var newItem=Challenge.fromData(result.data[0])
         ;
         print(newItem.id);
       await  _client.from('challenge_members').upsert([{ /// make the creator of challenge member too of this challenge
           'user_id':_currentId,
           'challenge_id':newItem.id,
         }]).execute();
       var newChallenge=await _client.rpc('get_new_challenge',params: {'ch_id':newItem.id}).single().execute();
       if(newChallenge.error==null) {
         data.insert(0, Challenge.fromData(newChallenge.data));
         challengeList.value=data;
       }
          ///then refresh time line
       }else{
         print(result.error);
       }
                }
  void joinToChallenge(Challenge challenge)async{
          joining('start');
          print(joining);

          final currentId=currentUserController.currentAuthor.id;
          print(currentId);
         var result=  await _client.from('challenge_members').insert([{
            'challenge_id':challenge.id,
            'user_id':currentId,
          }]).execute();
         if(result.error!=null){
           print(result.error!.message);
           joining('failed');
           print(joining);
         }else {
           userChallengeList.add(challenge);
           joining('success');
           Future.delayed(const Duration(microseconds:200),()=>remove(challenge));
           print(joining);
         }
               }

  void remove(Challenge challenge){
          challengeList.remove(challenge);
              }
  void unJoin(Challenge challenge)async{
            final currentId=currentUserController.currentAuthor.id;
            userChallengeList.remove(challenge);
            await _client.from('challenge_members').delete().eq('user_id', currentId).eq('challenge_id',challenge.id).execute();
          }

  var loading=false.obs;
   var error=false.obs;
   final Rx<Challenge> _oneChallenge=Rx(Challenge());
   set oneChallenge(Challenge value)=>_oneChallenge.value=value;
   Challenge get oneChallenge=>_oneChallenge.value;
  Future getAChallenge({ required var challengeId})async{
    loading(true);
    var currentId=_client.auth.currentUser!.id;
    var res=await _client.rpc('get_a_challenge',params:{'current_author_id':currentId,'ch_id':challengeId}).single().execute();
    if(res.error!=null){
      loading(false);
      error(true);
    }
    loading(false);
    _oneChallenge.value=Challenge.fromData(res.data);
  }
}