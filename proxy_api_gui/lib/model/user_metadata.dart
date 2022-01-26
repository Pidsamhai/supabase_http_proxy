import 'package:proxy_api_gui/model/github_metadat.dart';
import 'package:sealed_unions/sealed_unions.dart';

import 'github_metadat copy.dart';

class Email {}

class Discord {}

class UserMetadata
    extends Union5Impl<Email, Github, Discord, Google, Map<String, dynamic>> {
  static const factory =
      Quintet<Email, Github, Discord, Google, Map<String, dynamic>>();

  UserMetadata._(
      Union5<Email, Github, Discord, Google, Map<String, dynamic>> union)
      : super(union);

  factory UserMetadata.email() {
    return UserMetadata._(factory.first(Email()));
  }

  factory UserMetadata.github(Github github) {
    return UserMetadata._(factory.second(github));
  }

  factory UserMetadata.discord() {
    return UserMetadata._(factory.third(Discord()));
  }

  factory UserMetadata.google(Google data) {
    return UserMetadata._(factory.fourth(data));
  }

  factory UserMetadata.raw({Map<String, dynamic> data = const {}}) {
    return UserMetadata._(factory.fifth(data));
  }
}
