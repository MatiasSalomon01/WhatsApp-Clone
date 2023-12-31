import 'package:chat_app_frontend/helpers/sized_box_helper.dart';
import 'package:chat_app_frontend/pages/pages.dart';
import 'package:chat_app_frontend/providers/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = ["Chats", "Novedades", "Llamadas"];
    final navBarProvider = Provider.of<NavBarProvider>(context);
    // final PageController controller = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: secondary,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const NavBar(),
          Expanded(
            child: PageView.builder(
              controller: navBarProvider.controller,
              onPageChanged: (index) => navBarProvider.currentIndex = index,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const ChatPage();
                  case 1:
                    return const NewsPage();
                  case 2:
                    return const CallsPage();
                }
              },
              itemCount: titles.length,
            ),
          ),
        ],
      ),
      floatingActionButton: const CustomFloatinActionButton(),
    );
  }
}
