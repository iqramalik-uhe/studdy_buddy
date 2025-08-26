import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({required this.isSignedIn, this.email});
  final bool isSignedIn;
  final String? email;

  AuthState copyWith({bool? isSignedIn, String? email}) =>
      AuthState(isSignedIn: isSignedIn ?? this.isSignedIn, email: email ?? this.email);
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState(isSignedIn: false);

  void signIn(String email) {
    state = state.copyWith(isSignedIn: true, email: email);
  }

  void signOut() {
    state = const AuthState(isSignedIn: false);
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);


