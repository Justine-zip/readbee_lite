import 'package:readbee_lite/components/show_global_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> isEvaluator(String userId) async {
    final result = await _supabase.rpc(
      'is_evaluator',
      params: {'p_user_id': userId},
    );

    return result == true;
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId != null) {
      await _supabase.from('users').insert({
        'user_id': userId,
        'email': email,
        'fname': name,
      });
    }

    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<bool> resetCurrentUserPassword(String newPassword) async {
    try {
      final user = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      showGlobalSnackBar('Password updated for: ${user.user!.email}');
      return true;
    } catch (e) {
      showGlobalSnackBar('Failed to update password: $e');
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      showGlobalSnackBar('Password reset email sent to $email');
    } catch (e) {
      showGlobalSnackBar('Failed to send reset email: $e');
    }
  }

  Stream<AuthState> get authStateChanges =>
      Supabase.instance.client.auth.onAuthStateChange;
}
