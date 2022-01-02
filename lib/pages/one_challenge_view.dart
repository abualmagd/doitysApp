import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/challenge_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/joining_button.dart';
import 'package:doitys/pages/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/date_extension.dart';
import 'package:supabase/supabase.dart';
import 'image_view.dart';

class SingelChallenge extends StatefulWidget {
  final challengeId;
  const SingelChallenge({Key? key,required this.challengeId}) : super(key: key);

  @override
  _SingelChallengeState createState() => _SingelChallengeState();
}

class _SingelChallengeState extends State<SingelChallenge> {
  final _challengeController=Get.put(ChallengeController());
  final _client=Get.find<SupabaseClient>();
  final _authorControl=Get.put(AuthorController());
  var currentId;
  @override
  void initState() {
    currentId=_client.auth.currentUser!.id;
    _challengeController.getAChallenge(challengeId: widget.challengeId);
    super.initState();
  }
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back,
          color:Theme.of(context).shadowColor ,),onPressed:(){
          Navigator.pop(context);
        } ,),
        title: Text('A Challenge',style: TextStyle(color: Theme.of(context).shadowColor),),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: GetX<ChallengeController>(
          builder:(GetxController controller){
            if(_challengeController.loading.value==false){
              if(_challengeController.error.value==true) {
                return Center(child: Text('Error'),);
              }
              return SingleChildScrollView(
                child: Column(
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
                                    child: _challengeController.oneChallenge.video!=null?
                                    Container(
                                        height: 200,
                                        child: VdPlayer(key:GlobalKey(),dataSource: _challengeController.oneChallenge.video!, dataSourceType:BetterPlayerDataSourceType.network ))
                                        :_challengeController.oneChallenge.image!=null?
                                    Container(
                                      height: 190,
                                      child: GestureDetector(
                                        child: Hero(
                                          tag: "tag" +'12598',
                                          transitionOnUserGestures: true,
                                          child: CachedNetworkImage(
                                            imageUrl:_challengeController.oneChallenge.image!,
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
                                                  imageUrl:_challengeController.oneChallenge.image!,
                                                  index: 12598,
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
                                  (_challengeController.oneChallenge.creatorId!=currentId)
                                      ?getUserThenNavigate(_challengeController.oneChallenge.creatorId):print('nothing');
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
                                              image:CachedNetworkImageProvider(_challengeController.oneChallenge.creatorAvatar!),
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
                                            _challengeController.oneChallenge.creatorDisplay!,
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
                                    textDirection:isEnglish(_challengeController.oneChallenge.title!)?TextDirection.rtl:
                                    TextDirection.ltr,
                                    child: Text(
                                      _challengeController.oneChallenge.title!,

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
                                    textDirection:isEnglish(_challengeController.oneChallenge.content!) ?TextDirection.rtl:
                                    TextDirection.ltr,
                                    child: ReadMoreText(
                                      _challengeController.oneChallenge.content!,
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
                                            _challengeController.oneChallenge.postsCount!.toString(),
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
                                            _challengeController.oneChallenge.membersCount!.toString(),
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
                                            DateTime.parse(_challengeController.oneChallenge.startsAt!).readable,
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
                                            _challengeController.oneChallenge.days!.toString(),
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

                              (_challengeController.oneChallenge.joined==false)?
                              JoiningButton(list:[_challengeController.oneChallenge], challengeIndex:0,)
                               :Container(
                                height:40,
                                width: MediaQuery.of(context).size.width*.85,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                child: Center(child: Text('Joined')),
                              ),

                              Container(
                                height: 10,
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }
          ),

    );
  }
}

