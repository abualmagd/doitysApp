

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/models/post_model.dart';
import 'package:doitys/pages/comment_page.dart';
import 'package:doitys/pages/image_view.dart';
import 'package:doitys/pages/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/extensions.dart';
import 'package:doitys/global/better_player.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostWidget extends StatelessWidget {
  final index;
  final List<Post> data;
  const PostWidget({required Key key, this.index, required this.data}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    final _postController=Get.put(PostController());
    final _authorController=Get.put(AuthorController());
    Future<bool>onTap(bool value)async{
      if(value==true){
        _postController.likePost(postId: data[index].id!, list:data, index: index);
      }
      _postController.unlikePost(postId: data[index].id!, list:data, index: index);

      return !value;
    }
    var _currentId=_authorController.currentAuthor.id;
    Future getUserThenNavigate(var id)async{
      try {
        _authorController.getUserView(id, _authorController.currentAuthor.id).then((value) =>
            Navigator.of(context).push(rightCornerSideSlideTransition(Profile(value))),
        );
      }
      catch(r){
        Get.snackbar('sorry', 'error in loading user data ');
      }
    }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              elevation:2,
              child: Container(
                decoration: BoxDecoration(
                  //color: Color(0xfff4f0db), //Color(0xffFFFAF1),
                 color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8, right: 8, top: 12),
                                  child: InkResponse(
                                    onTap: (){
                                      (data[index].creatorId!=_currentId)
                                          ?getUserThenNavigate(data[index].creatorId!):print('nothing');
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(data[index].creatorAvatar!),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].creatorDisplay!,
                                    style: TextStyle(fontSize: 18,),
                                  ),
                                  Text(
                                    data[index].creatorName!,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 18, right: 8),
                          child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: false,
                                    context: context, builder: (BuildContext context) {
                                  return _postSettingSheet(context);
                                });
                              }),
                        ),
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left:25, right: 8, top: 8, bottom: 14),
                        child: Directionality(

                          textDirection:isEnglish(data[index].content!)?TextDirection.rtl:TextDirection.ltr,
                          child: ReadMoreText(
                           data[index].content!,
                            trimLines: 3,
                            trimMode: TrimMode.Line,
                            //textAlign: TextAlign.center,
                            colorClickableText: Colors.indigoAccent,
                            delimiter: " ..",
                            style: TextStyle(color:Theme.of(context).shadowColor,fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: ClipRRect(
                        child: data[index].image.isValid?
                        Container(
                          height: 190,
                          width: double.infinity,
                          child: GestureDetector(
                            child: Hero(
                              tag: "tag" + index.toString(),
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                imageUrl: data[index].image!,
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.repeat,
                                placeholder: (context, url) =>
                                    ColoredBox(
                                      color: Colors.grey,
                                    ),
                                errorWidget: (context, url, error) =>
                                    ColoredBox(
                                        color: Colors.grey,
                                        child: Icon(Icons.error)),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (
                                  BuildContext context) {
                                return ImageView(
                                  imageUrl: data[index].image!,
                                  index: index, key: UniqueKey(),
                                );
                              }));
                            },
                          ),
                        ) : data[index].video.isValid?
                        Container(
                            height: 200,
                            child: VdPlayer(dataSource: data[index].video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
                            : SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [



                          TextButton(
                              onPressed: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (BuildContext buildContext) =>
                                      CommentPage(postId:data[index].id!, focusty:false, commentsCount:data[index].commentsCount!,),);
                              },
                              child: Row(
                                children: [

                                  FaIcon(
                                    FontAwesomeIcons.solidComment,
                                    color:Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6, top: 6),
                                    child:data[index].commentsCount==0?SizedBox.shrink():Text(data[index].commentsCount.toString(), style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              )),
                          Container(
                            width: 2,
                          ),
                          LikeButton(
                            onTap:onTap,
                            isLiked: data[index].liked,
                            likeCount: data[index].likesCount==0?null:data[index].likesCount,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(index==data.length-1)
            Padding(
              padding: const EdgeInsets.only(top:6.0),
              child: Container(height: 80,
                color: Colors.transparent,
              ),
            ),
        ],
      );




  }
  Widget _postSettingSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*.3,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.white,),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
            ),
            InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      CircleAvatar(
                        radius: 15,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.add)),
                      Container(
                        width: 15,
                      ),
                      const Text("Unfollow",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.share_outlined)),
                      Container(
                        width: 15,
                      ),
                      const Text("Share",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.bookmark_border)),
                      Container(
                        width: 15,
                      ),
                      const Text("Saved",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.report_gmailerrorred_outlined)),
                      Container(
                        width: 15,
                      ),
                      const Text("Report",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }



}

