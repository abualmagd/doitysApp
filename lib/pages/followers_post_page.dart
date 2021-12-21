import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/post_controller.dart';
import 'package:doitys/global/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'add_new_post.dart';

class PublicPostPage extends StatefulWidget {
  const PublicPostPage({Key? key}) : super(key: key);

  @override
  _PublicPostPageState createState() => _PublicPostPageState();
}

class _PublicPostPageState extends State<PublicPostPage> {

  var postControl=Get.put(PostController());
  @override
  void initState() {

    postControl.fetchFollowingPublicPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverAppBar(
                centerTitle:true,
                leading: IconButton(icon: Icon(Icons.arrow_back,color: Theme.of(context).shadowColor,),onPressed: (){
                  Navigator.pop(context);
                },),
                title:Text(
                      "Timeline",
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
            onRefresh: () async{await Future.delayed(const Duration(seconds: 2),()=>print('refreshed'),);},
            child: Obx(()=>postControl.isLoading.value?const Center(child:CircularProgressIndicator(
                  color: Colors.white,
                ),): postControl.postList.isEmpty?const Center(child: Text('sorry ,nothing to show yet\n'
                    'follow some users to show \nthere '
                    'public posts here')):ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder:(_, index) => PostWidget(index:index, key: UniqueKey(), data: postControl.postList,) ,
                  itemCount: postControl.postList.length,
                ),
                ),
          ),

          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.edit,color:Colors.black ,),
              onPressed: (){
                Navigator.of(context).push(bottomSideSlideTransition(GroupPost(GlobalKey(),challengeId:null,)));
              },
            ),
          ),
        ],
      ),

    );
  }
}
