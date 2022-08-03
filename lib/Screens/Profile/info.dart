class Info {
  const Info({
    this.profileName,
    this.username,
    this.profilePic,
    this.bio,
    this.banner,
    this.followers,
    this.following,
    this.posts,
    this.streams,
});

  final String? profileName;
final String? username;
final String? profilePic;
final String? bio;
final String? banner;
final int? followers;
final int? following;
final int? posts;
final int? streams;
}

var currentInfo = const Info(
  profileName: 'Alaga Tan-Kansu',
  posts: 35,
  profilePic: 'asset/images/mango-6.jpg',
  followers: 5,
  following: 3,
  streams: 13143,
  bio: 'Aga gan gan lon ba yin fo l\'owo, anybody to ba be la ma fi ko body. peace out.',
  username: 'townCouncil',
  banner: 'asset/images/mango-3.jpg'
);