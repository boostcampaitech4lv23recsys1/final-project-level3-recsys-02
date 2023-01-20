class User {
// final String country;
  String email, pwd, name;
  int age, gender;
  String profileImage;
  // List<String> selectedGenres;
  // List<String> selectedArtist;

  User({
    required this.email,
    required this.pwd,
    required this.name,
    required this.age,
    required this.gender,
    required this.profileImage,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    name: json['name'] as String,
    pwd: json['pwd'] as String,
    age: json['age'] as int,
    gender: json['gender'] as int,
    profileImage: json['profileImage'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'pwd': instance.pwd,
      'age': instance.age,
      'gender': instance.gender,
      'profileImage': instance.profileImage,
    };
