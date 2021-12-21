import 'package:doitys/data_api/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class JoiningButton extends StatefulWidget {
  final list;
  final challengeIndex;
  const JoiningButton({Key? key,required this.list,required this.challengeIndex}) : super(key: key);

  @override
  _JoiningButtonState createState() => _JoiningButtonState();
}

class _JoiningButtonState extends State<JoiningButton> {
 var _challengeController=Get.put(ChallengeController());
  @override
  Widget build(BuildContext context) {
    bool _active=DateTime.parse(widget.list[widget.challengeIndex].endsAt).difference(DateTime.now()).inDays>=0;
    return Material(
      elevation:_active?2:0,
      borderRadius: BorderRadius.circular(15),
      child: _active?InkWell(
        onTap:() {

          print("tapped");
          _challengeController.joinToChallenge(widget.list[widget.challengeIndex]);

          //join the user to the challenge is the challenge not started yet
          // if the challenge active open the challenge page if the user is joiner to this group he can
          //write comment likes leave
          //if the user not joiner he can only like
        },
        child: Ink(
          width: MediaQuery
              .of(context)
              .size
              .width * .90,
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // if active color green
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue)
          ),
          child: Center(
            child:Obx(()=>_challengeController.joining.value=='wait'?Text(
              'Join',
              style: TextStyle(fontSize: 24,
                  letterSpacing: 2),
            ):_challengeController.joining.value=='start'?CircularProgressIndicator(strokeWidth:2,):
            _challengeController.joining.value=='success'?Text('Joined',style:TextStyle(fontSize: 24,
                letterSpacing: 2),): _challengeController.joining.value=='failed'?Text('sorry something wrong'):SizedBox.shrink(),
            ),
          ), //or active if the challenge started
        ),
      ):Ink(
        width: MediaQuery
            .of(context)
            .size
            .width * .90,
        height: 50,
        child: Center(
            child: Text(
              'Closed',
              style: TextStyle(fontSize: 24,
                  letterSpacing: 2),
            )), //or active if the challenge started
      ),
    );
  }
}
