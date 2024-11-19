import 'dart:developer';

import 'package:flutter/material.dart';
import 'user_data.dart'; // Certifique-se de que este é o caminho correto para a classe UserData

class UserProvider with ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUserData(UserData userData) {
    log("Definindo UserData com uniqueId: ${userData.uniqueId}");
    _userData = userData;
    notifyListeners();
  }

  void clearUserData() {
    log("Limpando UserData");
    _userData = null;
    notifyListeners();
  }

  // Método para atualizar o nome do usuário
  void updateUserName(String name) {
    if (_userData != null) {
      _userData = UserData(
        name: name,
        email: _userData!.email,
        filmesEscolhidos: _userData!.filmesEscolhidos,
        servicosStreaming: _userData!.servicosStreaming,
        userId: _userData!.userId,
        uniqueId: _userData!.uniqueId, // Mantém o uniqueId existente
      );
      notifyListeners();
    }
  }

  // Método para atualizar filmes escolhidos pelo usuário
  void updateFilmesEscolhidos(List<String> filmes) {
    if (_userData != null) {
      _userData = UserData(
        name: _userData!.name,
        email: _userData!.email,
        filmesEscolhidos: filmes,
        servicosStreaming: _userData!.servicosStreaming,
        userId: _userData!.userId,
        uniqueId: _userData!.uniqueId, // Mantém o uniqueId existente
      );
      notifyListeners();
    }
  }
}
