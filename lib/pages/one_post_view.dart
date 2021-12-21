import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/global/better_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';

import 'comment_page.dart';
import 'image_view.dart';


class PostPage extends StatefulWidget{
  final postId;
  PostPage(Key? key,this.postId):super(key:key);
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
 final _postController=Get.put(PostController());
  @override
  void initState() {
    _postController.getAPost(postId: widget.postId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.blue,onPressed: (){
          Navigator.pop(context);
        },),
        title: Text('A Post',style: TextStyle(color: Colors.blue),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetX<PostController>(
          builder:(GetxController controller){
            if(_postController.loodingPost.value==true) {
              if (_postController.errorPost.value == true) {
                return Center(child: Text('Error'),);
              }
              return Center(child: CircularProgressIndicator(),);
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
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(_postController.onePost.creatorAvatar!),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.circular(15),
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
                                          _postController.onePost.creatorDisplay!,
                                          style: TextStyle(fontSize: 18,),
                                        ),
                                        Text(
                                          _postController.onePost.creatorName!,
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

                                textDirection:isEnglish(_postController.onePost.content!)?TextDirection.rtl:TextDirection.ltr,
                                child: ReadMoreText(
                                  _postController.onePost.content!,
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
                              child: _postController.onePost.image!=null?
                              Container(
                                height: 190,
                                width: double.infinity,
                                child: GestureDetector(
                                  child: Hero(
                                    tag: "tag" +_postController.onePost.image.toString(),
                                    transitionOnUserGestures: true,
                                    child: CachedNetworkImage(
                                      imageUrl:_postController.onePost.image!,
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
                                        imageUrl: _postController.onePost.image!,
                                        index: _postController.onePost.image, key: UniqueKey(),
                                      );
                                    }));
                                  },
                                ),
                              ) : _postController.onePost.video!=null?
                              Container(
                                  height: 200,
                                  child: VdPlayer(dataSource: _postController.onePost.video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
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
                                            CommentPage(focusty: false, postId: _postController.onePost.id!, commentsCount: _postController.onePost.commentsCount!),);
                                    },
                                    child: Row(
                                      children: [

                                        FaIcon(
                                          FontAwesomeIcons.solidComment,
                                          color:Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6, top: 6),
                                          child:_postController.onePost.commentsCount==0?SizedBox.shrink():Text(_postController.onePost.commentsCount.toString(), style: TextStyle(
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
                                  isLiked: _postController.onePost.liked,
                                  likeCount: _postController.onePost.likesCount,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
 Future<bool>onTap(bool value)async{
   if(value!=true) {
     _postController.likePost(
         postId: _postController.onePost.id!, list: [_postController.onePost], index:0);

   }else {
     _postController.unlikePost(
         postId:_postController.onePost.id!, list: [_postController.onePost], index:0);

   }
   return !value;
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