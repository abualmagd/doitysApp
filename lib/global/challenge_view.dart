
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/global/joining_button.dart';
import 'package:doitys/pages/image_view.dart';
import 'package:doitys/pages/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/date_extension.dart';

import 'better_player.dart';



class ChallengeView extends StatelessWidget {
  final int challengeIndex;
  final List list;
  
  const ChallengeView({Key? key, required this.challengeIndex, required this.list}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    var _authorControl=Get.put(AuthorController());
    var id=_authorControl.currentAuthor.id;
    var creatorId=list[challengeIndex].creatorId.toString();
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
                        child:list[challengeIndex].image!=null?
                        Container(
                          height: 190,
                          child: GestureDetector(
                            child: Hero(
                              tag: "tag" + challengeIndex.toString(),
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                imageUrl:list[challengeIndex].image!,
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
                                      imageUrl:list[challengeIndex].image!,
                                      index: challengeIndex,
                                    );
                                  }));
                            },
                          ),
                        ) : (list[challengeIndex].image==null&&list[challengeIndex].video!=null)?
                        Container(
                            height: 200,
                            child: VdPlayer(key:GlobalKey(), dataSourceType: BetterPlayerDataSourceType.network, dataSource:list[challengeIndex].video, ))
                            : SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  InkResponse(
                    onTap: (){
                      (id!=creatorId)
                      ?getUserThenNavigate(list[challengeIndex].creatorId!):print('nothing');//this user id  اعمل صفحة تانية غير دي
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
                                  image:CachedNetworkImageProvider(list[challengeIndex].creatorAvatar!),
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
                                 list[challengeIndex].creatorDisplay!,
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
                       textDirection:isEnglish(list[challengeIndex].title!)?TextDirection.rtl:
                        TextDirection.ltr,
                        child: Text(
                        list[challengeIndex].title!,

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
                        textDirection:isEnglish(list[challengeIndex].content!) ?TextDirection.rtl:
                        TextDirection.ltr,
                        child: ReadMoreText(
                         list[challengeIndex].content!,
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
                               list[challengeIndex].postsCount!.toString(),
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
                                list[challengeIndex].membersCount!.toString(),
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
                              DateTime.parse(list[challengeIndex].startsAt!).readable,
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
                              list[challengeIndex].days!.toString(),
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


                  JoiningButton(list: list, challengeIndex: challengeIndex,),

                  Container(
                    height: 10,
                  ),


                ],
              ),
            ),
          ),
        ),
        if(challengeIndex==list.length-1)
          Padding(
            padding: const EdgeInsets.only(top:6.0),
            child: Container(height: 80,
            color: Theme.of(context).canvasColor,
            ),
          ),
      ],
    );
  }
}
