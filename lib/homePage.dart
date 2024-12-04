import 'package:cinemaster_app/movie_details.dart';
import 'package:cinemaster_app/search_screen.dart';
import 'package:cinemaster_app/styles.dart';
import 'package:cinemaster_app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Home extends StatefulWidget {
  Home({super.key}) {}

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List popularmovies = [];
  List topratedmovies = [];
  List populartv = [];
  List topratedtv = [];
  List upcoming = [];

  String apiKey = Constants.apiKey;
  String readAccessToken = Constants.readAccessToken;

  void initState() {
    loadmovies();
    super.initState();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ));

    Map popularmoviesresult =
        await tmdbWithCustomLogs.v3.movies.getPopular(language: 'pt-br');
    Map topratedresult =
        await tmdbWithCustomLogs.v3.movies.getTopRated(language: 'pt-br');
    Map populartvresult =
        await tmdbWithCustomLogs.v3.tv.getPopular(language: 'pt-br');
    Map topratedtvresult =
        await tmdbWithCustomLogs.v3.tv.getTopRated(language: 'pt-br');
    Map upcomingresult =
        await tmdbWithCustomLogs.v3.movies.getUpcoming(language: 'pt-br');

    setState(() {
      popularmovies = popularmoviesresult['results'];
      topratedmovies = topratedresult['results'];
      populartv = populartvresult['results'];
      topratedtv = topratedtvresult['results'];
      upcoming = upcomingresult['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 2, 23, 0.9),
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        backgroundColor: Color.fromRGBO(3, 2, 23, 0.9),
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'lib/assets/images/iconeCinemaster.png',
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SearchScreen();
                      }),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: screenHeight * 0.05,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: popularmovies.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.06,
                    screenHeight * 0.03,
                    screenWidth * 0.06,
                    screenHeight * 0.02),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: screenHeight * 0.02,
                            bottom: screenHeight * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Filmes Populares',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: popularmovies.length,
                        options: CarouselOptions(
                          height: screenHeight * 0.4,
                          aspectRatio: 9 / 6,
                          viewportFraction: 0.55,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MovieDetails(
                                        movieId: (popularmovies[index]['id'].toString()),//movieId: popularmovies[index]['id'],
                                        mediaType: 'movies',
                                      );
                                    }),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: screenWidth * 0.02),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${Constants.imagePath}${popularmovies[index]['poster_path']}',
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: screenWidth * 0.02),
                                  child: Text(
                                    '${popularmovies[index]['title']}',
                                    style: simpleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      //
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Filmes Mais Bem Avaliados',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: topratedmovies.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.4,
                          // Ajuste de altura
                          aspectRatio:
                              MediaQuery.of(context).size.aspectRatio > 1
                                  ? 16 / 9
                                  : 9 / 16,
                          // Proporção baseada na orientação
                          viewportFraction: 0.55,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MovieDetails(
                                        movieId: topratedmovies[index]['id'].toString(),
                                        mediaType: 'movies',
                                      );
                                    }),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${Constants.imagePath}${topratedmovies[index]['poster_path']}',
                                    width: MediaQuery.of(context).size.width *
                                        0.5, // Largura responsiva
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '${topratedmovies[index]['title']}',
                                    style: simpleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: MediaQuery.of(context)
                                        .textScaleFactor, // Ajuste de texto
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      //
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Séries Populares',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: populartv.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.4,
                          aspectRatio:
                              MediaQuery.of(context).size.aspectRatio > 1
                                  ? 16 / 9
                                  : 9 / 16,
                          viewportFraction: 0.55,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MovieDetails(
                                        movieId: populartv[index]['id'].toString(),
                                        mediaType: 'tv',
                                      );
                                    }),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${Constants.imagePath}${populartv[index]['poster_path']}',
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '${populartv[index]['name']}',
                                    style: simpleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      //
                     
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Próximos Lançamentos',
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: upcoming.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.4,
                          aspectRatio: MediaQuery.of(context).size.aspectRatio > 1
                              ? 16 / 9
                              : 9 / 16,
                          viewportFraction: 0.55,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MovieDetails(
                                        movieId: upcoming[index]['id'].toString(),
                                        mediaType: 'movies',
                                      );
                                    }),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${Constants.imagePath}${upcoming[index]['poster_path']}',
                                    width: MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    '${upcoming[index]['title']}',
                                    style: simpleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
