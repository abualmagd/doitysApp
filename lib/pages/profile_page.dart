
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/formates/detect_language.dart';
import 'package:doitys/formates/number_formates.dart';
import 'package:doitys/global/better_player.dart';
import 'package:doitys/global/profile_background_path.dart';
import 'package:doitys/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:doitys/formates/extensions.dart';
import 'comment_page.dart';
import 'image_view.dart';
import 'package:get/get.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/formates/date_extension.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

NumberFormatting numberFormatting = NumberFormatting();

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  final picker = ImagePicker();
  File? _image;
  final _postController =Get.put(PostController());

  Future getImage() async {
    final _pikedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _image = File(_pikedFile!.path);
    });

    return _image;
  }
  AuthorController? cc;

  @override
  void initState() {
    super.initState();
    cc = Get.put(AuthorController());//author controller
    _postController.getUserPosts();
    _editDisplayController =
        TextEditingController(text: cc!.currentAuthor.display);
    _editBioController = TextEditingController(text: cc!.currentAuthor.bio);
    _editWebsiteController =
        TextEditingController(text: cc!.currentAuthor.website);

  }






  bool _editable = false;

  TextEditingController? _editDisplayController;
  TextEditingController? _editBioController;
  TextEditingController? _editWebsiteController;

  var getCon = Get.put(AuthorController());

  @override
  Widget build(BuildContext context) {
    String _followers =
        numberFormatting.compact(getCon.currentAuthor.followerCount ?? 0);
    String _following =
        numberFormatting.compact(getCon.currentAuthor.followingCount ?? 0);

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body:Obx(()=>getCon.currentAuthor.name != null? NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              excludeHeaderSemantics: true,
              backgroundColor: context.theme.primaryColor,
              title: Obx(() => Text(
                    "${getCon.currentAuthor.name}",
                    style: GoogleFonts.pacifico(
                      color: Theme.of(context).shadowColor,
                    ),
                  )),
              pinned: true,
              floating: false,
              forceElevated: true,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).shadowColor,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(rightSideSlideTransition(Settings()));
                    }),
              ],
              flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                value:const  SystemUiOverlayStyle(
                  systemNavigationBarColor:  Color(0xfff4f0db),
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
                                key: UniqueKey(),
                                //photo back container
                                width: double.infinity,
                                color: context.theme.primaryColor,
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * .30,
                                top: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return ImageView(
                                          imageUrl: getCon.currentAuthor.avatar,
                                          index: "0",
                                          key: UniqueKey(),
                                        );
                                      }));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: SizedBox(
                                        child: Hero(
                                          tag: "tag" + "232323".toString(),
                                          transitionOnUserGestures: true,
                                          child: getCon.currentAuthor.avatar !=
                                                      null &&
                                                  getCon.currentAuthor.avatar!
                                                      .isNotEmpty
                                              ? Obx(
                                                  () => CachedNetworkImage(
                                                    imageUrl: getCon
                                                        .currentAuthor.avatar
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    repeat: ImageRepeat.repeat,
                                                    placeholder:
                                                        (context, url) =>
                                                            const ColoredBox(
                                                      color: Colors.grey,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const ColoredBox(
                                                            color: Colors.grey,
                                                            child: Icon(
                                                                Icons.error)),
                                                  ),
                                                )
                                              : Image.asset(
                                                  "assets/images/puz.jpg",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * .25,
                                bottom: 20,
                                child: Visibility(
                                  visible: _editable,
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        //show alert dialog for editing image pick new photo
                                        getImage().then((value) =>
                                            showPhotoAlert(context, value,
                                                () async {
                                              Navigator.pop(context);
                                              setState(() {
                                                _editable = !_editable;
                                              });

                                        var response=      await getCon.uploadImage(
                                                                    file: _image!,
                                                                      bucket: 'profiles');

                                                  if(response!=null) {
                                                    var _result = await getCon
                                                        .updateAvatar(
                                                        url: response);
                                                    if (_result == true) {
                                                      await getCon
                                                        .getCurrentAuthor();
                                                    }
                                                  }


                                            }));


                                      }),
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
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Obx(() => Text(
                                                  "${getCon.currentAuthor.display}",
                                                  style:
                                                      const TextStyle(fontSize: 18),
                                                )),
                                          ),
                                          Visibility(
                                            visible: _editable,
                                            child: IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                ),
                                                onPressed: () {
                                                  //show alert dialog for editing display
                                                  showEditableAlert(
                                                      context,
                                                      "Edit DisplayName",
                                                      _editDisplayController,
                                                      () {
                                                    getCon
                                                        .updateDisplay(
                                                            _editDisplayController!
                                                                .text)
                                                        .whenComplete(() {
                                                          Navigator.pop(
                                                              context);

                                                          Future.delayed(
                                                              const Duration(
                                                                  microseconds:
                                                                      300), () {
                                                            getCon
                                                                .getCurrentAuthor();
                                                          });
                                                        })
                                                        .whenComplete(
                                                          () => Get.snackbar(
                                                              "hi",
                                                              "your profile updated successfully"),
                                                        )
                                                        .catchError((r) {
                                                          Fluttertoast.showToast(
                                                              msg: r.toString(),
                                                              timeInSecForIosWeb:
                                                                  r.length * 2);
                                                        });

                                                    setState(() {
                                                      _editable = !_editable;
                                                    });
                                                  }, 30);
                                                }),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _editable = !_editable;
                                                  });
                                                },
                                                child: Ink(
                                                  height: 30,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: _editable
                                                        ? Colors.blue
                                                        : context.theme
                                                            .backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                  ),
                                                  child:const Center(
                                                      child: Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, left: 12),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .80,
                                        child: getCon.currentAuthor.bio !=
                                                    null &&
                                                getCon.currentAuthor.bio!
                                                    .isNotEmpty
                                            ? Obx(
                                                () => Text(
                                                  getCon.currentAuthor.bio
                                                      .toString(),
                                                  style:
                                                      const TextStyle(fontSize: 15),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            : const Text(
                                                "Write something about you",
                                                style: TextStyle(fontSize: 15),
                                                maxLines: 2,
                                              ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _editable,
                                      child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            //show alert dialog for editing bio
                                            showEditableAlert(
                                                context,
                                                "Edit Your Bio",
                                                _editBioController, () {
                                              getCon
                                                  .updateBio(
                                                      _editBioController!.text)
                                                  .whenComplete(() {
                                                Navigator.pop(context);

                                                Future.delayed(
                                                  const Duration(microseconds: 200),
                                                  () =>
                                                      getCon.getCurrentAuthor(),
                                                ).whenComplete(
                                                  () => Get.snackbar('hi',
                                                      'your profile updated successfully'),
                                                );
                                              }).catchError((r) {
                                                Fluttertoast.showToast(
                                                    msg: r.toString(),
                                                    timeInSecForIosWeb: 5);
                                              });

                                              setState(() {
                                                //update bio and rebuild
                                                _editable = !_editable;
                                              });
                                            }, 50);
                                          }),
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
                                    padding:  EdgeInsets.only(
                                        left: 12, right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                    ),
                                  ),
                                  Text(
                                    "joined :" +
                                        getCon.currentAuthor.created.readable,
                                    style: const TextStyle(color: Colors.grey),
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
                                    getCon.currentAuthor.website != null &&
                                            getCon.currentAuthor.website!
                                                .isNotEmpty
                                        ? Obx(
                                            () => Text(
                                              getCon.currentAuthor.website
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        :const SizedBox.shrink(),
                                    Visibility(
                                      visible: _editable,
                                      child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                          ),
                                          onPressed: () {
                                            //show alert dialog for editing website
                                            showEditableAlert(
                                                context,
                                                "Edit Your Website",
                                                _editWebsiteController, () {
                                              getCon
                                                  .updateWebsite(
                                                      _editWebsiteController!
                                                          .text)
                                                  .whenComplete(() {
                                                Future.delayed(
                                                 const   Duration(microseconds: 350),
                                                    () {
                                                  getCon.getCurrentAuthor();
                                                });
                                                Navigator.pop(context);
                                              }).whenComplete(() {
                                                Get.snackbar("hi",
                                                    "your profile updated successfully");
                                              }).catchError((r) {
                                                Fluttertoast.showToast(
                                                    msg: r.toString(),
                                                    timeInSecForIosWeb:
                                                        r.length * 2);
                                              });
                                              setState(() {
                                                //update user website
                                                _editable = !_editable;
                                              });
                                            }, 20);
                                          }),
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
        body:RefreshIndicator(
          onRefresh: ()async{
           await Future.delayed(const Duration(seconds: 2),()=>print('refresh'),);
          },
          child: Obx(()=>_postController.userPostLoading.value?const Center(child:CircularProgressIndicator(),) :ListView.builder(
            padding: const EdgeInsets.only(top:0),
              itemCount: _postController.userPostList.length,
              itemBuilder: (context, index) =>
                 _postView(context,index),)
              ),
        )
      ):const CircularProgressIndicator(),
      ),
    );
  }

  showEditableAlert(BuildContext _, String _label, var controller,
      Function onSave, int length) {
    AlertDialog alert = AlertDialog(
      title: Text(_label),
      content: TextFormField(
        controller: controller,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: length,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:const Text('Discard')),
        TextButton(
            onPressed: () {

              onSave();
            },
            child:const Text('Save ')),
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext _) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
  }

  showPhotoAlert(BuildContext context, File _photo, Function onUse) {
    AlertDialog alertA = AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        height: MediaQuery.of(context).size.width * .7,
        child: Image.file(
          _photo,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:const Text('Discard')),
        TextButton(
            onPressed: () {
              onUse();
            },
            child:const Text('Use')),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext _) {
          return WillPopScope(onWillPop: () async => false, child: alertA);
        });
  }




  Widget _postView(BuildContext context,int index) {


    Future<bool>onTap(bool value)async{
      if(value==true) {
        _postController.likePost(
            postId: _postController.userPostList[index].id!, list: _postController.userPostList, index: index);

      }else {
        _postController.unlikePost(
            postId: _postController.userPostList[index].id!, list: _postController.userPostList, index: index);

      }
      return !value;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Material(
            borderRadius:const BorderRadius.all(Radius.circular(12)),
            elevation:2,
            child: Container(
              decoration: BoxDecoration(
                //color: Color(0xfff4f0db), //Color(0xffFFFAF1),
                color: Theme.of(context).backgroundColor,
                borderRadius:const BorderRadius.all(Radius.circular(12)),
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
                                        image: CachedNetworkImageProvider(getCon.currentAuthor.avatar!),
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
                                  getCon.currentAuthor.display!,
                                  style:const TextStyle(fontSize: 18,),
                                ),
                                Text(
                                  getCon.currentAuthor.name!,
                                  style:const TextStyle(color: Colors.grey),
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

                      textDirection:isEnglish(_postController.userPostList[index].content!)?TextDirection.rtl:TextDirection.ltr,
                      child: ReadMoreText(
                        _postController.userPostList[index].content!,
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
                      child: _postController.userPostList[index].image.isValid?
                      SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: GestureDetector(
                          child: Hero(
                            tag: "tag" + index.toString(),
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: _postController.userPostList[index].image!,
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
                                imageUrl: _postController.userPostList[index].image!,
                                index: index, key: UniqueKey(),
                              );
                            }));
                          },
                        ),
                      ) : _postController.userPostList[index].video.isValid?
                      SizedBox(
                          height: 200,
                          child: VdPlayer(dataSource: _postController.userPostList[index].video,dataSourceType: BetterPlayerDataSourceType.network,key:GlobalKey(),))
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
                                  CommentPage(focusty: false, postId: _postController.userPostList[index].id!,
                                      commentsCount:_postController.userPostList[index].commentsCount!),);
                          },
                          child: Row(
                            children: [

                              const FaIcon(
                                FontAwesomeIcons.solidComment,
                                color:Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6, top: 6),
                                child:_postController.userPostList[index].commentsCount==0?const SizedBox.shrink():Text(_postController.userPostList[index].commentsCount.toString(), style: const TextStyle(
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
                        isLiked: _postController.userPostList[index].liked,
                        likeCount: _postController.userPostList[index].likesCount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if(index==_postController.userPostList.length-1)
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
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
            ),
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
                          child: Icon(Icons.add)),
                      Container(
                        width: 15,
                      ),
                      const Text("Unfollow",style: TextStyle(fontSize: 24),),
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

  @override
  void dispose() {
    _editDisplayController!.dispose();
    _editWebsiteController!.dispose();
    _editBioController!.dispose();
    super.dispose();
  }
}


