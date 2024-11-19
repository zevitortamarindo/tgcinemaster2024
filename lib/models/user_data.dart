class UserData {
  UserData({
    this.name,
    this.email,
    this.filmesEscolhidos,
    this.servicosStreaming,
    this.userId,
    required this.uniqueId,
  });

  final String? name;
  final String? email;
  final List<String>? filmesEscolhidos;
  final List<String>? servicosStreaming;
  final String? userId;
  final String uniqueId;
}
