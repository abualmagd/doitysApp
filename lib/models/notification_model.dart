


enum Type{
  comment,
  like,
  mention,
  follow,
  like_comment,
  reply,
  like_reply
}


class Notification{
  final String? id;
  final String? type;
  final  String? reciverId;
  final  String? commentContent;
  final String?  actionUserId;
  final String?  postId;
  final String? postContent;
  final String? actionUserName;
  final  String? actionUserAvatar;
  final DateTime? created;
  final  String? commentId;
  final String? replyContent;
  final bool ? read;
  Notification(this.type,this.read,this.id ,this.reciverId, this.commentContent, this.actionUserId, this.postId, this.postContent, this.actionUserName, this.actionUserAvatar, this.created, this.commentId, this.replyContent);



    Notification.fromData(Map<String,dynamic>data)
          :
          id=data['id'],
          type=data['type'],
          reciverId=data['reciver_user_id'],
          commentContent=data['comment_content'],
          replyContent=data['reply_content'],
          commentId=data['comment_id'],
          created=DateTime.parse(data['created']),
          postId=data['post_id'],
          read=data['read'],
          actionUserAvatar=data['action_user_avatar'],
          actionUserName=data['action_user_name'],
          postContent=data['post_content'],
          actionUserId=data['action_user_id'];









}