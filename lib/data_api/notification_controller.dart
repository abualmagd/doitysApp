
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';


class NotificationController extends GetxController {
  var notificationsList = <Notification>[].obs;
  var isLoading = false.obs;
  var nonReadNotification=false.obs;
  List<Notification> data = [];
var newNotification=<Notification>[].obs;
  final currentAuthorConroller = Get.put(AuthorController());
  final _client = Get.find<SupabaseClient>();
         @override
       onInit(){
           subscribe();
          super.onInit();
       }



  Future fetchNotifications() async {
           isLoading(true);
    final currentId = currentAuthorConroller.currentAuthor.id;
    print(currentId.toString());

    var result =await _client.rpc('get_author_notifications_fn',params: {'author_id':currentId}).execute();
    if (result.error == null) {
      data = List<Notification>.from(result.data.map((i) => Notification.fromData(i!)).toList());
      notificationsList.value = data;
      var length=notificationsList.length;
      for(var i=0;i<length;i++){
        if(data[i].read==false) {
          nonReadNotification(true);
          break;
        }
      }
      print(notificationsList[0].actionUserName);
       isLoading(false);
    }else {
       isLoading(true);
    }
  }
  Future updateReadingBool()async{
    final currentId = currentAuthorConroller.currentAuthor.id;
         _client.from("app_notifications").update({
           'read':true,}).eq('reciver_user_id', currentId).eq('read', false).execute();
         nonReadNotification(false);
  }



  subscribe() {
          final currentId=currentAuthorConroller.currentAuthor.id;
     _client.from('app_notifications').on(
        SupabaseEventTypes.insert, (payload) {
          newNotification.add(Notification.fromData(payload.newRecord!));
          if(newNotification[0].reciverId==currentId) {
            var record = newNotification[0];
            var message = record.type == 'follow' ? 'follow you' : record
                .type == 'like' ? 'like your post' :
            record.type == 'comment' ? 'comment on your post' : record.type ==
                "like_replay" ? "liked your replay" :
            record.type == 'replay' ? 'replay to you' : 'like your comment';
            Get.snackbar('', record.actionUserName.toString() + ' ' + message,duration: Duration(milliseconds: 1));
            fetchNotifications();
          }
      //getLastNotification();
    }).subscribe();
  }
 removeSubscription(){
           _client.removeSubscription(subscribe());
 }

}