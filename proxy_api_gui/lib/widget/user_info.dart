import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/user_metadata.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/widget/circle_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/utils/extensions.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  bool isLoading = false;
  bool preDeleteAccount = false;
  User? user;
  UserMetadata? metadata;
  final TextEditingController uidController = TextEditingController();
  bool get _isMatchUid => uidController.text == user?.id;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthRepository>().currentUser();
    metadata = user?.userMetadataClass();
    uidController.addListener(() => setState(() {}));
  }

  Future<void> _deleteAccount() async {
    if (!preDeleteAccount) {
      setState(() {
        preDeleteAccount = true;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    await context.read<AuthRepository>().deleteAccount();
    setState(() {
      isLoading = false;
    });
    context.goNamed(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: metadata!.join(
            (p0) => _noContent(),
            (github) => _content(
              profileName: github.fullName,
              profilePicUrl: github.avatarUrl,
              providers: "Github",
              userName: github.userName,
              userId: user?.id,
            ),
            (p0) => _noContent(),
            (google) => _content(
              profileName: google.fullName,
              profilePicUrl: google.avatarUrl,
              providers: "google",
              userId: user?.id,
            ),
            (raw) => _content(
              profileName: user?.email,
              userId: user?.id,
            ),
          ),
        ),
      ),
    );
  }

  Widget _content({
    String? profileName,
    String? profilePicUrl,
    String? providers,
    String? userName,
    String? userId,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircleImageWidget(
            imageUrl: profilePicUrl ?? "",
          ),
        ),
        const SizedBox.square(dimension: 16),
        Text(
          (profileName ?? "") + (userName != null ? "($userName)" : ""),
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox.square(dimension: 16),
        if (preDeleteAccount) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox.square(dimension: 16),
              const Text(
                "Confirm you want to delete account by typing its",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox.square(dimension: 4),
              SelectableText(
                "UID: $userId",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox.square(dimension: 4),
              TextField(
                decoration: InputDecoration(
                    label: const Text(""),
                    border: const OutlineInputBorder(),
                    hintText: userId),
                controller: uidController,
              )
            ],
          )
        ],
        const SizedBox.square(dimension: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: (isLoading || preDeleteAccount && !_isMatchUid)
              ? null
              : _deleteAccount,
          child: const Text("Delete Account"),
        ),
        const SizedBox.square(dimension: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Close"),
            )
          ],
        )
      ],
    );
  }

  Widget _noContent() {
    return const Center(
      child: Text("No content avilable"),
    );
  }
}
