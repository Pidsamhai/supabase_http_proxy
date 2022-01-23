import 'package:go_router/go_router.dart';

extension RouterStateMagicLink on GoRouterState {
  Uri? magicLink() {
    if (queryParams["type"] == "magiclink") {
      return Uri.parse(
        Uri.base.origin +
            "/#" +
            queryParams.entries.map((e) => "${e.key}=${e.value}").join("&"),
      );
    }
    return null;
  }
}
