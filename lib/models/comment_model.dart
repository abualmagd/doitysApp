

class Comment {
  final String? id;
  final String? content;
  final DateTime? created;
   final String? creatorId;
  final String? postId;
   int? repliesCount;
  int? likesCount;
   bool? liked;
  final String? creatorAvatar;
  final String? creatorName;

  Comment(this.id, this.content, this.created, this.creatorId, this.postId, this.creatorAvatar,
      this.creatorName, this.likesCount, this.liked, this.repliesCount);

  Comment.fromData(Map<String,dynamic>data):
                id=data['id'],
                content=data['content'],
                created=DateTime.parse(data['created']),
                creatorId=data['creator_id'],
                repliesCount=data['replies_count'],
                creatorName=data['name'],
                creatorAvatar=data['avatar'],
                liked=data['liked'],
                likesCount=data['likes_count'],
                postId=data['post_id'];







}