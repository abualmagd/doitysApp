
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:doitys/data_api/data.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/video_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
class GroupPost extends StatefulWidget {
  final String? challengeId;
  const GroupPost(Key? key,{required this.challengeId}):super(key: key);
  @override
  _GroupPostState createState() => _GroupPostState();
}

class _GroupPostState extends State<GroupPost> {
  File? _video;
  final picker = ImagePicker();
  final DataServices api =DataServices();
  final vic=Get.put(ViController());
  final TextEditingController _textController=TextEditingController();
  final _postController=Get.put(PostController());
  Future getVideo() async {
    final pickedFile = await picker.getVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 1));

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        _image = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Theme.of(context).primaryColor,
        title: Text("Create New Post",
          style: GoogleFonts.pacifico(
            fontSize: 20,
                color: Theme.of(context).shadowColor,
          ),
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back,color:Theme.of(context).shadowColor ,) ,onPressed: (){
          Navigator.pop(context);
        },),

      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),

                width: MediaQuery.of(context).size.height *.70,
                  child: TextFormField(
                    controller: _textController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLines: 8,
                    maxLength:180,
                    decoration:const InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      focusColor:Colors.red,
                      border: InputBorder.none,
                      hintText: "write whats in your mind ",
                    ),
                    onChanged: (str){

                    },
                  ),
                ),

            ),
            (_image == null && _video == null)
                ?   Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 150,
                  width: MediaQuery.of(context).size.height *.70,
                  child: Center(
                    child:IconButton(icon:const Icon(Icons.camera_alt,size:40,), onPressed:(){
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
                              const  Text('or'),
                                TextButton(child:const Text('Image'),onPressed: (){
                                  getImage();
                                  Navigator.pop(context);
                                },),
                              ],
                            ),
                          ),
                        ),
                      );

                    }),)
              ),
            ):  (_image != null && _video == null)
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
                            decoration:const  BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(Icons.close)),

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
                            decoration: const BoxDecoration(
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 2,
                child: InkWell(
                  splashColor: Colors.green,
                  onTap: (){
                    ///publish post now
                    Navigator.pop(context);
                    if(_textController.text.isNotEmpty){
                      if(_video!=null&&_image==null){

                        api.uploadVideo(file: _video!, bucket: "videos").then((value) {
                        vic.updateVideoUrl(value);
                        }).whenComplete((){
                          _postController.addNewPost(challengeId:widget.challengeId, content:_textController.text.trim(),
                              image:vic.videoUrl, video: null);
                        }).catchError((r){
                          Get.snackbar("hi", r.toString(),
                              backgroundColor: Colors.red);
                        });

                      }
                      if(_image!=null&&_video==null){

                       api.uploadImage(file: _image!, bucket: 'images').then((value) {
                         vic.updateImageUrl(value);
                       }).whenComplete((){
                         _postController.addNewPost(challengeId:widget.challengeId, content:_textController.text.trim(),
                             image:vic.imageUrl, video: null);
                       }).catchError((r){
                         Get.snackbar("hi", r.toString(),
                             backgroundColor: Colors.red);
                       });



                      }else{
                        _postController.addNewPost(challengeId:widget.challengeId, content:_textController.text.trim(),
                            image: null, video: null);
                      }



                    }
                  },
                  child: Ink(
                    width:MediaQuery.of(context).size.height *.60,
                    height: 50,
                    decoration: BoxDecoration(
                      color:Theme.of(context).backgroundColor, // if active color green
                     border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                        child: Text(
                          'Publish',
                          style: TextStyle(fontSize: 24,
                             letterSpacing: 2),
                        )), //or active if the challenge started
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
