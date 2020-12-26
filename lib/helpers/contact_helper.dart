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

  //Construtor que retorna os dados do map para construir os contatos da 'Classe Contact'
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  //Função que Faz o inverso, transformando os dados da 'classe Contact' para map
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
      //não há o campo id, porque o próprio banco de dados vai gerar
    };
    //caso o id seja nulo, então será adicionado o id no map idcolumn
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override 
  //caso haja necessidade de printar as informações do contato de maneira mais intuitiva é só chamar a função abaixo
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
