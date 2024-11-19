import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cinemaster_app/movie_details.dart';
import 'package:cinemaster_app/widgets/constants.dart';
import 'package:cinemaster_app/utils.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'controller/recomendacao_controller/recomendacao_similar.dart';

class MovieWheelScreen extends StatefulWidget {
  final String currentUserId;

  MovieWheelScreen({required this.currentUserId, Key? key}) : super(key: key);

  @override
  _MovieWheelScreenState createState() => _MovieWheelScreenState();
}

class _MovieWheelScreenState extends State<MovieWheelScreen> {
  List<Map<String, dynamic>> recommendedMovies = [];
  Map<String, dynamic>? selectedMovie;

  @override
  void initState() {
    super.initState();
    loadRecommendedMovies();
  }

  Future<void> loadRecommendedMovies() async {
    List<String> recommendedMovieIds = await recommendMoviesBasedOnWatchlist(widget.currentUserId);
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(Constants.apiKey, Constants.readAccessToken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    // Carrega detalhes de cada filme recomendado usando seus IDs
    for (String movieId in recommendedMovieIds) {
      Map movieDetails = await tmdbWithCustomLogs.v3.movies.getDetails(int.parse(movieId), language: 'pt-BR');
      recommendedMovies.add({
        'id': movieDetails['id'].toString(),
        'title': movieDetails['title'],
        'poster_path': movieDetails['poster_path']
      });
    }

    setState(() {
      selectedMovie = recommendedMovies.isNotEmpty
          ? recommendedMovies[Random().nextInt(recommendedMovies.length)]
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedMovie == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double baseWidth = 450;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        color: const Color(0xe5020217),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100 * fem),
            Image.asset(
              'lib/assets/images/iconeCinemaster.png',
              width: 55.5 * fem,
              height: 62 * fem,
            ),
            AppText(
              text: 'ROLETA MASTER',
              color: const Color(0xff00d06c),
              size: 32 * ffem,
              fontWeight: FontWeight.w700,
              height: 1.3625 * ffem / fem,
            ),
            SizedBox(height: 40),
            Text(
              'O filme escolhido foi...',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Open Sans',
                color: Colors.white,
                fontSize: 24 * ffem,
                fontWeight: FontWeight.w700,
                height: 1.3625 * ffem / fem,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      movieId: selectedMovie!['id'],
                      mediaType: 'movies',
                    ),
                  ),
                );
              },
              child: Container(
                height: 260,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${selectedMovie!['poster_path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              selectedMovie!['title'],
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Open Sans',
                color: Colors.white,
                fontSize: 26 * ffem,
                fontWeight: FontWeight.w700,
                height: 1.3625 * ffem / fem,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ID: ${selectedMovie!['id']}',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Open Sans',
                color: Colors.white,
                fontSize: 18 * ffem,
                fontWeight: FontWeight.w500,
                height: 1.3625 * ffem / fem,
              ),
            ),
            SizedBox(height: 35),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 10)),
              child: Container(
                width: 120 * fem,
                height: 55 * fem,
                decoration: BoxDecoration(
                  color: const Color(0xff009ed0),
                  borderRadius: BorderRadius.circular(30 * fem),
                ),
                child: Center(
                  child: AppText(
                    text: 'Voltar',
                    color: const Color(0xff1f1d36),
                    size: 19 * fem,
                    fontWeight: FontWeight.w700,
                    height: 1.3625 * ffem / fem,
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
