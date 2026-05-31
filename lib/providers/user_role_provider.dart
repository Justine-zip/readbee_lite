import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/user_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRoleProvider = FutureProvider<UserRole>((ref) async {
  final supabase = Supabase.instance.client;

  final response =
      await supabase
          .from('user_roles')
          .select('*')
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

  debugPrint('UserRoleData: $response');

  return UserRole(
    userId: response['user_id'],
    roleId: response['role_id'],
    scopeId: response['scope_id'],
    userRoleId: response['user_role_id'],
    districtId: response['district_id'],
    municipalId: response['municipal_id'],
    schoolId: response['school_id'],
  );
});
