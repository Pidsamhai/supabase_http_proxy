import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/email_metadata.dart';
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
  bool preUpdateUserInfo = false;
  User? user;
  UserMetadata? metadata;
  final TextEditingController uidController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
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
        preUpdateUserInfo = false;
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

  Future<void> _updateUserInfo() async {
    if (!preUpdateUserInfo) {
      setState(() {
        preUpdateUserInfo = true;
        preDeleteAccount = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final email = Email(
      fullName: fullNameController.text,
      name: nameController.text,
    );
    await context.read<AuthRepository>().updateEmailMetadata(email);
    setState(() {
      isLoading = false;
      preUpdateUserInfo = false;
    });
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
            (email) => _content(
              email: user?.email,
              profileName: email.fullName,
              profilePicUrl:
                  "https://ui-avatars.com/api/?name=${user?.email?[0]}",
              userName: email.name,
              providers: "Email",
              userId: user?.id,
            ),
            (github) => _content(
              email: github.email,
              profileName: github.fullName,
              profilePicUrl: github.avatarUrl,
              providers: "Github",
              userName: github.userName,
              userId: user?.id,
            ),
            (discord) => _content(
              email: discord.email,
              profileName: discord.fullName,
              profilePicUrl: discord.avatarUrl,
              providers: "Discord",
              userId: user?.id,
            ),
            (google) => _content(
              email: google.email,
              profileName: google.fullName,
              profilePicUrl: google.avatarUrl,
              providers: "Google",
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
    String? email,
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
        SelectableText(
          (profileName ?? "") + (userName != null ? "($userName)" : ""),
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox.square(dimension: 16),
        SelectableText("Email : $email"),
        const SizedBox.square(dimension: 8),
        SelectableText("Provider : $providers"),
        if (preDeleteAccount) ...[_deleteAccountConfirmation(userId)],
        if (preUpdateUserInfo) ...[
          _updateUserInfoWidget(
            fullName: profileName,
            name: userName,
          )
        ],
        const SizedBox.square(dimension: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (metadata?.isEmail() == true) ...[
              ElevatedButton(
                onPressed: (isLoading) ? null : _updateUserInfo,
                child:
                    Text(!preUpdateUserInfo ? "Edit profile" : "Save profile"),
              ),
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
            )
          ],
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

  Column _deleteAccountConfirmation(String? userId) {
    return Column(
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
    );
  }

  Widget _noContent() {
    return const Center(
      child: Text("No content avilable"),
    );
  }

  Widget _updateUserInfoWidget({
    String? fullName,
    String? name,
  }) {
    fullNameController.text = fullName ?? "";
    nameController.text = name ?? "";
    return Column(
      children: [
        const SizedBox.square(dimension: 16),
        TextField(
          decoration: const InputDecoration(
            label: Text("Full Name"),
            border: OutlineInputBorder(),
          ),
          controller: fullNameController,
        ),
        const SizedBox.square(dimension: 16),
        TextField(
          decoration: const InputDecoration(
            label: Text("Name"),
            border: OutlineInputBorder(),
          ),
          controller: nameController,
        )
      ],
    );
  }
}
