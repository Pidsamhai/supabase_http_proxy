import 'package:proxy_api_gui/model/discord_metadat.dart';
import 'package:proxy_api_gui/model/email_metadata.dart';
import 'package:proxy_api_gui/model/github_metadat.dart';
import 'package:proxy_api_gui/model/google_metadat.dart';
import 'package:sealed_unions/sealed_unions.dart';

class UserMetadata
    extends Union5Impl<Email, Github, Discord, Google, Map<String, dynamic>> {
  static const factory =
      Quintet<Email, Github, Discord, Google, Map<String, dynamic>>();

  UserMetadata._(
      Union5<Email, Github, Discord, Google, Map<String, dynamic>> union)
      : super(union);

  factory UserMetadata.email(Email data) {
    return UserMetadata._(factory.first(data));
  }

  factory UserMetadata.github(Github github) {
    return UserMetadata._(factory.second(github));
  }

  factory UserMetadata.discord(Discord data) {
    return UserMetadata._(factory.third(data));
  }

  factory UserMetadata.google(Google data) {
    return UserMetadata._(factory.fourth(data));
  }

  factory UserMetadata.raw({Map<String, dynamic> data = const {}}) {
    return UserMetadata._(factory.fifth(data));
  }

  bool isEmail() {
    return join(
      (email) => true,
      (p0) => false,
      (p0) => false,
      (p0) => false,
      (p0) => false,
    );
  }
}
