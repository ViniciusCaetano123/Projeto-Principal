class Alarme {
  int id;
  String nome;
  int hora;
  int minuto;
  int domingo;
  int sabado;
  int segunda;
  int terca;
  int quarta;
  int quinta;
  int sexta;
  int ativo;

  Alarme(
      {required this.id,
      required this.nome,
      required this.hora,
      required this.minuto,
      required this.domingo,
      required this.sabado,
      required this.segunda,
      required this.terca,
      required this.quarta,
      required this.quinta,
      required this.sexta,
      required this.ativo});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nome': nome,
      'hora': hora,
      'minuto': minuto,
      'domingo': domingo,
      'sabado': sabado,
      'segunda': segunda,
      'terca': terca,
      'quarta': quarta,
      'quinta': quinta,
      'sexta': sexta,
      'ativo': ativo,
    };

    return map;
  }
}
