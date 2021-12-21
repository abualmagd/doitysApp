import 'package:doitys/data_api/challenge_controller.dart';
import 'package:doitys/data_api/data.dart';
import 'package:doitys/global/date_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:better_player/better_player.dart';

import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/video_image_controller.dart';
import 'package:doitys/models/challenge_model.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doitys/formates/date_extension.dart';


    class AddingNew extends StatefulWidget {
  const AddingNew({Key? key}) : super(key: key);

      @override
      _AddingNewState createState() => _AddingNewState();
    }

    class _AddingNewState extends State<AddingNew> with SingleTickerProviderStateMixin {
      File? _video;
      final picker = ImagePicker();

      Future getVideo() async {
        final pickedFile = await picker.getVideo(
            source: ImageSource.gallery, maxDuration: const Duration(minutes: 1));

        setState(() {
          if (pickedFile != null) {
            _video = File(pickedFile.path);

          } else {

          }
        });
      }

      File? _image;

      Future getImage() async {
        final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
            _video = null;
          } else {

          }
        });
      }


      TextEditingController? _titleController;
      TextEditingController? _contentController;

      DataServices api=DataServices();
      final con=Get.put(DateController());
      final _challengeController=Get.put(ChallengeController());


      @override
      void initState() {
        super.initState();

        _titleController = TextEditingController();
        _contentController =TextEditingController();
      }

      @override
      void dispose() {

        _contentController!.dispose();
        _titleController!.dispose();
        super.dispose();
      }
      @override
      Widget build(BuildContext context) {
        var vic=Get.put(ViController());
        return WillPopScope(

          onWillPop: () async{
            if(_contentController!.text.isNotEmpty||_titleController!.text.isNotEmpty||_image!=null||_video!=null){
           return showAlertD(context);
            }
           return true;
            },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:Theme.of(context).primaryColor,
              title: Text("Create New Challenge",
                style: GoogleFonts.pacifico(
                  fontSize: 20,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              leading: IconButton(icon:Icon(Icons.arrow_back,color:Theme.of(context).shadowColor ,) ,onPressed: (){
                if(_contentController!.text.isNotEmpty||_titleController!.text.isNotEmpty||_image!=null||_video!=null){
                  FocusScope.of(context).unfocus();
                  showAlertD(context);
                }
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },),

            ),
            body: SingleChildScrollView(
              child: Material(
                elevation: 1,
                child: Container(
                  color: context.theme.backgroundColor,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color:Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 80,
                          width: MediaQuery.of(context).size.height * .70,

                          child: TextFormField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced
                            , controller: _titleController,
                            maxLines: 2,
                            maxLength: 100,
                            decoration:const InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              focusColor: Colors.red,
                              border: InputBorder.none,
                              hintText: "The title of your challenge ",
                            ),

                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color:Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: MediaQuery.of(context).size.height * .70,
                          child: TextFormField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLines: 8,
                            maxLength: 180,
                            controller: _contentController,
                            decoration:const InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              focusColor: Colors.red,
                              border: InputBorder.none,
                              hintText: "The description of your challenge ",
                            ),

                          ),
                        ),

                      ),
                      (_image == null && _video == null)
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding:const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 150,
                            width: MediaQuery.of(context).size.height * .70,
                            child: Center(
                              child: IconButton(
                                  icon:const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: SizedBox(
                                          height: 40,
                                          width: 60,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(child:const Text('Video'),onPressed: (){
                                                getVideo();
                                                Navigator.pop(context);
                                              },),
                                             const Text('or'),
                                              TextButton(child:const Text('Image'),onPressed: (){
                                                getImage();
                                                Navigator.pop(context);
                                              },),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )),
                      )
                          : (_image != null && _video == null)
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              padding:const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image!), fit: BoxFit.cover),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 150,
                              width: MediaQuery.of(context).size.height * .70,
                            ),
                            Positioned(
                                right: 0,
                                top:0,
                                child: IconButton(
                                  icon: Container(
                                      decoration:const BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),

                                      child:const Icon(Icons.close)),

                                  onPressed: (){
                                    setState(() {
                                      _image=null;
                                    });
                                  },
                                )),
                          ],
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 200,
                                  width:
                                  MediaQuery.of(context).size.height * .70,
                                  child: VdPlayer(
                                    key:GlobalKey(),
                                    dataSource: _video!.path,
                                    dataSourceType:
                                    BetterPlayerDataSourceType.file,
                                  )),
                            ),
                            Positioned(
                                right: 0,
                                top:0,
                                child: IconButton(
                                  icon: Container(
                                      decoration:const BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),

                                      child:const Icon(Icons.close)),

                                  onPressed: (){
                                    setState(() {
                                      _video=null;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                      Row(
                        //date selecting row
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child:  Text(
                                    'StartsAt',
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.blue),
                                      ),
                                      child: Center(child: Obx(()=> Text(con.startDate.readable))),
                                    ),
                                    IconButton(
                                        icon:const FaIcon(FontAwesomeIcons.calendarPlus),
                                        onPressed: () {

                                          _selectStartDate(context);

                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             const   Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'EndsAt',
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.blue),
                                      ),
                                      child: Center(child: Obx(()=> Text(con.endDate.readable))),
                                    ),
                                    IconButton(
                                        icon:const FaIcon(FontAwesomeIcons.calendarPlus),
                                        onPressed: () {
                                          _selectEndDate(context);

                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          elevation: 2,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {


                              if(_contentController!.text.isNotEmpty&&_titleController!.text.isNotEmpty) {
                                Navigator.pop(context);
                                if(_image!=null){
                                  //upload image if image not null
                                  String? _imageUrl;
                                  api.uploadImage(file: _image!, bucket:'images').then((value) {

                                    vic.updateImageUrl(value);
                                    print(vic.imageUrl);


                                  }).whenComplete(() {

                                    print(_imageUrl);
                                    Challenge ch = Challenge(
                                      title: _titleController!.text.toString(),
                                      content: _contentController!.text.toString(),
                                      image: vic.imageUrl,
                                      days: con.endDate.difference(con.startDate).inDays,
                                      endsAt: con.endDate.readable,
                                      startsAt: con.startDate.readable,
                                    );
                                    _challengeController.add(ch).then((value){

                                      Get.snackbar("hi", "your challenge created ");
                                    })
                                        .catchError((r) {
                                      Get.snackbar("hi", r.toString(),
                                          backgroundColor: Colors.red);
                                    });});

                                }else if(_video!=null&&_image==null){
                                  //upload video if video not null
                                  api.uploadImage(file: _video!, bucket: 'videos').then((value) {
                                    vic.updateVideoUrl(value);
                                  }).whenComplete(() {

                                    Challenge ch = Challenge(
                                      title: _titleController!.text.toString(),
                                      content: _contentController!.text.toString(),
                                      video: vic.videoUrl,
                                      days: con.endDate.difference(con.startDate).inDays,
                                      endsAt: con.endDate.readable,
                                      startsAt: con.startDate.readable,
                                    );
                                    _challengeController.add(ch).then((value) {

                                      Get.snackbar("hi", "your challenge created ");

                                    }).catchError((er){
                                      Get.snackbar("sorry", er.toString(),backgroundColor: Colors.red);
                                    });


                                  });


                                }else{

                                  Challenge ch = Challenge(
                                    title: _titleController!.text.toString(),
                                    content: _contentController!.text.toString(),
                                    days: con.endDate.difference(con.startDate).inDays,
                                    endsAt: con.endDate.readable,
                                    startsAt: con.startDate.readable,
                                  );


                                  _challengeController.add(ch).then((value) =>
                                      Get.snackbar("hi", "your challenge created "),
                                  )
                                      .catchError((r) {
                                    Get.snackbar("hi", r.toString(),
                                        backgroundColor: Colors.red);
                                  });

                                }

                              }
                            },

                            child: Ink(
                              width: MediaQuery.of(context).size.height * .60,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                color: context.theme.backgroundColor, // if active color green
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:const Center(
                                  child: Text(
                                    'Publish',
                                    style: TextStyle(
                                        fontSize: 24,  letterSpacing: 2),
                                  )), //or active if the challenge started
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      showAlertD(BuildContext context) {
        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.white70,
          title:const Text('are you sure '),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, child:const Text("Discard", style: TextStyle(color: Colors.black),)),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child:const Text("Cancel", style: TextStyle(color: Colors.black),)),
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      Future<void> _selectStartDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: con.startDate,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != con.startDate&&picked.isAfter(DateTime.now().yesterday)){
          con.updateStartDate(picked);

        }else{
        Get.snackbar('hi', 'please choose valid date ',backgroundColor: Colors.red,snackPosition:SnackPosition.BOTTOM,duration:const Duration(seconds: 2));
      }}

      Future<void> _selectEndDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: con.endDate,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
        if (picked != null && picked != con.endDate&&picked.isAfter(DateTime.now())&&picked.isAfter(con.startDate)){
          con.updateEndDate(picked);

        }else {
          Get.snackbar(
              'hi', 'please choose valid date ', backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              duration:const Duration(seconds: 2));
        } }
    }
    
    
