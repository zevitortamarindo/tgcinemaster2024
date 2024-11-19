import 'dart:developer';

import 'package:cinemaster_app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FlutterFireAuth {
  FlutterFireAuth(this._context);

  late final BuildContext _context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  Future<UserData?> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
    log("Tentando criar usuário com email: $email");
      // Create user with Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure user UID is generated and store in Firestore
      final userId = credential.user?.uid;
      if (userId != null) {
        log("uid $userId");
        // Update displayName with user's name
        await credential.user?.updateDisplayName(name);

        // Generate a unique UUID for the user document
        final uniqueId = _uuid.v4();
        log("Gerando uniqueId: $uniqueId para o usuário");

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': name,
          'email': email,
          'userId': userId, // Firebase Auth UID
          'uniqueId': uniqueId, // Additional unique UUID
        });
        log("Usuário salvo no Firestore com UID e uniqueId");
        return UserData(name: name, email: email, userId: userId, uniqueId: uniqueId);
      } else {
        log("Erro ao gerar UID do usuário");
        throw FirebaseAuthException(
          message: "Erro ao gerar UID do usuário",
          code: "uid-generation-failure",
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Ocorreu um erro desconhecido'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    return null;
  }

  Future<UserData?> signInWithEmailAndPassword(String email, String password) async {
    try {
      log("Tentando login com email: $email");

      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = credential.user;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final uniqueId = docSnapshot.data()?['uniqueId'];
        log("Recuperado uniqueId do Firestore: $uniqueId");

        return UserData(
          name: user.displayName,
          email: user.email,
          userId: user.uid,
          uniqueId: uniqueId,
        );
      }
    } on FirebaseAuthException catch (e) {
      log("Erro FirebaseAuthException: ${e.message}");
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Ocorreu um erro desconhecido'),
        ),
      );
    } catch (e) {
      log("Erro desconhecido: $e");
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    return null;
  }

  Future<UserData?> getLoggedUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Retrieve the unique UUID from Firestore if needed
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final uniqueId = docSnapshot.data()?['uniqueId'];

      return UserData(
        name: user.displayName ?? 'Usuário',
        email: user.email,
        userId: user.uid,
        uniqueId: uniqueId,
      );
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
