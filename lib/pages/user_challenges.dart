import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/challenge_controller.dart';
import 'package:doitys/pages/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';
import 'challenge_group.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/formates/date_extension.dart';

class MyTimeLine extends StatefulWidget {
  final controller;

  const MyTimeLine({required Key key, this.controller}) : super(key: key);

  @override
  _MyTimeLineState createState() => _MyTimeLineState();
}

class _MyTimeLineState extends State<MyTimeLine> {
 var challengeController=Get.put(ChallengeController());

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) =>[
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: IconButton(
                  icon: Icon(Icons.search,color: Theme.of(context).shadowColor,),
                  onPressed: () {
                      Navigator.of(context).push(rightSideSlideTransition(SearchPage()));
                  }),
            ),
            centerTitle: true,
            title: Text(
              "Your Challenges",
              style: GoogleFonts.pacifico(
                fontSize: 20,
                color: Theme.of(context).shadowColor,
              ),
            ),
            elevation: 2,
            backgroundColor:Theme.of(context).primaryColor,
          ),
        ],
        body:RefreshIndicator(
          onRefresh: () async{await Future.delayed(Duration(seconds: 2),()=>print('refreshed'),);},
          child: Obx(()=>  challengeController.isLoading.value?Center(child: CircularProgressIndicator(),)
               :challengeController.userChallengeList.isNotEmpty?ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder:(_, index) => _userChallenge(context, index),
              itemCount: challengeController.userChallengeList.length,
            ):Center(child:Text('    nothing to show yet \n'
               'your challenges will be here'),),

           ),
        ),

      ),
    );
  }
  Widget _userChallenge(BuildContext context,int index){
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right:2,left: 2,top: 8),
          child: InkWell(
            onTap: (){
              Navigator.of(context).push(rightSideSlideTransition(Group(key: UniqueKey(), challengeData:challengeController.userChallengeList[index],)));
              print("open challenge group"+" $index");
            },
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                width:MediaQuery.of(context).size.width*.97,
                decoration: BoxDecoration(
                  color:  Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                 // border: Border.all(color:Colors.green,width:2),
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12,right: 8,left:12),
                        child: Text(
                          challengeController.userChallengeList[index].title!,
                          textDirection: challengeController.userChallengeList[index].title!.isEnglish?TextDirection.rtl:TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 24,

                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24,top:8),
                          child: ReadMoreText(
                            challengeController.userChallengeList[index].content!,
                            textDirection: challengeController.userChallengeList[index].content!.isEnglish?TextDirection.rtl:TextDirection.ltr,
                            style: TextStyle(fontSize: 16,color: Colors.amber),
                            trimLines: 5,
                            trimMode: TrimMode.Line,
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
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
                                      challengeController.userChallengeList[index].membersCount.toString(),

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
                                    challengeController.userChallengeList[index].postsCount.toString(),

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
                                  DateTime.parse(challengeController.userChallengeList[index].startsAt!).readable,

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
                                      challengeController.userChallengeList[index].days!.toString(),

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
                              Container(
                                height:6,
                                width: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

              ),
            ),
          ),
        ),
        if(index==challengeController.userChallengeList.length-1)
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
}
