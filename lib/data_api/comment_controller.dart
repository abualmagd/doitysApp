import 'package:doitys/data_api/auth.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/models/comment_model.dart';
import 'package:doitys/models/reply_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class CommentController extends GetxController{
  var comments=<Comment>[].obs;
  var loading=false.obs;
  var error=false.obs;
  var _client=Get.find<SupabaseClient>();
  var _authorController=Get.find<AuthorController>();
    var _auth=AuthUtil();
  Future getPostComments(var postId)async{
    loading(true);
    var _currentAuthor=_authorController.currentAuthor;
    var res=await _client.rpc('get_comments_of_post',params: {
      'postid':postId,
      'current_author_id':_currentAuthor.id
    }).execute();
    if(res.error==null){
      loading(false);
      comments.value=List.from(res.data.map((e) => Comment.fromData(e)).toList());
    }else {
      loading(false);
      error(true);
    }
  }

  Future addNewComment({required var content,required var postId, required List mentioned})async{
    var _currentAuthor=_authorController.currentAuthor;
    var res=await _client.from('app_comments').insert({
      'content':content,
      'post_id':postId,
      'creator_id':_currentAuthor.id,
    }).execute();
    if(res.error==null){
      Comment comment=Comment(res.data[0]['id'], content, DateTime.now(),_currentAuthor.id, postId,
          _currentAuthor.avatar, _currentAuthor.name, 0,false,0);
      comments.insert(0, comment);
      print(mentioned);

        for(String i in mentioned){
         await _auth.mentionUser(commentId: res.data[0]['id'], replayId:null,mentionedId:i);
        }

    }else {

      Get.snackbar(
          'hi', 'Error in sending your comment', backgroundColor: Colors.grey);

    }
  }
  Future removeMyComment(var commentId)async{
  var res=await _client.from('app_comments').delete().eq('id', commentId).execute();
    if(res.error==null){
      comments.removeWhere((element) => element.id==commentId);
    }
    print(res.error!.message);
  Get.snackbar('hi', 'Error in delete your comment',backgroundColor:Colors.grey);
  }

  Future likeComment(var commentId)async{
    var _currentAuthor=_authorController.currentAuthor;
    await _client.from('comment_likes').insert({
      'user_id':_currentAuthor.id,
      'comment_id':commentId
    }).execute();

  comments[comments.indexWhere((element) => element.id==commentId)].liked=true;
    comments[comments.indexWhere((element) => element.id==commentId)].likesCount
    =comments[comments.indexWhere((element) => element.id==commentId)].likesCount!+1;
  }

  Future unlikeComment(var commentId)async{
    var _currentAuthor=_authorController.currentAuthor;
    await _client.from('comment_likes').delete().match({'user_id':_currentAuthor.id,'comment_id':commentId}).execute();
    comments[comments.indexWhere((element) => element.id==commentId)].liked=false;
    comments[comments.indexWhere((element) => element.id==commentId)].likesCount
    =comments[comments.indexWhere((element) => element.id==commentId)].likesCount!-1;
  }





  ///replies methods
Map allReplies={}.obs;
  Future getReplies(var commentId)async {
    var _currentAuthor = _authorController.currentAuthor;
    var res = await _client.rpc('get_replies_of_comment', params: {
      'commentid': commentId,
      'current_author_id': _currentAuthor.id
    }).execute();
    if (res.error == null) {
        print('******** get replies');
        print(res.data);

       List<Reply> replies= List.from(res.data.map((e) => Reply.fromData(e)).toList());
       replies.reversed;

        allReplies[commentId]=replies;

    } else {
     Get.snackbar('hi', 'sorry in loading replies',backgroundColor: Colors.red);
      print(res.error);

    }
  }

  Future addNewReply({required var replayTo,required var content,required var commentId,required var mentioned})async{
    var _currentAuthor=_authorController.currentAuthor;
    var res=await _client.from('app_replies').insert({
      'reply_to':replayTo,
      'content':content,
      'comment_id':commentId,
      'creator_id':_currentAuthor.id,
    }).execute();
    if(res.error==null){
      print(res.data);
      Reply reply=Reply(res.data[0]['id'], content,DateTime.now(),_currentAuthor.id,
          commentId, _currentAuthor.avatar, _currentAuthor.name,0,false, replayTo);
     allReplies[commentId].add(reply);
      comments[comments.indexWhere((element) => element.id==commentId)].repliesCount=
          comments[comments.indexWhere((element) => element.id==commentId)].repliesCount!+1;
      if(mentioned.isNotEmpty){
        for(int i in mentioned){
          _auth.mentionUser(commentId: null, replayId:res.data[0]['id'],mentionedId:mentioned[i]);
        }
      }


    }else{
      Get.snackbar('hi', 'Error in sending your comment',backgroundColor:Colors.grey);
      print('errrrrrrrrrrrrrrrrrrrrrrrrrrr');
      print(res.error!.message);
    }}

  Future removeMyReply({required var replyId,required var commentId})async {
    var res = await _client.from('app_replies').delete()
        .eq('id', replyId)
        .execute();
    if (res.error == null) {
      allReplies[commentId].removeWhere((element) => element.id == replyId);
      comments[comments.indexWhere((element) => element.id==commentId)].repliesCount=
          comments[comments.indexWhere((element) => element.id==commentId)].repliesCount!-1;
      refresh();
    } else {
      Get.snackbar(
          'hi', 'Error in delete your comment', backgroundColor: Colors.grey);
      print(res.error!.message);
    }
  }
  Future likeReply(var replyId,var commentId)async{
    var _currentAuthor=_authorController.currentAuthor;
    await _client.from('reply_likes').insert({
      'user_id':_currentAuthor.id,
      'reply_id':replyId
    }).execute();
  var index = allReplies[commentId].indexWhere((element) => element.id==replyId);
    allReplies[commentId][index].liked=true;
    allReplies[commentId][index].likesCount=  allReplies[commentId][index].likesCount+1;
    print('liked this reply');
///update liked at allReplies
  }

  Future unlikeReply(var replyId,var commentId)async{
    var _currentAuthor=_authorController.currentAuthor;
    await _client.from('reply_likes').delete().match({'user_id':_currentAuthor.id,'reply_id':replyId}).execute();
    var index = allReplies[commentId].indexWhere((element) => element.id==replyId);
    allReplies[commentId][index].liked=false;
    allReplies[commentId][index].likesCount=  allReplies[commentId][index].likesCount-1;
    print('unlikk this reply');
  }
  int  increaseRepliesCount(int index){
    refresh();
    return comments[index].repliesCount!+1;
  }
  int  decreaseRepliesCount(int index){
    refresh();
    return comments[index].repliesCount!-1;

  }

  Future getMoreReplies(int offset,var commentId)async{
    var _currentAuthor = _authorController.currentAuthor;
    var res = await _client.rpc('get_replies_of_comment', params: {
      'commentid': commentId,
      'current_author_id': _currentAuthor.id
    }).range(offset,offset+5).execute();
    if (res.error == null) {
      loading(false);
      error(false);
      print(res.data);
     List<Reply> replies =
          List.from(res.data.map((e) => Reply.fromData(e)).toList());

     // comments[comments.indexWhere((element) => element.id==commentId)].replies.insertAll(offset, replies);
      allReplies[commentId].insertAll(offset, replies);
    } else {
    Get.snackbar('hi', 'error in loading more comments');
      print(res.error);
    }
  }



}