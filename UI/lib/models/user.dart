class UserInfo {
// final String country;
  String name, pwd, realname, image, country;
  int age, gender;
  List<String> followers;
  List<String> following;

  UserInfo({
    required this.name,
    required this.pwd,
    required this.realname,
    required this.country,
    required this.image,
    required this.age,
    required this.gender,
    required this.following,
    required this.followers,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
  Map<String, dynamic> toAPIJson() => _$UserToAPIJson(this);
}

UserInfo _$UserFromJson(Map<String, dynamic> json) {
  return UserInfo(
    name: json['id'] as String,
    pwd: json['pwd'] as String,
    realname: json['name'] as String,
    country: json['country'] as String,
    image: json['image'] as String,
    age: json['age'] as int,
    gender: json['gender'] as int,
    following: json['following'] as List<String>,
    followers: json['followers'] as List<String>,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'pwd': instance.pwd,
      'realname': instance.realname,
      'image': instance.image,
      'country': instance.country,
      'age': instance.age,
      'gender': instance.gender,
      'following': instance.following,
      'followers': instance.followers,
    };

Map<String, dynamic> _$UserToAPIJson(UserInfo instance) => <String, dynamic>{
      'user_name': instance.name,
      'password': instance.pwd,
      'realname': instance.name,
      'image': instance.image,
      'country': instance.country,
      'age': instance.age,
      'gender': instance.gender,
      'following': instance.following,
      'followers': instance.followers,
      'result': 'success'
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
