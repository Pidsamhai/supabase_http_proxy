class Google {
  Google({
    required this.avatarUrl,
    required this.email,
    required this.emailVerified,
    required this.fullName,
    required this.iss,
    required this.name,
    required this.picture,
    required this.providerId,
    required this.sub,
  });

  String avatarUrl;
  String email;
  bool emailVerified;
  String fullName;
  String iss;
  String name;
  String picture;
  String providerId;
  String sub;

  factory Google.fromJson(Map<String, dynamic> json) => Google(
        avatarUrl: json["avatar_url"],
        email: json["email"],
        emailVerified: json["email_verified"],
        fullName: json["full_name"],
        iss: json["iss"],
        name: json["name"],
        picture: json["picture"],
        providerId: json["provider_id"],
        sub: json["sub"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_url": avatarUrl,
        "email": email,
        "email_verified": emailVerified,
        "full_name": fullName,
        "iss": iss,
        "name": name,
        "picture": picture,
        "provider_id": providerId,
        "sub": sub,
      };
}
