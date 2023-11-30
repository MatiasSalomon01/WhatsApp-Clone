import 'package:chat_app_frontend/helpers/sized_box_helper.dart';
import 'package:chat_app_frontend/models/user.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/models.dart';
import 'widgets.dart';

class CustomAppBarChat extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarChat({super.key, required this.user});
  final User user;
  final double appBarHeight = kToolbarHeight;
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.zero,
      child: SafeArea(
        child: Container(
          color: primary,
          height: appBarHeight,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_outlined, color: white),
                            horizontalSpace(2),
                            ProfilePicture(
                              url: user.profilePictureUrl,
                              radius: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                    horizontalSpace(10),
                    Text(
                      user.name,
                      style: const TextStyle(color: white, fontSize: 17),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.videocam_rounded, color: white, size: 25),
                    Icon(Icons.call, color: white, size: 20),
                    Icon(Icons.more_vert, color: white, size: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
