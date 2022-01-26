class Github {
  Github({
    required this.avatarUrl,
    required this.email,
    required this.emailVerified,
    required this.fullName,
    required this.iss,
    required this.name,
    required this.preferredUsername,
    required this.providerId,
    required this.sub,
    required this.userName,
  });

  String avatarUrl;
  String email;
  bool emailVerified;
  String fullName;
  String iss;
  String name;
  String? preferredUsername;
  String providerId;
  String sub;
  String userName;

  factory Github.fromJson(Map<String, dynamic> json) => Github(
        avatarUrl: json["avatar_url"],
        email: json["email"],
        emailVerified: json["email_verified"],
        fullName: json["full_name"],
        iss: json["iss"],
        name: json["name"],
        preferredUsername: json["preferred_username"],
        providerId: json["provider_id"],
        sub: json["sub"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_url": avatarUrl,
        "email": email,
        "email_verified": emailVerified,
        "full_name": fullName,
        "iss": iss,
        "name": name,
        "preferred_username": preferredUsername,
        "provider_id": providerId,
        "sub": sub,
        "user_name": userName,
      };
}
