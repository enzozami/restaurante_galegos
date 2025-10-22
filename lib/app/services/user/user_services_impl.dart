import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/user/user_repository.dart';

import './user_services.dart';

class UserServicesImpl implements UserServices {
  final UserRepository _userRepository;

  UserServicesImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<UserModel> getUser({required int id}) => _userRepository.getUser(id: id);
}
