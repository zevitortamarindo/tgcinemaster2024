import 'package:cinemaster_app/gnav/gnav.dart';
import 'package:cinemaster_app/login_screen.dart';
import 'package:cinemaster_app/movie_details.dart';
import 'package:cinemaster_app/selectFilmes.dart';
import 'package:cinemaster_app/selectStreamings.dart';
import 'package:cinemaster_app/services/flutter_fire_auth.dart';
import 'package:cinemaster_app/signup_screen.dart';
import 'package:cinemaster_app/watchlist.dart';
import 'package:cinemaster_app/profile_screen.dart';
import 'package:cinemaster_app/wheel_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:cinemaster_app/models/user_provider.dart';
import 'package:cinemaster_app/controller/navbar_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavBarController()),
      ],
      child: MaterialApp(
        title: 'Cinemaster',
        home: FutureBuilder(
          future: FlutterFireAuth(context).getLoggedUser(), // Assumindo que essa função retorne um Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Carregando
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final user = snapshot.data;
            return user != null ? GoogleNavBar() : LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          unselectedWidgetColor: Colors.white,
        ),
      ),
    );
  }
}



// ignore_for_file: prefer_const_constructors, prefer_const_declarations

// Testando Código 'Search'
// import 'package:cinemaster_app/widgets/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TMDb Search Test',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SearchScreen(),
//     );
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController _searchController = TextEditingController();
//   List<dynamic> searchResults = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TMDb Search Test'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Pesquisar',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     _searchMovies();
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: searchResults.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(searchResults[index]['title']),
//                     subtitle: Text('ID: ${searchResults[index]['id']}'),

//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<dynamic>> searchMovies(String query) async {
//     final String apiKey = Constants.apiKey;
//     final String baseUrl = 'https://api.themoviedb.org/3/search/movie';

//     final Uri uri = Uri.parse('$baseUrl?api_key=$apiKey&query=$query');
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['results'];
//     } else {
//       throw Exception('Falha ao carregar os filmes');
//     }
//   }

//   Future<void> _searchMovies() async {
//     String query = _searchController.text.trim();
//     if (query.isNotEmpty) {
//       List<dynamic> results = await searchMovies(query);

//       setState(() {
//         searchResults = results;
//       });
//     }
//   }
// }
