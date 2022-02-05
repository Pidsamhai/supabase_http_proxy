import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/user_metadata.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/utils/extensions.dart';
import 'package:proxy_api_gui/widget/circle_image.dart';
import 'package:proxy_api_gui/widget/user_info.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  Future<void> openProfileDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const Dialog(
        child: UserInfoWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthRepository>().currentUser()!;
    UserMetadata metadata = user.userMetadataClass();

    return Row(
      children: [
        Text(
          metadata.join(
            (email) => email.name ?? "",
            (github) => github.name,
            (discord) => discord.fullName,
            (google) => google.email,
            (raw) => "",
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        const SizedBox.square(dimension: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => openProfileDialog(context),
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade400,
                    ),
                    child: CircleImageWidget(
                      imageUrl: metadata.join(
                        (email) =>
                            email.avatarUrl ??
                            "https://ui-avatars.com/api/?name=${user.email?[0]}",
                        (github) => github.avatarUrl,
                        (discord) => discord.avatarUrl,
                        (google) => google.avatarUrl,
                        (raw) => "",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
