import 'dart:async';
import 'dart:developer';

import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:bookingmanager/view/auth/login/login_view.dart';
import 'package:bookingmanager/view/main/home/home_view.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static bool _inited = false;
  static AuthService get instance => _instance;
  // static AuthService get instance => AuthService._inited
  //     ? _instance
  //     : throw Exception("AuthService not inited");
  static final AuthService _instance = AuthService._();
  AuthService._();

  static StreamSubscription? _userChangesSubscription;
  static StreamSubscription? _firebaseUserChangesSubscription;

  /// Note: This method must be called after Firebase.initializeApp() and CacheService.init()
  static Future<void> init() async {
    if (_inited) return;
    _inited = true;
    _firebaseUserChangesSubscription = FirebaseAuth.instance
        .userChanges()
        // .skip(1)
        .listen((User? user) async {
      if (user == null) {
        await AuthService.signOut(signOutFirebase: false);
      }
    });
    _userChangesSubscription = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthService.instance.firebaseUser!.uid)
        .snapshots()
        // .skip(1)
        .listen((event) {
      if (event.exists) {
        log("tetiklendi");
        AuthService.instance._user = UserModel.fromJson(event.data()!);
        log(AuthService.instance._user!.toString());
        if (AuthService.instance._user!.relatedBusinessUid.isEmpty) {
          NavigationService.toPageAndRemoveUntil(const AccountSetupView());
        } else {
          NavigationService.toPageAndRemoveUntil(const HomeView());
        }
      } else {
        AuthService.signOut();
      }
    });
  }

  UserModel? _user;
  UserModel? get user => _user;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  Future<bool> get isLoggedIn async {
    bool loginStatus = FirebaseAuth.instance.currentUser != null;
    if (loginStatus && _user == null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser!.uid)
          .get();
      if (doc.data() == null) {
        await AuthService.signOut();
        return false;
      }
      _user = UserModel.fromJson(doc.data()! as Map<String, dynamic>);
    }

    return loginStatus;
  }

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      AuthService.instance._user =
          UserModel.fromJson(documentSnapshot.data()! as Map<String, dynamic>);

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          PopupHelper.instance
              .showSnackBar(message: "Kullanıcı bulunamadı", error: true);
          break;
        case "wrong-password":
          PopupHelper.instance
              .showSnackBar(message: "Yanlış şifre", error: true);
          break;
        case "invalid-email":
          PopupHelper.instance
              .showSnackBar(message: "Geçersiz email", error: true);
          break;

        case "user-disabled":
          PopupHelper.instance
              .showSnackBar(message: "Kullanıcı devre dışı", error: true);
          break;

        default:
          PopupHelper.instance
              .showSnackBar(message: "Bilinmeyen hata", error: true);
          break;
      }
      return false;
    } catch (e) {
      PopupHelper.instance
          .showSnackBar(message: "Bilinmeyen hata", error: true);
      return false;
    }
  }

  /// if it triggered inside [_firebaseUserChangesSubscription], [signOutFirebase] must be false
  static Future<bool> signOut({bool signOutFirebase = true}) async {
    try {
      if (signOutFirebase) {
        await FirebaseAuth.instance.signOut();
      }
      AuthService.instance._user = null;
      _firebaseUserChangesSubscription?.cancel();
      _userChangesSubscription?.cancel();

      _firebaseUserChangesSubscription = null;
      _userChangesSubscription = null;
      PopupHelper.instance.showSnackBar(message: "Çıkış yapıldı");
      _inited = false;
      NavigationService.toPageAndRemoveUntil(const LoginView());
      return true;
    } catch (e) {
      PopupHelper.instance
          .showSnackBar(message: "Bilinmeyen hata", error: true);
      return false;
    }
  }

  /// Try to register user with given email and password and login automatically
  static Future<bool> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.updateDisplayName(name);
      AuthService.instance._user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(AuthService.instance._user!.toMap());
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          PopupHelper.instance.showSnackBar(
              message: "Bu email ile kayıt olmuş kullanıcı mevcut",
              error: true);
          break;
        case "invalid-email":
          PopupHelper.instance
              .showSnackBar(message: "Geçersiz email", error: true);
          break;
        case "operation-not-allowed":
          PopupHelper.instance.showSnackBar(
              message: "Bu işlem şu anda devre dışı", error: true);
          break;
        case "weak-password":
          PopupHelper.instance
              .showSnackBar(message: "Şifre çok zayıf", error: true);
          break;

        default:
          PopupHelper.instance
              .showSnackBar(message: "Bilinmeyen bir hata oluştu", error: true);
      }
      return false;
    } catch (e) {
      PopupHelper.instance
          .showSnackBar(message: "Bilinmeyen bir hata oluştu", error: true);
      return false;
    }
  }
}
