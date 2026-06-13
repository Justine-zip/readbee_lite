import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/core/services/auth_services.dart';

final authServicesProvider = Provider<AuthServices>((ref) => AuthServices());
