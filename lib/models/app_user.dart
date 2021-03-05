class AppUser {
  AppUser(
      {this.uid,
      this.createdAt,
      this.username,
      this.photoUrl,
      this.extData,
      this.token});

  String uid;
  String username;
  String photoUrl;
  String createdAt;
  // extra data, e.g. device/loc related details
  Map<String, dynamic> extData = Map();
  String token;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'createdAt': createdAt,
        'username': username,
        'photoUrl': photoUrl,
        'extData': extData ?? Map(),
        'accessToken': token
      };

  @override
  String toString() {
    return toJson().toString();
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        uid: json['uid'],
        createdAt: json['createdAt'],
        username: json['username'],
        photoUrl: json['photoUrl'],
        extData: json['extData'] ?? Map(),
        token: json['accessToken']);
  }
}
