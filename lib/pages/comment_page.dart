import 'package:doitys/data_api/auth.dart';
import 'package:doitys/data_api/comment_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:get/get.dart';
import 'package:doitys/formates/date_extension.dart';


class CommentPage extends StatefulWidget {
  final bool focusty;
  final  String postId;
  final int commentsCount;
  const CommentPage({required this.focusty,required this.postId,required this.commentsCount});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var _commentController=Get.put(CommentController());
  var _currentAuthor=Get.put(AuthorController());
  FocusNode? myFocus;
  AuthUtil _auth=AuthUtil();
  bool _focused=false;
  bool send=false;
  bool _searchUsers=false;
  TextEditingController _textController=TextEditingController();
  @override
  void initState() {
    myFocus=FocusNode();
    myFocus!.addListener(() { _handleFocusChange();});
    _commentController.getPostComments(widget.postId);
    super.initState();
  }
  void _handleFocusChange() {
    if (myFocus!.hasFocus != _focused) {
      setState(() {
        _focused = myFocus!.hasFocus;
      });
    }
  }
      var _startIndex=0;
      var _suggestions;
    getSuggestion()async{

     var res=await _auth.searchNames(_textController.text.substring(_startIndex).toLowerCase());

      setState(() {
      _suggestions=res;
      });

    }

  var _hintString = 'Add comment ..';
 var pressedComment;
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: MediaQuery
          .of(context)
          .viewInsets,
      height: MediaQuery
          .of(context)
          .size
          .height * .80,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),

        color:Theme.of(context).primaryColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(' '),
              Text(widget.commentsCount.toString()+' Comments'),
              IconButton(icon: Icon(Icons.close),
                  onPressed: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    Navigator.pop(context);

                  }
              )
            ],
          ),
          Expanded(
            child: GetX<CommentController>(
                builder:(GetxController controller){
                  if(_commentController.loading.value==true){
                    return Center(child: CircularProgressIndicator(),);
                  }else{
                    if(_commentController.error.value!=true){
                      return ListView.builder(
                          itemCount: _commentController.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _commentItem(context,index);
                          } );
                    }

                    return Center(child:Text('error'),);
                  }




                }),
          ),
           Container(height:8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular(18),
                  topRight:Radius.circular(18),
                )
            ),
          ),
          _inputComment(context),
        ],
      ),
    );
  }


  Widget _commentItem(BuildContext context,int index) {
    final theme=Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Padding(
      padding: const EdgeInsets.only(top:10,left: 4,right: 4),
      child: Material(
        color:Theme.of(context).canvasColor,// Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom:24),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              _commentController.comments[index].creatorAvatar!,
                            ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  InkWell(
                    onLongPress: (){
                      if(_commentController.comments[index].creatorId==_currentAuthor.currentAuthor.id){
                        showDialog(context: context, builder:(BuildContext context){
                          return AlertDialog(
                            content: Container(
                              child:TextButton(child: Text('hide  my comment  '),
                                  onPressed:(){
                                    _commentController.removeMyComment(_commentController.comments[index].id).then((value) {
                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                    });
                                  }),
                            ),
                          );
                        });
                      }
                    },
                    onTap: () {
                      if (_focused) {
                        myFocus!.unfocus();
                        setState(() {
                          _hintString = 'Add comment ..';
                          pressedComment=index;
                        });
                      }
                      else {
                        myFocus!.requestFocus();
                        setState(() {
                          _hintString='reply to '+ _commentController.comments[index].creatorName.toString();
                          pressedComment=index;
                        });
                      }
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_commentController.comments[index].creatorName!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.cyan,
                            ),),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width:MediaQuery.of(context).size.width*.65,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:1),
                                child: Text(_commentController.comments[index].content!.trim()),
                              ),
                            ),
                          ),
                           Text(
                             _commentController.comments[index].created!.styled
                            , style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey
                            ),), //  this comment created at
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8,bottom: 8,right:8),
                    child: LikeButton(
                      isLiked: _commentController.comments[index].liked,
                      likeCount:_commentController.comments[index].likesCount,
                     onTap: (bool value)async{
                    if(value==false){
                    _commentController.likeComment(_commentController.comments[index].id);

                    }else {
                      _commentController.unlikeComment(_commentController
                          .comments[index].id);
                    }
                    return !value;
                    },
                      size: 25,

                    ),

                  ),
                ],
              ),

              ( _commentController.comments[index].repliesCount==0)
                  ? SizedBox.shrink():

              Theme(

                data: theme,
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.zero,

                    title:Container(width:double.infinity,
                    child: Text('replies'),
                    ),
                  maintainState:false,
                  onExpansionChanged: (value){
                    if(_commentController.allReplies[_commentController.comments[index].id]==null){
                      _commentController.getReplies(_commentController.comments[index].id);
                    }
                  },
                children: [
                  GetX<CommentController>(

                      builder: (controller) {
                        if( _commentController.allReplies[_commentController.comments[index].id]==null){
                          return Center(child: CircularProgressIndicator());
                        }else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _commentController.allReplies[_commentController.comments[index].id].length,
                                  itemBuilder: (
                                      BuildContext context,
                                      int indx) =>
                                  _repliesItem(context, indx, index, _commentController.comments[index].id)),

                              (_commentController.allReplies[_commentController.comments[index].id].length <
                                  _commentController
                                      .comments[index]
                                      .repliesCount!)
                              
                              ?Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [

                                  TextButton(onPressed: () {
                                    ///get more replies


                                  },
                                    child: 
                                    Text('---More Replies',
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),) 
                                  ),
                                ],
                              ): SizedBox.shrink(),
                            ],
                          );
                        }
                      }
                  ),
                ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
