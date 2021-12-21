import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/models/challenge_model.dart';
import 'package:doitys/pages/add_new_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/extensions.dart';
import 'comment_page.dart';
import 'image_view.dart';
class Group extends StatefulWidget {
  final String? title;
  final Challenge challengeData;

  const Group({required Key key, this.title, required this.challengeData}) : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  ScrollController? _scrollController;
    final _postOfChallengeController=Get.put(PostController());
    final _currentAuthorController=Get.put(AuthorController());
    String? _currentAuthorId;
  @override
  void initState() {
    _scrollController = ScrollController();
    _currentAuthorId=_currentAuthorController.currentAuthor.id;
    _postOfChallengeController.getChallengePosts(widget.challengeData.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController!.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: () async {
        _postOfChallengeController.postOfChallenge.clear();
        _postOfChallengeController.postOfChallengeData.clear();
        _postOfChallengeController.postOfChallengeLoading(true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(icon:Icon(Icons.arrow_back,color:Theme.of(context).shadowColor ,) ,onPressed: (){
                  _postOfChallengeController.postOfChallenge.clear();
                  _postOfChallengeController.postOfChallengeData.clear();
                  _postOfChallengeController.postOfChallengeLoading(true);
                  Navigator.pop(context);
                },),
                backgroundColor:Theme.of(context).primaryColor,
                pinned:false,
                floating: true,
                expandedHeight: 300,
                actions: [
                  IconButton(
                      icon: Icon(Icons.more_vert,color:Theme.of(context).shadowColor),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return _bottomSheet(context);
                            });
                      }),
                  Container(
                    width: 10,
                  ),
                ],
                flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    systemNavigationBarColor:Theme.of(context).primaryColor,
                    statusBarColor: Colors.transparent,
                  ),
                  child: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius:const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 220,
                                color: Colors.blueGrey,
                                child:widget.challengeData.image != null? CachedNetworkImage(
                                  imageUrl:widget.challengeData.image!,
                                  fit: BoxFit.cover,
                                  repeat: ImageRepeat.repeat,
                                  placeholder: (context, url) => const ColoredBox(
                                    color: Colors.grey,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const ColoredBox(
                                          color: Colors.grey,
                                          child: Icon(Icons.error)),
                                ):
                                widget.challengeData.video!=null?VdPlayer(dataSource:widget.challengeData.video, dataSourceType: BetterPlayerDataSourceType.network):
                                const SizedBox.shrink(),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  height: 40,
                                  color:Theme.of(context).backgroundColor,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "  " +widget.challengeData.title.toString(),
                                      style: GoogleFonts.pacifico(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8),
                            child: Text("created by: "+widget.challengeData.creatorName.toString(),
                              style:const TextStyle(color:Colors.blue) ,),
                          ),
                          Container(
                            height: 10,
                          ),
                          SizedBox(
                            // numbers and members
                            height: 60,
                            width: double.infinity,
                            //color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        widget.challengeData.postsCount.toString(),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Posts',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.challengeData.membersCount.toString(),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Members',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.challengeData.startsAt!,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Start at',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.challengeData.days.toString(),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Days',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                    width: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              height: 2,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Obx(
              ()=>_postOfChallengeController.postOfChallengeLoading.value? const Center(child: CircularProgressIndicator(),):

              (_postOfChallengeController.postOfChallengeLoading.value==false&&_postOfChallengeController.postOfChallenge.isNotEmpty)?
              ListView.builder(
                itemCount: _postOfChallengeController.postOfChallenge.length,
                itemBuilder: (_, index) => _postView(context, index),
              ):const Center(child:Text(' no posts publish here yet \n be the first one to share a post '),),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.edit,color:Colors.black ,),
          onPressed: (){
            Navigator.of(context).push(bottomSideSlideTransition(GroupPost(GlobalKey(),challengeId:widget.challengeData.id )));
            /// pass here challenge id
          },
        ),
      ),
    );
  }

  Widget _postView(BuildContext context,int index) {


    Future<bool>onTap(bool value)async{
      if(value==true) {
        _postOfChallengeController.likePost(
            postId: _postOfChallengeController.postOfChallenge[index].id!, list: _postOfChallengeController.postOfChallenge, index: index);

      }else {
        _postOfChallengeController.unlikePost(
            postId: _postOfChallengeController.postOfChallenge[index].id!, list: _postOfChallengeController.postOfChallenge, index: index);

      }
      return !value;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Material(
            borderRadius:const BorderRadius.all(Radius.circular(12)),
            elevation:2,
            child: Container(
              decoration: BoxDecoration(
                //color: Color(0xfff4f0db), //Color(0xffFFFAF1),
                color: Theme.of(context).backgroundColor,
                borderRadius:const  BorderRadius.all(Radius.circular(12)),
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
                                        image: CachedNetworkImageProvider(_postOfChallengeController.postOfChallenge[index].creatorAvatar!),
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
                                  _postOfChallengeController.postOfChallenge[index].creatorDisplay!,
                                  style:const  TextStyle(fontSize: 18,),
                                ),
                                Text(
                                  _postOfChallengeController.postOfChallenge[index].creatorName!,
                                  style:const  TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 18, right: 8),
                        child: IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 30,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: false,
                                  context: context, builder: (BuildContext context) {
                                return _postSettingSheet(context, index);
                              });
                            }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left:25, right: 8, top: 8, bottom: 14),
                    child: Directionality(

                      textDirection:isEnglish(_postOfChallengeController.postOfChallenge[index].content!)?TextDirection.rtl:TextDirection.ltr,
                      child: ReadMoreText(
                        _postOfChallengeController.postOfChallenge[index].content!,
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        //textAlign: TextAlign.center,
                        colorClickableText: Colors.indigoAccent,
                        delimiter: " ..",
                        style: TextStyle(color:Theme.of(context).shadowColor,fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ClipRRect(
                      child: _postOfChallengeController.postOfChallenge[index].image.isValid?
                      SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: GestureDetector(
                          child: Hero(
                            tag: "tag" + index.toString(),
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: _postOfChallengeController.postOfChallenge[index].image!,
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.repeat,
                              placeholder: (context, url) =>
                                 const ColoredBox(
                                    color: Colors.grey,
                                  ),
                              errorWidget: (context, url, error) =>
                              const  ColoredBox(
                                      color: Colors.grey,
                                      child: Icon(Icons.error)),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (
                                BuildContext context) {
                              return ImageView(
                                imageUrl:_postOfChallengeController.postOfChallenge[index].image!,
                                index: index, key: UniqueKey(),
                              );
                            }));
                          },
                        ),
                      ) : _postOfChallengeController.postOfChallenge[index].video.isValid?
                         SizedBox(
                          height: 200,
                          child: VdPlayer(dataSource: _postOfChallengeController.postOfChallenge[index].video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
                          :const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet<dynamic>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (BuildContext buildContext) =>
                                  CommentPage(commentsCount:_postOfChallengeController.postOfChallenge[index].commentsCount!,
                                    postId:_postOfChallengeController.postOfChallenge[index].id!, focusty:false,),);
                          },
                          child: Row(
                            children: [

                              const  FaIcon(
                                FontAwesomeIcons.solidComment,
                                color:Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6, top: 6),
                                child:_postOfChallengeController.postOfChallenge[index].commentsCount==0?const SizedBox.shrink():Text(_postOfChallengeController.postOfChallenge[index].commentsCount.toString(), style: const TextStyle(
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
                        isLiked:_postOfChallengeController.postOfChallenge[index].liked,
                        likeCount: _postOfChallengeController.postOfChallenge[index].likesCount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if(index==_postOfChallengeController.postOfChallenge.length-1)
          Padding(
            padding: const EdgeInsets.only(top:6.0),
            child: Container(height: 80,
              decoration: const BoxDecoration(
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
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
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
                child: SizedBox(
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
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black12,
                          ),
                          child:const Icon(Icons.share_outlined)),
                      Container(
                        width: 15,
                      ),
                      const Text("Share",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  ///report this post post

                },
                child: SizedBox(
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
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black12,
                          ),
                          child:const Icon(Icons.report_gmailerrorred_sharp)),
                      Container(
                        width: 15,
                      ),
                      const Text("Report",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            (widget.challengeData.creatorId==_currentAuthorId)?InkWell(
                onTap: () {
                  ///remove this post from this group
                  ///only the creator of challenge can do this
                  ///chek for the id of current author == the challenge creator

                },
                child: SizedBox(
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
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black12,
                          ),
                          child:const Icon(Icons.remove_circle_outline_sharp)),
                      Container(
                        width: 15,
                      ),
                      const Text("Remove",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )):const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius:const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      height: MediaQuery.of(context).size.height * .23,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
            ),

            InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      const  Icon(Icons.share_outlined),
                      Container(
                        width: 15,
                      ),
                      const Text("Share",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      const Icon(Icons.outbond_outlined),
                      Container(
                        width: 15,
                      ),
                      const Text("Quite",style: TextStyle(fontSize: 24),),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                      ),
                      const Icon(Icons.report_gmailerrorred_outlined),
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
