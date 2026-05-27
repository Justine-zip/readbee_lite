import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileProvider = FutureProvider<Profile?>((ref) async {
  final supabase = Supabase.instance.client;

  final response =
      await supabase
          .from('profiles')
          .select('*')
          .eq('id', supabase.auth.currentUser!.id)
          .single();

  debugPrint('ProfileData: $response');

  return Profile(
    id: response['id'] ?? '',
    fullName: response['full_name'] ?? '',
    sex: response['sex'] ?? '',
    phone: response['phone'] ?? '',
    address: response['address'] ?? '',
    title: response['title'] ?? '',
    position: response['position'] ?? '',
    email: response['email'] ?? '',
  );
});
