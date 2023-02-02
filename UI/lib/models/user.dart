class UserInfo {
// final String country;
  String password, realname, image;
  int userId, age, playcount;
  List<String> follower;
  List<String> following;

  UserInfo({
    required this.userId,
    required this.password,
    required this.realname,
    required this.image,
    required this.age,
    required this.playcount,
    required this.following,
    required this.follower,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

UserInfo _$UserFromJson(Map<String, dynamic> json) {
  return UserInfo(
    userId: json['user_id'] as int,
    password: json['pwd'] as String,
    realname: json['realname'] as String,
    image: json['image'] as String,
    age: json['age'] as int,
    playcount: json['playcount'] as int,
    following: json['following'] as List<String>,
    follower: json['followers'] as List<String>,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'user_id': instance.userId,
      'password': instance.password,
      'realname': instance.realname,
      'image': instance.image,
      'age': instance.age,
      'playcount': instance.playcount,
      'following': instance.following,
      'follower': instance.follower,
    };

class OtherUser {
// final String country;
  int user_id;
  String realname, image;
  List<String> follower;
  List<String> following;

  OtherUser({
    required this.user_id,
    required this.realname,
    required this.image,
    required this.following,
    required this.follower,
  });
}
