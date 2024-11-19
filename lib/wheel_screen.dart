import 'dart:math';
import 'package:cinemaster_app/movie_wheel.dart';
import 'package:flutter/material.dart';
import 'package:cinemaster_app/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/user_provider.dart';

class WheelScreen extends StatefulWidget {
  final String currentUserId;
  const WheelScreen({super.key, required this.currentUserId});

  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool wheel = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserId = userProvider.userData?.userId ?? '';

    double baseWidth = 450;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xe5020217),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 100 * fem, 9.5 * fem, 0 * fem),
              child: Image.asset(
                'lib/assets/images/iconeCinemaster.png',
                width: 55.5 * fem,
                height: 62 * fem,
              ),
            ),
            AppText(
              text: 'ROLETA MASTER',
              color: const Color(0xff00d06c),
              size: 32 * ffem,
              fontWeight: FontWeight.w700,
              height: 1.3625 * ffem / fem,
            ),
            const SizedBox(height: 9),
            Container(
              constraints: BoxConstraints(maxWidth: 400 * fem),
              child: Text(
                'Não se preocupe, vamos escolher um filme pra você',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Open Sans',
                  color: Colors.white,
                  fontSize: 25 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.3625 * ffem / fem,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: EdgeInsets.only(left: 7 * fem, bottom: 60 * fem),
              width: 210 * fem,
              height: 190 * fem,
              child: Lottie.network(
                'https://lottie.host/6453bcf5-afd3-4e3c-bf56-8075e8937af0/j7MFSOyo1y.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  if (!wheel) {
                    setState(() {
                      wheel = true;
                    });
                    _controller.forward().whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieWheelScreen(currentUserId: widget.currentUserId),
                        ),
                      ).then((_) {
                        setState(() {
                          wheel = false; // Permite girar novamente ao retornar
                        });
                      });
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: 135 * fem,
                  height: 60 * fem,
                  decoration: BoxDecoration(
                    color: const Color(0xff00d06c),
                    borderRadius: BorderRadius.circular(30 * fem),
                  ),
                  child: Center(
                    child: AppText(
                      text: 'Girar',
                      color: const Color(0xff1f1d36),
                      size: 23 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.3625 * ffem / fem,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
