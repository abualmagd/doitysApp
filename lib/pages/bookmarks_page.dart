import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/global/better_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/extensions.dart';
import 'package:get/get.dart';
import 'comment_page.dart';
import 'image_view.dart';

class BookMarks extends StatefulWidget {
  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  var bookmarksController=Get.put(PostController());
  @override
  void initState() {

    bookmarksController.getBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(
              "Your Bookmarks",
              style: GoogleFonts.pacifico(
                fontSize: 20,
                color: Theme.of(context).shadowColor,
              ),

            ),
            elevation: 2,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          Obx(
              ()=>bookmarksController.bookmarksLoading.value? SliverFillRemaining(child: Center(child: CircularProgressIndicator(),)):

             bookmarksController.userBookmarks.length>0?
              SliverList(

              delegate: SliverChildBuilderDelegate(

                    (_, index) => _postView(context, index),
                childCount:bookmarksController.userBookmarks.length,

              ),

            ):SliverFillRemaining(child:Center(child:Text('you have no bookmarks'),)),
          ),
        ],
      ),
    );

  }

  Widget _postView(BuildContext context,int index) {


    Future<bool>onTap(bool value)async{
      if(value==true) {
        bookmarksController.likePost(
            postId: bookmarksController.userPostList[index].id!, list: bookmarksController.userBookmarks, index: index);

      }else {
        bookmarksController.unlikePost(
            postId: bookmarksController.userBookmarks[index].id!, list: bookmarksController.userBookmarks, index: index);

      }
      return !value;
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
                                        image: CachedNetworkImageProvider(bookmarksController.userBookmarks[index].creatorAvatar!),
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
                                  bookmarksController.userBookmarks[index].creatorDisplay!,
                                  style: TextStyle(fontSize: 18,),
                                ),
                                Text(
                                  bookmarksController.userBookmarks[index].creatorName!,
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
                                return _postSettingSheet(context,index);
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

                        textDirection:isEnglish(bookmarksController.userBookmarks[index].content!)?TextDirection.rtl:TextDirection.ltr,
                        child: ReadMoreText(
                          bookmarksController.userBookmarks[index].content!,
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
                      child: bookmarksController.userBookmarks[index].image.isValid?
                      Container(
                        height: 190,
                        width: double.infinity,
                        child: GestureDetector(
                          child: Hero(
                            tag: "tag" + index.toString(),
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: bookmarksController.userBookmarks[index].image!,
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
                                imageUrl: bookmarksController.userBookmarks[index].image!,
                                index: index, key: UniqueKey(),
                              );
                            }));
                          },
                        ),
                      ) : bookmarksController.userBookmarks[index].video.isValid?
                      Container(
                          height: 200,
                          child: VdPlayer(dataSource: bookmarksController.userBookmarks[index].video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
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
                                    CommentPage(commentsCount:bookmarksController.userBookmarks[index].commentsCount!,
                                      postId: bookmarksController.userBookmarks[index].id!, focusty:false,),);
                            },
                            child: Row(
                              children: [

                                FaIcon(
                                  FontAwesomeIcons.solidComment,
                                  color:Colors.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 6),
                                  child:bookmarksController.userBookmarks[index].commentsCount==0?SizedBox.shrink():Text(bookmarksController.userBookmarks[index].commentsCount.toString(), style: TextStyle(
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
                          isLiked:bookmarksController.userBookmarks[index].liked,
                          likeCount: bookmarksController.userBookmarks[index].likesCount,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if(index==bookmarksController.userBookmarks.length-1)
          Padding(
            padding: const EdgeInsets.only(top:6.0),
            child: Container(height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                    
              ),
              
            ),
          ),
      ],
    );




  }

  Widget _postSettingSheet(BuildContext context,int index) {
    return Container(
      height: MediaQuery.of(context).size.height*.20,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
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
              height: 5,
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
                      Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.amber,
                            ),
                          child: Icon(Icons.share_outlined)),
                      Container(
                        width: 15,
                      ),
                      const Text("Share",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  ///un bookmark a post
                  bookmarksController.removeBookMark(bookmarksController.userBookmarks[index].id);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.amber,
                          ),
                          child: Icon(Icons.delete_forever_outlined)),
                      Container(
                        width: 15,
                      ),
                      const Text("Remove",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
