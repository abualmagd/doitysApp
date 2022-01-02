import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/challenge_controller.dart';
import 'package:doitys/data_api/notification_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/formates/theme.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/joining_button.dart';
import 'package:doitys/pages/followers_post_page.dart';
import 'package:doitys/pages/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:doitys/formates/date_extension.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'image_view.dart';

class ChallengePage extends StatefulWidget {
  final scrollController;

  const ChallengePage({required Key key, this.scrollController}) : super(key: key);



  @override
  _ChallengePageState createState() => _ChallengePageState();
}


class _ChallengePageState extends State<ChallengePage> {
  @override
  void initState() {
    notificationController.onInit();
    super.initState();
  }

  var challengeControl=Get.put(ChallengeController());
  var notificationController=Get.put(NotificationController());
  var _authorControl=Get.put(AuthorController());

  Future getUserThenNavigate(var id)async{
    try {
      _authorControl.getUserView(id, _authorControl.currentAuthor.id).then((value) =>
          Navigator.of(context).push(rightCornerSideSlideTransition(Profile(GlobalKey(),value))),
      );
    }
    catch(r){
      Get.snackbar('sorry', 'error in loading user data ');
    }
  }


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          leading: IconButton(
              icon: Icon(Icons.scatter_plot_rounded,color:Theme.of(context).shadowColor),
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                   return PublicPostPage();
                 }));

                /*  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context){
                    return PublicPostPage();
                  }));*/
              }),
          actions: [
            IconButton(onPressed:() async {
            Get.changeTheme(Get.isDarkMode? Themes.light: Themes.dark);
              var _prefs=await SharedPreferences.getInstance();
              bool isDark=!Get.isDarkMode;
              print(isDark);
              _prefs.setBool('isDark', isDark);
            }, icon:Icon(Icons.nightlight_round,color:Theme.of(context).shadowColor))
          ],
          centerTitle: true,
          title: Text(
            "Doitys",
            style: GoogleFonts.pacifico(
              fontSize: 24,
                color:Theme.of(context).shadowColor,
            ),

          ),
          elevation: 2,
          backgroundColor: context.theme.primaryColor,
        ),
        ],
      body:RefreshIndicator(
          onRefresh: () async{await Future.delayed(Duration(seconds: 2),()=>print('refreshed'),);},
        child: Obx( ()=>challengeControl.isLoading.value?Center(child:CircularProgressIndicator(
            color: Colors.white,
          ),):ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder:(_, index) =>_challenge(context,index),
          itemCount: challengeControl.challengeList.length,
          )),
      )

    );
  }
  Widget _challenge(BuildContext context ,int index){
    var id=_authorControl.currentAuthor.id;
    var creatorId=challengeControl.challengeList[index].creatorId.toString();
    print(challengeControl.challengeList[index].image);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            elevation:2,
            child: Container(
              decoration: BoxDecoration(
                color:Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              width: double.infinity,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .height * .8,
                      child: ClipRRect(
                        child: challengeControl.challengeList[index].video!=null?
                        Container(
                            height: 200,
                            child: VdPlayer(key:GlobalKey(),dataSource: challengeControl.challengeList[index].video!, dataSourceType:BetterPlayerDataSourceType.network ))
                            :challengeControl.challengeList[index].image!=null?
                        Container(
                          height: 190,
                          child: GestureDetector(
                            child: Hero(
                              tag: "tag" + index.toString(),
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                imageUrl:challengeControl.challengeList[index].image!,
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ImageView(
                                      key: UniqueKey(),
                                      imageUrl:challengeControl.challengeList[index].image!,
                                      index: index,
                                    );
                                  }));
                            },
                          ),
                        ) : SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: (){
                      (id!=creatorId)
                          ?

                     getUserThenNavigate(challengeControl.challengeList[index].creatorId):print('nothing');
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 8),
                          child: Container(
                            width: 50,
                            height: 50,

                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              image: DecorationImage(
                                  image:CachedNetworkImageProvider(challengeControl.challengeList[index].creatorAvatar!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                challengeControl.challengeList[index].creatorDisplay!,
                                style: TextStyle(fontSize: 18, ),
                              ),
                              Text(
                                'creator',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Container(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * .9,
                      child: Directionality(
                        textDirection:isEnglish(challengeControl.challengeList[index].title!)?TextDirection.rtl:
                        TextDirection.ltr,
                        child: Text(
                          challengeControl.challengeList[index].title!,

                          style: TextStyle(
                            fontSize: 24,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12),
                    child: Container(
                      //height: 50,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * .90,
                      child: Directionality(
                        textDirection:isEnglish(challengeControl.challengeList[index].content!) ?TextDirection.rtl:
                        TextDirection.ltr,
                        child: ReadMoreText(
                          challengeControl.challengeList[index].content!,
                          trimMode: TrimMode.Line,
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                          trimLines: 5,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 70,
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
    challengeControl.challengeList[index].postsCount!.toString(),
                                //style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                height: 4,
                              ),
                              const Text(
                                'Posts',
                                //style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                challengeControl.challengeList[index].membersCount!.toString(),
                                //style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                height: 4,
                              ),
                              const Text(
                                'Members',
                                //style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                DateTime.parse(challengeControl.challengeList[index].startsAt!).readable,
                                //style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                height: 4,
                              ),
                              const Text(
                                'Start at',
                                //style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                challengeControl.challengeList[index].days!.toString(),
                                // style: TextStyle(color: Colors.black),
                              ),
                              Container(
                                height: 4,
                              ),
                              const Text(
                                'Days',
                                //style: TextStyle(color: Colors.grey),
                              ),

                            ],
                          ),
                          Container(
                            height: 6,
                            width: 6,
                          ),
                        ],
                      ),
                    ),
                  ),


                  JoiningButton(list:challengeControl.challengeList, challengeIndex: index,),

                  Container(
                    height: 10,
                  ),


                ],
              ),
            ),
          ),
        ),
        if(index==challengeControl.challengeList.length-1)
          Padding(
            padding: const EdgeInsets.only(top:6.0),
            child: Container(height: 80,
              color: Colors.transparent,
            ),
          ),
      ],
    );
  }
}
