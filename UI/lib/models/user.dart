class UserInfo {
// final String country;
  String id, pwd, name, country;
  int image, age, gender;
  List<String> followers;
  List<String> following;

  UserInfo({
    required this.id,
    required this.pwd,
    required this.name,
    required this.country,
    required this.image,
    required this.age,
    required this.gender,
    required this.following,
    required this.followers,
  });
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

UserInfo _$UserFromJson(Map<String, dynamic> json) {
  return UserInfo(
    id: json['id'] as String,
    pwd: json['pwd'] as String,
    name: json['name'] as String,
    country: json['country'] as String,
    image: json['image'] as int,
    age: json['age'] as int,
    gender: json['gender'] as int,
    following: json['following'] as List<String>,
    followers: json['followers'] as List<String>,
  );
}

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'pwd': instance.pwd,
      'name': instance.name,
      'country': instance.country,
      'image': instance.image,
      'age': instance.age,
      'gender': instance.gender,
      'following': instance.following,
      'followers': instance.followers,
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
