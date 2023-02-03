class UserInfo {
// final String country;
  String user_name, password, realname, image;
  int userId, age, playcount;
  List<int> follower;
  List<int> following;

  UserInfo({
    required this.userId,
    required this.user_name,
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
    user_name: json['user_name'] as String,
    password: json['pwd'] as String,
    realname: json['realname'] as String,
    image: json['image'] as String,
    age: json['age'] as int,
    playcount: json['playcount'] as int,
    following: json['following'] as List<int>,
    follower: json['followers'] as List<int>,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.user_name,
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
  List<int> follower;
  List<int> following;

  OtherUser({
    required this.user_id,
    required this.realname,
    required this.image,
    required this.following,
    required this.follower,
  });
}
