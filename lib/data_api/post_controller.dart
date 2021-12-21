import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/models/post_model.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class PostController extends GetxController{
  var postList=<Post>[].obs;
  var isLoading=true.obs;
  List<Post> data=[];
  var userPostList=<Post>[].obs;
  var userPostLoading=true.obs;
  List<Post> userPostData=[];
  var userBookmarks=<Post>[].obs;
  var bookmarksLoading=true.obs;
  List<Post> bookmarksData=[];
  var postOfChallenge=<Post>[].obs;
  var postOfChallengeLoading=true.obs;
  List<Post> postOfChallengeData=[];
  final _client=Get.find<SupabaseClient>();
  final  authorController=Get.put(AuthorController());
  var postsOfOther=[].obs;

  Future<bool> fetchFollowingPublicPosts() async{
    final currentId=authorController.currentAuthor.id;
    print(currentId.toString());
    var result=await _client.rpc('get_public_posts_of_following',params: {'author_id':currentId}).execute();
    print('**********************==================**'+'1');
    print(result.data);
    if(result.error==null){
      data=List<Post>.from(result.data.map((i)=>Post.fromData(i!)).toList());
        postList.value=data;
      return isLoading(false);
    }else{
      Get.snackbar("sorry", result.error!.message);
      return isLoading.value;
    }

  }
  Future<bool> getBookmarks()async{
    final currentId=authorController.currentAuthor.id;
    print(currentId.toString());
    var result=await _client.rpc('get_author_bookmarks',params: {'author_id':currentId}).execute();

    print('**********************==================**'+'1');
    print(result.data);
    if(result.error==null){
      bookmarksData=List<Post>.from(result.data.map((i)=>Post.fromData(i!)).toList());
      userBookmarks.value=bookmarksData;
      return bookmarksLoading(false);
    }else{
      Get.snackbar("sorry", result.error!.message);
      return bookmarksLoading.value;
    }
  }

  Future addNewPost({required challengeId,required content,required image,required video})async{

   var res=await _client.from('app_posts').insert({
     'challenge_id':challengeId,
     'content':content,
     'video':video,
     'image':image,
      'creator_id':authorController.currentAuthor.id,
   }).execute();
   if(res.error==null){
     Post newPost=Post(id:res.data[0]['id'],challengeId:challengeId ,content:content ,image:image ,video:video ,creatorId:authorController.currentAuthor.id,
     created: DateTime.now(),creatorAvatar: authorController.currentAuthor.avatar,creatorDisplay: authorController.currentAuthor.display,
     creatorName: authorController.currentAuthor.name);
    if(newPost.challengeId==null){
      postList.insert(0,newPost);
    }else{
      postOfChallenge.insert(0, newPost);
    }

   }else{
     print(res.error!.message);
    Get.snackbar('sorry','error in sending your post ',backgroundColor:Colors.red);

   }
  }








Future likePost({required String postId,required var list,required int index})async{
    String? _currentID=authorController.currentAuthor.id;
  var result=  await _client.from('post_likes').insert([{
     'user_id':_currentID,
      'post_id':postId,
    }]).execute();
    if(result.error==null){
      list[index].liked=true;
      print('i liked the post');
    }

}

  Future unlikePost({required String postId,required var list,required int index})async{
    String? _currentID=authorController.currentAuthor.id;
    var result=  await _client.from('post_likes').delete().match({'user_id': _currentID,'post_id': postId}).execute();
    if(result.error==null){
      list[index].liked=false;
      print('unliked');
    }

  }
  
  
  
  Future getUserPosts()async{
    var currentId=authorController.currentAuthor.id;
    var result=await _client.rpc('get_author_posts',params: {'author_id':currentId}).execute();
    if(result.error==null){
     userPostData =List<Post>.from(result.data.map((i)=>Post.fromData(i!)).toList());
      userPostList.value=userPostData;
      return userPostLoading(false);
    }else{
      Get.snackbar("sorry", result.error!.message);
      return userPostLoading.value;
    }

  }

  Future removeBookMark(var postId)async{
    String? _currentID=authorController.currentAuthor.id;
    await _client.from('user_bookmarks').delete().eq('user_id',_currentID).eq('post_id',postId).execute();
    userBookmarks.removeWhere((e) =>e.id==postId);
  }

  var looding=false.obs;
    var posts=<Post>[].obs;
    var error=false.obs;
  Future getAuthorViewPosts(var authorId)async{
    looding(true);
 var res =await _client.rpc('get_author_posts',params: {'author_id':authorId}).execute();
 if(res.data!=null){
   looding(false);
    posts.value=List<Post>.from(res.data.map((post)=>Post.fromData(post)).toList());
    print(posts.length);
 }if(res.error!=null){
      looding(false);
      error(true);
 }
  }


  
  
  Future getChallengePosts(var challengeId)async{
    String? _currentID=authorController.currentAuthor.id;
  var result= await _client.rpc('get_posts_of_challenge',params: {'challeng_id':challengeId,'author_id':_currentID}).execute();
    if(result.error==null){
      postOfChallengeData=List<Post>.from(result.data.map((i)=>Post.fromData(i!)).toList());
      postOfChallenge.value=postOfChallengeData;
      postOfChallengeLoading(false);

    }else{
      Get.snackbar('hi', 'sorry something error ');
      postOfChallengeLoading(false);
    }
  }

    Rx<Post> _aPost = Rx(Post(challengeId: '', video: ''));
  set currentAuthor(Post value) => _aPost.value = value;
   Post get onePost => _aPost.value;
  var loodingPost=false.obs;
  var errorPost=false.obs;
  Future getAPost({required String postId})async{
    loodingPost(true);
    String? _currentID=authorController.currentAuthor.id;
    var result=  await _client.rpc('get_a_post',params: {'post_id':postId,'current_author_id':_currentID!}).single().execute();
    if(result.error==null){
      print(result.data);
      var a=Post.fromData(result.data);
      _aPost.value=a;
      loodingPost(false);
    }else{
      loodingPost(false);
      errorPost(true);
    }

  }  
  
  
  
  
  
  
  
  
}

