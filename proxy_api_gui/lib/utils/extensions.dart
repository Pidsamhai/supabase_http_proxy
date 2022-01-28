import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/model/discord_metadat.dart';
import 'package:proxy_api_gui/model/email_metadata.dart';
import 'package:proxy_api_gui/model/google_metadat.dart';
import 'package:proxy_api_gui/model/github_metadat.dart';
import 'package:proxy_api_gui/model/user_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension RouterStateMagicLink on GoRouterState {
  Uri? magicLink() {
    if (["magiclink", "signup"].contains(queryParams["type"]) ||
        queryParams.containsKey("provider_token")) {
      final params =
          queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");
      return Uri.parse("${Uri.base.origin}/#$params");
    }
    return null;
  }
}

extension SupabaseUser on User {
  UserMetadata userMetadataClass() {
    UserMetadata metadata = UserMetadata.raw(data: userMetadata);
    try {
      final data = Github.fromJson(userMetadata);
      return UserMetadata.github(data);
      // ignore: empty_catches
    } catch (e) {}

    try {
      if ((appMetadata["provider"] as String?)?.toLowerCase() == "discord") {
        final data = Discord.fromJson(userMetadata);
        return UserMetadata.discord(data);
      }
      final data = Google.fromJson(userMetadata);
      return UserMetadata.google(data);
      // ignore: empty_catches
    } catch (e) {}

    try {
      final data = Email.fromJson(userMetadata);
      return UserMetadata.email(data);
      // ignore: empty_catches
    } catch (e) {}

    return metadata;
  }
}
