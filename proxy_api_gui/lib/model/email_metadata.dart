class Email {
  Email({
    this.avatarUrl,
    this.fullName,
    this.name,
  });

  String? avatarUrl;
  String? fullName;
  String? name;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        avatarUrl: json["avatar_url"],
        fullName: json["full_name"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_url": avatarUrl,
        "full_name": fullName,
        "name": name,
      };
}
