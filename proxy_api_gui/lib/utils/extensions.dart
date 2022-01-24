import 'package:go_router/go_router.dart';

extension RouterStateMagicLink on GoRouterState {
  Uri? magicLink() {
    if (["magiclink", "signup"].contains(queryParams["type"])) {
      final params =
          queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");
      return Uri.parse("${Uri.base.origin}/#$params");
    }
    return null;
  }
}
