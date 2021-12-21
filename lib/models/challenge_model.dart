




class Challenge {
  final String? id;
  final String? image;
  final String? video;
  final String? content;
  final String? title;
  final int? membersCount;
  final int? postsCount;
  final int? days;
  final String? created;
  final String? startsAt;
  final String? endsAt;
  final String? creatorAvatar;
  final String? creatorName;
  final String? creatorDisplay;
  final String?  creatorId;
  final bool?  joined;

  Challenge({this.days,this.joined
    ,this.creatorAvatar, this.creatorName, this.creatorDisplay, this.creatorId,
   this.id, this.image, this.video, this.content, this.endsAt,this.startsAt,
     this.created, this.membersCount=1,this.postsCount,this.title});


  Challenge.fromJson(Map<dynamic , dynamic>json,)
      : content = json['content'],
        joined=json['joined'],
        image = json['image'],
        video =json['video'],
        membersCount =json["members_count"],
        postsCount=json["posts_count"],
        title=json["title"],
        id=json['id'],
        days=json['days'],
        creatorAvatar=json['avatar'],
       creatorName=json['name'],
       creatorDisplay=json['display'],
        creatorId=json['creator_id'],
        startsAt=json["start_at"].toString(),

        created=json['created'].toString(),

        endsAt=json["end_at"].toString();


  Challenge.fromData(Map<String,dynamic> data,):
        content = data['content'],
        joined=data['joined'],
        image = data['image'],
        days=data['days'],
        video =data['video'],
        membersCount =data["members_count"],
        postsCount=data["posts_count"],
        title=data["title"],
        id=data['id'],
        creatorAvatar=data['avatar'],
        creatorName=data['name'],
        creatorDisplay=data['display'],
        creatorId=data['creator_id'] as String,
        startsAt=data["start_at"].toString(),
        created=data['created'].toString(),
        endsAt=data["end_at"].toString();






  Map toJson() =>
      {
        "content": content,
        "image": image,
        "video": video,
        "days": days,
        "start_at":startsAt,
        "ends_at":endsAt,
        "title":title,
        'ownerId': id,
        'created': created,
      };


}