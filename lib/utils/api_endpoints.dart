class ApiEndPoints {
  static final String baseUrl = 'https://pokeapi.co/api/v2/';
  static final String baseUrlImage = 'http://10.0.2.2:8000';
  // static final String baseUrl = 'https://dona-link.dermaone.my.id/api/';
  // static final String baseUrlImage = 'https://dona-link.dermaone.my.id';
  // static final String baseUrlImage = 'https://suryamarket.org';
  // static final String baseUrl = 'https://suryamarket.org/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'member/register';
  final String loginEmail = 'member/login';
}
