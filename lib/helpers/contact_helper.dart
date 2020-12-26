import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Criar as colunas do BD: id, name, email, phone, img

final String contactTable = "contactTable"; //nome da tabela
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

//===========================================================================================================================
class ContactHelper {
  //declarando o objeto '_instance' dentro da classe,
  //e chama o construtor interno 'contacthelper.internal'
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance; //

  ContactHelper.internal();

//declarando o banco de dados, que não poderá ser acessado fora dessa classe devido ao '_'
  Database _db;

//-----------> INICIALIZAR O BANCO DE DADOS
//Função futura e uma função assíncrona pois não ocorre instantaneamente
  Future<Database> get db async {
    if (_db != null) {
      //se o db for nulo, ou seja, se já estiver inicializado, retorna o banco de dados
      return _db;
    } else {
      //senão, ele chama a função para inicializar o bd 'initDb'
      _db = await initDb();
      return _db;
    }
  }

//--------------> ARMAZENA O CAMINHO E CRIA O BANCO DE DADOS CASO SEJA A PRIMEIRA VEZ

  //função que é um futuro e retorna um  banco de dados
  //como não retorna instantaneamente, então utiliza-se a função assíncrona 'async' e o 'await'
  Future<Database> initDb() async {
    //local onde vai armazenar o banco de dados
    final databasesPath =
        await getDatabasesPath(); //pega o caminho para a pasta de armazenamento do BD
    final path = join(databasesPath,
        "contacts.db"); // junta com o nome do banco 'contacts.db' e retorna o caminho 'path'

    //Abrindo o banco de dados
    return await openDatabase(path,
        version: 1, //criando o banco de dados pela primeira vez que abre ele
        onCreate: (Database db, int newerVersion) async {
      //como não ocorre instanteamente então utiliza-se a função assíncrona 'async' e 'await'
      await db.execute(
          //criando a tabela do Banco de Dados, nomeada lá no início 'contactTable'
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //FUNÇÃO SALVAR O CONTATO
  //chama o 'save contact' para salvar o contato, e passar o contato que queremos
  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db; //obter o banco de dados
    contact.id = await dbContact.insert(contactTable,
        contact.toMap()); // pedir para inserir o contato na tabela do BD
    return contact; //retorna o contato no FUTURO porque é uma função assíncrona
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //FUNÇÃO OBTER DADOS DE UM CONTATO
  //Como o banco dados as coisas não acontecem instantaneamente, utilizamos o 'future'
  Future<Contact> getContact(int id) async {
    //a função recebe o id do contato
    Database dbContact = await db; //obter o banco de dados
    List<Map> maps = await dbContact.query(
        //retorna uma lista de mapas, obtendo com uma query os dados específicos de um contato
        contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?", //pega o contato onde o 'idColumn' = argumento
        whereArgs: [id]); //argumento id passado como parâmetro

        //verificar se realmente retornou um contato
        if(maps.length > 0){ //se a lista tiver ao menos um elemento
          return Contact.fromMap(maps.first); //retorna um contato, pegando o primeiro 'fist'
        }else{ //senão, ele retorna um null
          return null;
        }
  }

  //------------------------------------------------------------------------------------------------------------------------
  
}

//=========================================================================================================================
//A classe vai definir tudo que o contato vai armazenar
class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

//===========================================================================================================================
  //Construtor que retorna os dados do map para construir os contatos da 'Classe Contact'
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

//===========================================================================================================================
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

//===========================================================================================================================
  @override
  //caso haja necessidade de printar as informações do contato de maneira mais intuitiva é só chamar a função abaixo
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
