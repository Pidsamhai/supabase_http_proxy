class Discord {
  Discord({
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

// {
//   "user_metadata": {
//     "avatar_url": "https://cdn.discordapp.com/avatars/365389181557669889/e4d75b0f72e20ad797d1792e0268cd7e.png",
//     "email": "meng348@gmail.com",
//     "email_verified": true,
//     "full_name": "à¸à¸§à¸¢à¸à¸¹à¹",
//     "iss": "https://discord.com/api",
//     "name": "à¸à¸§à¸¢à¸à¸¹à¹",
//     "picture": "https://cdn.discordapp.com/avatars/365389181557669889/e4d75b0f72e20ad797d1792e0268cd7e.png",
//     "provider_id": "365389181557669889",
//     "sub": "365389181557669889"
//   }
// }

  String avatarUrl;
  String email;
  bool emailVerified;
  String fullName;
  String iss;
  String name;
  String picture;
  String providerId;
  String sub;

  factory Discord.fromJson(Map<String, dynamic> json) => Discord(
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
