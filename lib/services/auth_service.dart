import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_yt/pages/map_page.dart';

class AuthService {
  Future<void> signup({required String email, required String password, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) => const MapPage()
          )
        );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'La contraseña proporcionada es demasiado débil';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya existe una cuenta con ese correo electrónico';
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {}
  }

  Future<void> signin({required String email, required String password, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) => const MapPage()
          )
        );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Ningun usuario encontrado para ese correo electrónico.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta proporcionada para ese usuario.';
      } else if(e.code == 'invalid-credential') {
        message = 'Credenciales incorrectas';
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {}
  }
}
