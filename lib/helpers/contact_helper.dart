import 'package:sqflite/sqflite.dart';

//Criar as colunas do BD: id, name, email, phone, img

final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {}

//A classe vai definir tudo que o contato vai armazenar
class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  //retorna os dados do map para os contatos da 'Classe Contact'
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  //Faz o inverso, transformando os dados da 'classe Contact' para mapa
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
  }
}
