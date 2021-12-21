import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/data_api/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';


class NotifyPage extends StatefulWidget {
  final controller ;

  const NotifyPage({required Key key, this.controller}) : super(key: key);


  @override
  _NotifyPageState createState() => _NotifyPageState();
}
class _NotifyPageState extends State<NotifyPage> {
  var notificationController=Get.put(NotificationController());


@override
void initState(){
  super.initState();
  if(notificationController.nonReadNotification.value==true){
  Future.delayed(Duration(microseconds: 300),()=>notificationController.updateReadingBool());
  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body:  NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) =>[
          SliverAppBar(
        centerTitle:true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Icon(Icons.notifications_active,color: Theme.of(context).shadowColor,),
            Text(
              "Notifications",
              style: GoogleFonts.pacifico(
                fontSize: 20,
                color: Theme.of(context).shadowColor,
              ),

            ),
          ],
        ),
        elevation: 2,
        backgroundColor:Theme.of(context).primaryColor,

          ),
          ],

       body:RefreshIndicator(
         onRefresh: () async{await Future.delayed(Duration(seconds: 2),()=>print('refreshed'),);},
         child: Obx(()=> notificationController.isLoading.value?Center(child:CircularProgressIndicator(),) :
         ListView.builder(
           padding: EdgeInsets.zero,
           itemBuilder: (_,index)=>_notifyItem(context,index),
                itemCount: notificationController.notificationsList.length,

            )),
       )

      ),
    );
  }

  Widget _notifyItem(BuildContext _,int index){
    var _list=notificationController.notificationsList;
    return Padding(
      padding: const EdgeInsets.only(top:8,left: 8,right: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width:double.infinity,
          decoration: BoxDecoration(
            color:Theme.of(context).backgroundColor,
            border: Border.all(color:_list[index].read!?Colors.transparent:Colors.blueGrey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top:14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                            image:CachedNetworkImageProvider(notificationController.notificationsList[index].actionUserAvatar!),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height:50,
                      width: 50,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top:14.0,left:8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                            text: (notificationController.notificationsList[index].actionUserName),
                            style:TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize:18,
                                color: Colors.blueGrey
                            ) ,
                            children: [
                              TextSpan(
                                  text: _list[index].type=='like'?(' liked your post'):_list[index].type=='comment'?(' comment on your post')
                                    :_list[index].type=='follow'?(' follows you'):_list[index].type=='like_comment'?(' liked your comment'):
                                  _list[index].type=='like_reply'?(' liked your reply'):(' mentioned you'),
                                  style: TextStyle(
                                    color:Colors.grey,
                                    fontSize:16,

                                  )
                              ),
                            ],
                          )),//name and the action of notified ,

                          Container(
                            width: 220,
                            child: Text( _list[index].type=='like'?(_list[index].postContent.toString()):_list[index].type=='comment'?(_list[index].commentContent.toString())
                                :_list[index].type=='follow'?(' \n '):_list[index].type=='like_comment'?(_list[index].commentContent.toString()):
                            _list[index].type=='like_reply'?(_list[index].replyContent.toString()):(' \n '),
                              style: TextStyle(fontSize:16),
                              overflow: TextOverflow.ellipsis,
                              maxLines:3,
                              textAlign: TextAlign.left,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text(_list[index].created!.toString(),
                              style: TextStyle(color: Colors.grey),),
                          ),
                          Container(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );


  }
}


