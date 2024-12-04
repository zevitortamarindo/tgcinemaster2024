import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:convert'; // Para converter a resposta JSON
import 'package:http/http.dart' as http; // Para fazer requisições HTTP

Future<List<String>> recommendMoviesBasedOnWatchlist(String currentUserId) async {
  List<String> recommendedMovies = [];

  try {
    // Obter dados do usuário atual
    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    // Verifique se os campos existem no documento antes de acessá-los
    Map<String, dynamic>? currentUserData = currentUserSnapshot.data() as Map<String, dynamic>?;

    print('Dados do usuário atual: $currentUserData');

    // Corrigir para tratar a lista de filmes como uma lista de mapas
    List<String> currentUserWatchlist = currentUserData != null && currentUserData.containsKey('filmes_watchlist')
        ? (currentUserData['filmes_watchlist'] as List).map((movie) {
      // Verificar se 'movie['id']' é do tipo String ou int, e converte para String
      if (movie['id'] is String) {
        return movie['id'] as String;
      } else if (movie['id'] is int) {
        return movie['id'].toString(); // Converte para String
      } else {
        return ''; // Retorna uma string vazia caso o tipo não seja reconhecido
      }
    }).toList()
        : [];

    print('Watchlist do usuário atual: $currentUserWatchlist');

    List<String> currentUserStreaming = currentUserData != null && currentUserData.containsKey('streaming')
        ? List<String>.from(currentUserData['streaming'])
        : [];

    print("Plataformas de streaming preferidas do usuário atual: $currentUserStreaming");

    // Obter dados de outros usuários
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<String, double> movieRecommendationScores = {};

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;
      if (userId != currentUserId) {
        Map<String, dynamic> otherUserData = userDoc.data() as Map<String, dynamic>;

        // Corrigir para tratar a lista de filmes como uma lista de mapas
        List<String> otherUserWatchlist = otherUserData.containsKey('filmes_watchlist')
            ? (otherUserData['filmes_watchlist'] as List).map((movie) {
          // Aqui, garantir que o 'id' do filme seja tratado corretamente
          if (movie['id'] is String) {
            return movie['id'] as String;
          } else if (movie['id'] is int) {
            return movie['id'].toString(); // Converte para String
          } else {
            return ''; // Retorna uma string vazia caso o tipo não seja reconhecido
          }
        }).toList()
            : [];

        List<String> otherUserStreaming = otherUserData.containsKey('streaming')
            ? List<String>.from(otherUserData['streaming'])
            : [];

        print("Watchlist do outro usuário ($userId): $otherUserWatchlist");

        // Verificar interseção de watchlists e plataformas de streaming
        int commonMovies = currentUserWatchlist.toSet().intersection(otherUserWatchlist.toSet()).length;
        int commonStreaming = currentUserStreaming.toSet().intersection(otherUserStreaming.toSet()).length;

        print("Número de filmes em comum com $userId: $commonMovies");
        print("Número de plataformas de streaming em comum com $userId: $commonStreaming");

        // Similaridade ajustada para considerar preferências de streaming
        double similarity = calculateEuclideanSimilarity(commonMovies, commonStreaming);

        print("Similaridade com o usuário $userId: $similarity");

        if (similarity > 0) {
          for (var movie in otherUserWatchlist) {
            if (!currentUserWatchlist.contains(movie)) {
              movieRecommendationScores[movie] = (movieRecommendationScores[movie] ?? 0) + similarity;
              print("Pontuação de recomendação atualizada para o filme $movie: ${movieRecommendationScores[movie]}");
            }
          }
        }
      }
    }

    if (movieRecommendationScores.isEmpty) {
      recommendedMovies.add(await suggestRandomMovie());
    } else {
      recommendedMovies = movieRecommendationScores.keys.toList()
        ..sort((a, b) => movieRecommendationScores[b]!.compareTo(movieRecommendationScores[a]!));
    }
  } catch (e) {
    print('Erro ao gerar recomendações: $e');
    recommendedMovies.add(await suggestRandomMovie());
  }
  print('Filmes recomendados: $recommendedMovies');
  return recommendedMovies;
}

// Função auxiliar para calcular a similaridade com ajuste para streaming
double calculateEuclideanSimilarity(int commonMovies, int commonStreaming) {
  return 1 / (1 + sqrt(pow(commonMovies, 2) + pow(commonStreaming, 2)));
}

// Função para sugerir um filme aleatório em caso de falha na recomendação
Future<String> suggestRandomMovie() async {
  const String apiKey = 'e90fb2a07f28a7e12c61965533ba0079'; // Substitua pela sua chave de API do TMDB
  const String url = 'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR&page=1';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decodificar o JSON da resposta
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      // Extrair os IDs dos filmes
      List<String> popularMovies = results.map((movie) => movie['id'].toString()).toList();

      // Selecionar um filme aleatório da lista
      String randomMovie = popularMovies[Random().nextInt(popularMovies.length)];
      print("Sugerindo um filme aleatório da API TMDB: $randomMovie");
      return randomMovie;
    } else {
      print("Erro na requisição à API TMDB. Status Code: ${response.statusCode}");
      throw Exception('Falha ao buscar filmes populares');
    }
  } catch (e) {
    print("Erro ao sugerir filme aleatório: $e");
    // Retornar um ID fixo como fallback em caso de erro
    return '912649'; // ID fixo como última opção
  }
}
