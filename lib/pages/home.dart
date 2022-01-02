
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/challenge_controller.dart';
import 'package:doitys/data_api/notification_controller.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/pages/challenges_timline.dart';
import 'package:doitys/pages/notify.dart';
import 'package:doitys/pages/add_new_challenge.dart';
import 'package:doitys/pages/profile_page.dart';
import 'package:doitys/pages/user_challenges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var getCon = Get.put(AuthorController());
  final _challengeController=Get.put(ChallengeController());
  final _notificationController=Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    getCon.getCurrentAuthor().then((value) {
      _challengeController.getAllChallenges();
    }).then((value) {
      _challengeController.getUserChallenge();
      _notificationController.fetchNotifications();
    });
     homeScrollController= ScrollController()..addListener(() {
       if(homeScrollController!.position.pixels+60>=homeScrollController!.position.maxScrollExtent){
         //_challengeController.getMoreChallenges();
       }
     });
  }

 int _currentIndex=0;

  ScrollController? homeScrollController;
  ScrollController userChallengeScrollController=ScrollController();
 ScrollController notifyController=ScrollController();
@override
void dispose(){
 homeScrollController!.dispose();
 userChallengeScrollController.dispose();
  notifyController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:Theme.of(context).primaryColor,
      ),
    );
    Color c=context.theme.focusColor;
    Color d=Colors.grey.shade500;
    List<Color> _homeColor=[c,d,d,d];
    List<Color> _challengeColor=[d,c,d,d];
    List<Color> _notifyColor=[d,d,c,d,];
    List<Color> _profileColor=[d,d,d,c];

    List _tabs=[
    ChallengePage(scrollController:homeScrollController!, key: UniqueKey(),),
    MyTimeLine(controller:userChallengeScrollController,key: UniqueKey()),
      NotifyPage(controller:notifyController, key: UniqueKey(),),
      const ProfilePage(),
  ];
return
  Builder(
    builder: (context){
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value:      SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor:Theme.of(context).primaryColor,
          ),
          child: Scaffold(
            // backgroundColor:Color(0xffdec19b),
            backgroundColor:context.theme.primaryColor,

            body:_tabs[_currentIndex],

            floatingActionButton:Material(
              elevation:2,
              color:context.theme.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(

                width: MediaQuery.of(context).size.width*.90,
                decoration: BoxDecoration(
                  color:context.theme.primaryColor,
                  borderRadius:const BorderRadius.all(Radius.circular(13)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: Icon(Icons.home,size:34,
                      color: _homeColor[_currentIndex],
                    ), onPressed:(){

                      if(_currentIndex==0){
                        homeScrollController!.animateTo(
                            0.0,
                            curve: Curves.bounceIn,
                            duration: const Duration(milliseconds: 300));
                      }
                      setState(() {
                        _currentIndex=0;
                      });
                    }),
                    IconButton(icon: FaIcon(FontAwesomeIcons.solidClone,size:24,
                      color: _challengeColor[_currentIndex],
                    ), onPressed:(){
                      if(_currentIndex==1){
                        userChallengeScrollController.animateTo(
                            0.0,
                            curve: Curves.bounceIn,
                            duration: const Duration(milliseconds: 300));
                      }
                      setState(() {
                        _currentIndex=1;
                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.only(bottom:5.0),
                      child: IconButton(icon: const FaIcon(FontAwesomeIcons.solidPlusSquare,size:36,), onPressed:(){

                        Navigator.of(context).push(bottomSideSlideTransition(const AddingNew()));
                      }),
                    ),
                    Stack(
                      children: [
                        IconButton(icon: FaIcon(FontAwesomeIcons.solidBell,size:26,
                          color: _notifyColor[_currentIndex],
                        ), onPressed:(){
                          if(_currentIndex==2){
                            notifyController.animateTo(
                                0.0,
                                duration:const Duration(milliseconds: 300), curve: Curves.bounceIn);
                          }
                          setState(() {
                            _currentIndex=2;
                          });

                        }),
                        Obx(()=> _notificationController.nonReadNotification.value?Positioned(
                            top: 10,
                            right: 10,
                            child:Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.pink,
                              ),
                            )

                        ):const SizedBox.shrink(),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:4),
                      child: IconButton(icon: FaIcon(FontAwesomeIcons.userAlt,size: 26,
                        color: _profileColor[_currentIndex],

                      ), onPressed:(){

                        setState(() {
                          _currentIndex=3;
                        });

                      }),
                    ),
                  ],
                ),
              ),
            ),
          ));
    },
  );
  }




}



