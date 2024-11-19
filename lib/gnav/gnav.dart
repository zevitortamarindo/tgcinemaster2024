import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:cinemaster_app/controller/navbar_controller.dart';
import 'package:cinemaster_app/models/user_provider.dart';

class GoogleNavBar extends StatelessWidget {
  const GoogleNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acessando o UserProvider para obter o ID do usuário
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Acessando o NavBarController usando o Provider
    final navBarController = Provider.of<NavBarController>(context);

    return Scaffold(
      bottomNavigationBar: GNav(
        iconSize: 20,
        backgroundColor: const Color(0xff1f1d36),
        color: Colors.white,
        activeColor: const Color(0xff00d06c),
        onTabChange: (index) {
          // Atualizando o índice de navegação no controller
          navBarController.setIndex(index);
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Início',
            gap: 5,
          ),
          GButton(
            icon: Icons.bookmark_outline_rounded,
            text: 'Watchlist',
            gap: 5,
          ),
          GButton(
            icon: Icons.support_outlined,
            text: 'Roleta',
            gap: 5,
          ),
          GButton(
            icon: Icons.person,
            text: 'Perfil',
            gap: 5,
          ),
        ],
      ),
      // Exibindo a página correspondente ao índice atual do NavBarController
      body: navBarController.pages(userProvider)[navBarController.index],
    );
  }
}
