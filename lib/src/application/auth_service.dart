class AuthService {
  // Simple auth behavior extracted from controller
  Map<String, dynamic> register(String name, double income) {
    final userName = name.trim();
    final setupState = 'inProgress';
    return {'userName': userName, 'setupState': setupState};
  }

  Map<String, dynamic> login(double income) {
    final userName = 'Usuario';
    final setupState = income == 0.0 ? 'inProgress' : 'completed';
    return {'userName': userName, 'setupState': setupState};
  }
}
