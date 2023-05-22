import 'dart:async';

import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:bookingmanager/view/auth/login/login_view.dart';
import 'package:bookingmanager/view/main/home/home_view.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static bool _inited = false;
  static AuthService get instance => _instance;
  static final AuthService _instance = AuthService._();
  AuthService._();

  static StreamSubscription? _userChangesSubscription;
  static StreamSubscription? _firebaseUserChangesSubscription;

  /// Note: This method must be called after Firebase.initializeApp() and CacheService.init()
  static Future<void> init() async {
    if (_inited) return;
    _inited = true;
    _firebaseUserChangesSubscription =
        FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        await AuthService.signOut(signOutFirebase: false);
      }
    });
    _userChangesSubscription = FirebaseFirestore.instance
        .collection("users")
        .doc(AuthService.instance.firebaseUser!.uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        AuthService.instance._user = UserModel.fromJson(event.data()!);
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
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_user_not_found.tr(),
              error: true);
          break;
        case "wrong-password":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_wrong_password.tr(),
              error: true);
          break;
        case "invalid-email":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_invalid_email.tr(), error: true);
          break;

        case "user-disabled":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_user_disabled.tr(), error: true);
          break;

        default:
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_unknown_error.tr(), error: true);
          break;
      }
      return false;
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.auth_service_unknown_error.tr(), error: true);
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
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.auth_service_logout_success.tr());
      _inited = false;
      NavigationService.toPageAndRemoveUntil(const LoginView());
      return true;
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.auth_service_unknown_error, error: true);
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
              message: LocaleKeys.auth_service_email_already_in_use.tr(),
              error: true);
          break;
        case "invalid-email":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_invalid_email.tr(), error: true);
          break;
        case "operation-not-allowed":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_operation_not_allowed.tr(),
              error: true);
          break;
        case "weak-password":
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_weak_password.tr(), error: true);
          break;

        default:
          PopupHelper.instance.showSnackBar(
              message: LocaleKeys.auth_service_unknown_error.tr(), error: true);
      }
      return false;
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.auth_service_unknown_error.tr(), error: true);
      return false;
    }
  }
}
