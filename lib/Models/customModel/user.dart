class MangoUser {
  final String id;
  final String email;
  final String gender;
  final String password;
  final String bannerImageUrl;
  final String profileImage;
  final String bio;
  final String displayName;
  final String dob;
  final String country;
  final String city;
  final String state;
  final String profession;
  final String phone;
  final String username;
  final String fcmToken;
  final List<dynamic> hobbies;
  final bool verified;

  MangoUser({
    required this.fcmToken,
    required this.hobbies,
    required this.phone,
    required this.profession,
    required this.city,
    required this.country,
    required this.state,
    required this.verified,
    required this.email,
    required this.gender,
    required this.password,
    required this.bannerImageUrl,
    required this.profileImage,
    required this.dob,
    required this.bio,
    required this.displayName,
    required this.username,
    required this.id});
}

class MangoInterests {
  final String userId;
  final List interests;

  MangoInterests({
    required this.userId,
    required this.interests,});
}