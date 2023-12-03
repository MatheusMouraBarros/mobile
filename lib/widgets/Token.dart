class Token {
  // Instância única da classe
  static final Token _instance = Token._internal();

  // Variável String
  String token = "";

  // Construtor privado para impedir instâncias externas
  Token._internal();

  // Método para obter a instância única
  factory Token() {
    return _instance;
  }
}