var _subString=[];
  _inputComment(BuildContext context) {
    return Stack(
      children:[
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration:Duration(seconds:1),
            width:MediaQuery.of(context).size.width*.9,
            height:_searchUsers?100:0,
            child:_suggestions==null?Center(child: CircularProgressIndicator()):ListView.builder(
                itemCount:_suggestions.length,
                itemBuilder:(BuildContext context,int index)=>TextButton(child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 4),
                      child: CircleAvatar(radius:16,
                      backgroundImage: NetworkImage(_suggestions[index]['avatar']),
                      ),
                    ),
                    Text(_suggestions[index]['name']),
                    Expanded(child: Container(),),
                  ],
                ),onPressed: (){
                  setState(() {
                    _textController.text=_textController.text.substring(0,_startIndex-2) +_suggestions[index]['name'];
                    _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
                    _subString.add(_suggestions[index]['user_id']);
                    _searchUsers=false;
                    print('substring');
                      print(_subString);
                  });

                },),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 4,),
            color: Colors.transparent,
            width: 370,
            child:TextField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              focusNode: myFocus,
              autofocus: widget.focusty,
              controller: _textController,
              onChanged: (value){
                  print(value);
                  if(_searchUsers&&value.contains('@')&&value.length>1){
                    getSuggestion();
                  }

                  if(value.isNotEmpty){
                  setState(() {
                    send=true;
                  });
                }

                else{
                  setState(() {
                    send=false;
                    _searchUsers=false;
                    _subString.clear();

                  });}
              },
              decoration: InputDecoration(
                fillColor: Theme
                    .of(context)
                    .canvasColor,
                hintText: _hintString,
                isDense: true,

                filled: true,

                suffixIcon: AnimatedCrossFade(

                  duration: Duration(seconds: 1),
                  firstChild:  IconButton(
                      icon:Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.blue[600],
                      ),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          if (_hintString == 'Add comment ..') {
                            /// add comment
                            _commentController.addNewComment
                              (postId: widget.postId,
                                content: _textController.text.trim(),mentioned: _subString).whenComplete((){
                              _subString.clear();
                            });
                            _textController.clear();


                          } else {
                            /// add reply
                            _commentController.addNewReply(
                              commentId: _commentController.comments[pressedComment]
                                  .id,
                              replayTo: _commentController.comments[pressedComment]
                                  .creatorName,
                              content: _textController.text.trim(),mentioned: _subString);

                            _commentController.increaseRepliesCount(pressedComment);


                            _textController.clear();
                            _subString.clear();
                          }
                        }
                      }
                  ),
                  secondChild:SizedBox.shrink(),
                  crossFadeState: send? CrossFadeState.showFirst : CrossFadeState.showSecond,
                ),
                prefixIcon: IconButton(icon:Icon(Icons.alternate_email),onPressed: (){
                  setState(() {
                    _searchUsers=true;
                    _textController.text=_textController.text+'@a';

                    _textController.selection = TextSelection.fromPosition(TextPosition(offset:_textController.text.length));
                    _startIndex= _textController.text.length;
                  });
                  print(_textController.text.length);
                  getSuggestion();
                },),
              ),
            ),
          ),
        ],
      ),
  ]
    );
  }


var pressedReplay;
  Widget _repliesItem(BuildContext context,int indx,commentIndex,commentId) {
    return Padding(
        padding: const EdgeInsets.only(left:18.0,top:5),
        child: InkWell(
          onLongPress: (){

            if(_commentController.allReplies[commentId][indx].creatorId==_currentAuthor.currentAuthor.id){
              showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  content: Container(
                    child:TextButton(child: Text('delete my comment '),
                        onPressed:(){
                      _commentController.removeMyReply(replyId:_commentController.allReplies[commentId][indx].id, commentId: commentId).then((value) {
                        
                        _commentController.decreaseRepliesCount(commentIndex);

                        Navigator.pop(context);
                        setState(() {
                          
                        });
                      });
                        }),
                  ),
                );
              });
            }
          },
            onTap: () {
              if (_focused) {
                myFocus!.unfocus();
                setState(() {
                  _hintString='Add comment ..';
                });
              } else {
                myFocus!.requestFocus();
                setState(() {
                  _hintString='reply to '+_commentController.allReplies[commentId][indx].creatorName!;
                  pressedComment=commentIndex;
                  pressedReplay=indx;
                });
              }

            },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0,bottom:26),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          _commentController.allReplies[commentId][indx].creatorAvatar!,
                        ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( _commentController.allReplies[commentId][indx].creatorName!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.cyan,
                      ),),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 200,
                        child: Text( _commentController.allReplies[commentId][indx].content!,

                        ),
                      ),
                    ),
                    Text(  styled(_commentController.allReplies[commentId][indx].created!),
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:2.0,right:12),
                child: LikeButton(
                  size: 20,
                  isLiked:  _commentController.allReplies[commentId][indx].liked,
                  likeCount:_commentController.allReplies[commentId][indx].likesCount,
                  onTap: (bool value)async{
                    if(value==false){
                      _commentController.likeReply(_commentController.allReplies[commentId][indx].id,commentId);
                    }else {
                      _commentController.unlikeReply(
                          _commentController.allReplies[commentId][indx].id,commentId);
                    }
                    return !value;
                  },
                ),
              )
            ],
          ),
        ),


    );
  }

}







