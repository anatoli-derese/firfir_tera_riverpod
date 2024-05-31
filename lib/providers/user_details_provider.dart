
import 'package:firfir_tera/presentation/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_provider.g.dart';

@riverpod
class IsPromoted extends _$IsPromoted {
  @override
  bool build() => false;
  void toggle() {
    AuthService authService = AuthService();
    authService.changeRole();
    state = !state;
  }
}
