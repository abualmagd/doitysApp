import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ImageView extends StatelessWidget {
  final index;
 final imageUrl;
  const ImageView({required Key key, this.index,this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent
      ),
      body: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Hero(
                tag: "tag"+index.toString(),
                child: CachedNetworkImage(
                  imageUrl:imageUrl,
                  imageBuilder: (context, imageProvider) => PhotoView(
                    imageProvider: imageProvider,
                  ),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeat,
                  placeholder: (context,url)=>ColoredBox(
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => ColoredBox(
                      color: Colors.grey,
                      child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
