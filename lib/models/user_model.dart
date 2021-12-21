



import 'dart:core';




class Author{
     final String? id;
      final String? avatar;
      final String? bio;
      final String? website;
      final String? display;
     final String? name;
      final DateTime? created;
      final String? email;
      final String? type;
      final int? followingCount;
      final int? followerCount;
      final String? location;
      late final bool? followed;
      final int? postsCount;



  Author({
      this.id,this.postsCount ,this.avatar,this.followed,  this.bio, this.website, this.display,this.name, this.created, this.email, this.type, this.followingCount,  this.followerCount,this.location});


    Author.fromJson(Map<String, dynamic> json)
         : name = json['name'],
           email = json['email'],
            avatar=json['avatar'],
            followed=json['followed'],
            bio=json['bio'],
            website=json['website'],
            display=json['display'],
            id=json['ownerId'],
            created=json['created'],
            type=json['type'],
            followerCount=json['followers'],
            followingCount=json['followings'],
          postsCount=json['posts_count'],
            location=json['location'];


     Map toJson()=>{
       "name":name,
       "email":email,
       "avatar":avatar,
       "bio":bio,
       "website":website,
       'display':display,
       'ownerId':id,
       'created':created.toString(),
       "type":type,
       "followers":followerCount,
       "followings":followingCount,
       "location":location,
     };

     Author.fromData(Map<String,dynamic> data):
           id= data['user_id'],
           name=data['name'],
            postsCount=data['posts_count'],
           email=data['email'],
           avatar=data['avatar'],
           followed=data['followed'],
           bio= data['bio'],
           website=data['website'],
           display=data['display'],
           created= DateTime.parse(data['created']),
           type=data['type'],
           followerCount=data['followers'],
           followingCount=data['followings'],
           location=data['location'];

}