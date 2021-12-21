import 'package:get/get.dart';

class ViController extends GetxController{
  var _videoUrl="".obs;
  set videoUrl(String value)=>_videoUrl.value=value;
  String get videoUrl=>_videoUrl.value;

  var _imageUrl="".obs;
  set imageUrl(var value)=>_imageUrl.value=value;
  String get imageUrl=>_imageUrl.value;

  updateVideoUrl(String? url){
    _videoUrl(url);
  }

  updateImageUrl(String? url){
    _imageUrl(url);
  }



}

