class Reply {
  final String? id;
  final String? content;
  final DateTime? created;
  final String? creatorId;
  final String? commentId;
  final String? replayTo;
   int? likesCount;
   bool? liked;
  final String? creatorAvatar;
  final String? creatorName;

  Reply(this.id, this.content, this.created, this.creatorId, this.commentId, this.creatorAvatar, this.creatorName, this.likesCount, this.liked, this.replayTo);

  Reply.fromData(Map<String,dynamic>data):
        id=data['id'],
        content=data['content'],
        created=DateTime.parse(data['created']),
        creatorId=data['creator_id'],
        creatorName=data['name'],
        creatorAvatar=data['avatar'],
        liked=data['liked'],
        likesCount=data['likes_count'],
        replayTo=data['reply_to'],
        commentId=data['comment_id'];
}