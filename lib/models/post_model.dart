



class Post {
  final String? id;
  final String? image;
  final String? video;
  final String? content;
  final String? challengeId;
   late int? likesCount;
   late bool?   liked;
  final DateTime? created;
  final String? creatorId;
  final String? creatorAvatar;
  final String? creatorDisplay;
  final String? creatorName;
  final int? commentsCount;


  Post({this.commentsCount, this.creatorId, this.creatorAvatar, this.creatorDisplay, this.creatorName, this.created,
    this.id, this.image, this.video, this.content,  this.challengeId,this.liked, this.likesCount});


  Post.fromJson(Map<dynamic, dynamic> json)
      : content = json['content'],
        commentsCount=json['comments_count'],
        image = json['image'],
        video =json['video'],
        challengeId =json['challenged_id'],
        likesCount =json['likes_count'],
        liked=json['liked'],
        id=json['id'],
        creatorId=json['creator_id'],
        creatorDisplay=json['display'],
        creatorAvatar=json['avatar'],
        creatorName=json['name'],
        created=json['created'];

        Post.fromData(Map<String,dynamic>data):
              content = data['content'],
              image = data['image'],
              video =data['video'],
              commentsCount=data['comments_count'],
              challengeId =data['challenged_id']??'public',
              likesCount =data['likes_count'],
              liked=data['liked'],
              id=data['id'],
              created=DateTime.parse(data['created']),
              creatorId=data['creator_id'],
              creatorDisplay=data['display'],
              creatorAvatar=data['avatar'],
              creatorName=data['name'];

  Map toJson() =>
      {
        "content": content,
        "image": image,
        "video": video,
        'challengeId':challengeId,
        'creator_id':creatorId,
        'created': created,
      };


}