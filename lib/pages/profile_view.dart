
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/formates/number_formates.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/profile_background_path.dart';
import 'package:doitys/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'comment_page.dart';
import 'image_view.dart';
import 'package:get/get.dart';
import 'package:doitys/formates/date_extension.dart';

class Profile extends StatefulWidget{
  final Author user;
  const Profile(Key? key ,this.user):super(key:key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

final numberFormatting=NumberFormatting();
final _postController =Get.put(PostController());
@override
  void initState() {
    _postController.getAuthorViewPosts(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _followers =
  numberFormatting.compact(widget.user.followerCount ?? 0);
  String _following =
  numberFormatting.compact(widget.user.followingCount?? 0);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext _,bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              excludeHeaderSemantics: true,
              backgroundColor:Theme.of(context).primaryColor,
              pinned: true,
              floating: false,
              leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){

                Navigator.pop(context);
              },),
              flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  systemNavigationBarColor:Color(0xfff4f0db),
                  statusBarColor: Colors.transparent,
                ),
                child: FlexibleSpaceBar(
                  background: Material(
                    elevation: .5,
                    child: Container(
                      color: context.theme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 160, //photo area
                            child: Stack(children: [
                              CurvedGround(
                                height: 145.0,
                                //photo back container
                                width: double.infinity,
                                color:context.theme.primaryColor, key: UniqueKey(),

                              ),
                              Positioned(
                                left:MediaQuery.of(context).size.width*.30,
                                top:30,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                        return ImageView(
                                            imageUrl:widget.user.avatar,
                                            index: "0",
                                            key: UniqueKey()
                                        );
                                      }));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: SizedBox(
                                        child: Hero(
                                          tag: "tag" + "2323232".toString(),
                                          transitionOnUserGestures: true,
                                          child:CachedNetworkImage(
                                            imageUrl:
                                            widget.user.avatar!=null?widget.user.avatar!:' ',
                                            fit: BoxFit.cover,
                                            repeat: ImageRepeat.repeat,
                                            placeholder: (context, url) =>
                                             const   ColoredBox(
                                                  color: Colors.grey,
                                                ),
                                            errorWidget: (context, url,
                                                error) =>
                                             const   ColoredBox(
                                                    color: Colors.grey,
                                                    child: Icon(
                                                        Icons.error)),
                                          ),
                                        ),
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            widget.user.display!=null?widget.user.display!:'',
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                            height: 2,
                                          ),
                                         FollowingButton(followed: widget.user.followed!,userId:  widget.user.id!,),


                                        ],
                                      ),
                                    ),
                                    Text(
                                      widget.user.name!,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12,left: 12),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:4,bottom: 4),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*.80,
                                        child: Text(
                                          widget.user.bio!=null?widget.user.bio!:"",
                                          style: const TextStyle(fontSize: 15),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 4,
                              ),
                              Row(
                                children: [
                                const  Padding(
                                    padding:
                                    EdgeInsets.only(left: 12, right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                    ),
                                  ),
                                Text(
                                    "joined "+widget.user.created.readable,
                                    style:const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                                width: 6,
                              ),
                              SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 12, right: 7, top: 6),
                                      child: Icon(
                                        Icons.link,
                                        size: 14,
                                      ),
                                    ),
                                    Text(
                                      widget.user.website!=null? widget.user.website!:'',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, bottom: 8, right: 8, top: 8),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(_followers),
                                        Container(
                                          width: 6,
                                        ),
                                        const Text(
                                          "Followers",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 14,
                                    ),
                                    Row(
                                      children: [
                                        Text(_following),
                                        Container(
                                          width: 6,
                                        ),
                                        const Text(
                                          "Following",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:5,
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              expandedHeight: 320,
            ),
          ];
        },
        body:GetX<PostController>(
          builder: (GetxController controller) {
            if(_postController.looding.value==true){
              return const Center(child: CircularProgressIndicator());
            }else {
              if (_postController.error.value != true) {
                return MediaQuery.removePadding(
                  removeTop: true,

                  ///fucken error fuck fuck
                  context: context,
                  child: ListView.builder(

                    itemBuilder: (BuildContext context, int index) =>
                        _postView(context, index, _postController.posts),
                    itemCount: _postController.posts.length,

                  ),
                );

              }
              return const Center(child: Text('error'));
            }
          },),



      ),
    );
  }

