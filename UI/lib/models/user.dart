class UserInfo {
// final String country;
  String user_name, password, realname, image, country;
  int age, gender, playcount;
  List<String> follower;
  List<String> following;

  UserInfo({
    required this.user_name,
    required this.password,
    required this.realname,
    required this.country,
    required this.image,
    required this.age,
    required this.gender,
    required this.playcount,
    required this.following,
    required this.follower,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

UserInfo _$UserFromJson(Map<String, dynamic> json) {
  return UserInfo(
    user_name: json['name'] as String,
    password: json['pwd'] as String,
    realname: json['realname'] as String,
    country: json['country'] as String,
    image: json['image'] as String,
    age: json['age'] as int,
    gender: json['gender'] as int,
    playcount: json['playcount'] as int,
    following: json['following'] as List<String>,
    follower: json['followers'] as List<String>,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'user_name': instance.user_name,
      'password': instance.password,
      'realname': instance.realname,
      'image': instance.image,
      'country': instance.country,
      'age': instance.age,
      'gender': instance.gender,
      'playcount': instance.playcount,
      'following': instance.following,
      'follower': instance.follower,
    };
class OtherUser {
  var image;
  String name;
  int followerNum;
  bool isFollowing;

  OtherUser(
      {this.image = 'assets/profile.png',
      required this.name,
      required this.followerNum,
      required this.isFollowing});
}
