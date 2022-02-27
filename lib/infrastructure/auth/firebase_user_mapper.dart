import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter_ddd/domain/auth/user.dart';
import 'package:flutter_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomain on firebaseAuth.User {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}