Widget _postView(BuildContext context,int index,var snapshot) {
  ///change future builder by getxcontroller
  ///to not building every time

  Future<bool>onTap(bool value)async{
    if(value!=true) {
      _postController.likePost(
          postId: snapshot[index].id!, list: snapshot, index: index);

    }else {
      _postController.unlikePost(
          postId: snapshot[index].id!, list: snapshot, index: index);

    }
    return !value;
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          elevation:2,
          child: Container(
            decoration: BoxDecoration(
              //color: Color(0xfff4f0db), //Color(0xffFFFAF1),
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                                      image: CachedNetworkImageProvider(widget.user.avatar!),
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
                                widget.user.display!,
                                style: const TextStyle(fontSize: 18,),
                              ),
                              Text(
                                widget.user.name!,
                                style: const TextStyle(color: Colors.grey),
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
                              return _postSettingSheet(context);
                            });
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left:25, right: 8, top: 8, bottom: 14),
                  child: Directionality(

                    textDirection:isEnglish(snapshot[index].content!)?TextDirection.rtl:TextDirection.ltr,
                    child: ReadMoreText(
                      snapshot[index].content!,
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
                    child: snapshot[index].image!=null?
                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: GestureDetector(
                        child: Hero(
                          tag: "tag" + index.toString(),
                          transitionOnUserGestures: true,
                          child: CachedNetworkImage(
                            imageUrl: snapshot[index].image!,
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeat,
                            placeholder: (context, url) =>
                                const ColoredBox(
                                  color: Colors.grey,
                                ),
                            errorWidget: (context, url, error) =>
                                const ColoredBox(
                                    color: Colors.grey,
                                    child: Icon(Icons.error)),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              BuildContext context) {
                            return ImageView(
                              imageUrl: snapshot.data[index].image!,
                              index: index, key: UniqueKey(),
                            );
                          }));
                        },
                      ),
                    ) : snapshot[index].video!=null?
                    SizedBox(
                        height: 200,
                        child: VdPlayer(dataSource: snapshot[index].video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
                        : const SizedBox.shrink(),
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
                                CommentPage(commentsCount:snapshot[index].commentsCount, postId:snapshot[index].id, focusty: false,),);
                        },
                        child: Row(
                          children: [

                            const FaIcon(
                              FontAwesomeIcons.solidComment,
                              color:Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, top: 6),
                              child:snapshot[index].commentsCount==0?const SizedBox.shrink():Text(snapshot[index].commentsCount.toString(), style: const TextStyle(
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
                      isLiked: snapshot[index].liked,
                      likeCount: snapshot[index].likesCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      if(index==snapshot.length-1)
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
                    const CircleAvatar(
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
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    const CircleAvatar(
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
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                    ),
                    const CircleAvatar(
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

class FollowingButton extends StatefulWidget {
  final String userId;
  final bool followed;
  const FollowingButton({Key? key, required this.userId, required this.followed}) : super(key: key);

  @override
  _FollowingButtonState createState() => _FollowingButtonState();
}

class _FollowingButtonState extends State<FollowingButton> {

  final _authorController=Get.put(AuthorController());
  var _followed=false;
  @override
  void initState() {
    _followed=widget.followed;
   
    super.initState();
  }

  onTap(){
    setState(() {
      _followed=!_followed;
    });
  }


  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.only(right:8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds:200),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              if(_followed){
                print('unfollow');
                _authorController.unfollow(widget.userId);
                  onTap();



              }else{
                print('**follow');
                _authorController.follow(widget.userId);
               onTap();


              }
            },
            child: Ink(
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color:_followed?const Color(0xfff4f0db):Colors.blue,/// following or non followed
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white
                ),
              ),
              child: Center(child:_followed?const Text("Following",style: TextStyle(
                fontSize:16,
              ),):const Text("Follow",style: TextStyle(
                fontSize:18,
              ),)),
            ),
          ),
        ),
      ),
    );
  }

}
