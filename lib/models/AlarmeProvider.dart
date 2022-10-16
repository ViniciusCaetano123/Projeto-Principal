import './Alarme.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class AlarmeProvider {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE Alarmes_a(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        hora INTEGER,
        minuto INTEGER,
        domingo INTEGER,
        segunda INTEGER,
        terca INTEGER,
        quarta INTEGER,
        quinta INTEGER,
        sexta INTEGER,
        sabado INTEGER,
        ativo INTEGER
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'databasealarme_teste.db',
      version: 3,
      onCreate: (sql.Database database, int version) async {
        print(database);
        await createTables(database);
      },
    );
  }

  static Future<int> deletarAlarme(int id_alarme) async {
    final db = await AlarmeProvider.db();

    return await db
        .delete('Alarmes_a', where: 'id = ?', whereArgs: [id_alarme]);
  }

  static Future<int> updateAlarme(
      String nome,
      int hora,
      int minuto,
      int domingo,
      int segunda,
      int terca,
      int quarta,
      int quinta,
      int sexta,
      int sabado,
      int ativo,
      int id) async {
    final db = await AlarmeProvider.db();

    final data = {
      'nome': nome,
      'hora': hora,
      'minuto': minuto,
      'domingo': domingo,
      'segunda': segunda,
      'terca': terca,
      'quarta': quarta,
      'quinta': quinta,
      'sexta': sexta,
      'sabado': sabado,
      'ativo': ativo
    };

    return await db.update('Alarmes_a', data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> updateAtivoAlarme(Alarme alarme, int id_alarme) async {
    final db = await AlarmeProvider.db();

    return await db.update('Alarmes_a', alarme.toMap(),
        where: 'id = ?',
        whereArgs: [id_alarme],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> createAlarme(
      String nome,
      int hora,
      int minuto,
      int domingo,
      int segunda,
      int terca,
      int quarta,
      int quinta,
      int sexta,
      int sabado,
      int ativo) async {
    final db = await AlarmeProvider.db();

    final data = {
      'nome': nome,
      'hora': hora,
      'minuto': minuto,
      'domingo': domingo,
      'segunda': segunda,
      'terca': terca,
      'quarta': quarta,
      'quinta': quinta,
      'sexta': sexta,
      'sabado': sabado,
      'ativo': ativo
    };
    final id = await db.insert('Alarmes_a', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Alarme>> getItems() async {
    final db = await AlarmeProvider.db();
    List<Map<String, dynamic>> maps =
        await db.query('Alarmes_a', orderBy: "id DESC");

    return List.generate(maps.length, (index) {
      return Alarme(
          id: maps[index]['id'],
          nome: maps[index]['nome'],
          hora: maps[index]['hora'],
          minuto: maps[index]['minuto'],
          domingo: maps[index]['domingo'],
          sabado: maps[index]['sabado'],
          segunda: maps[index]['segunda'],
          terca: maps[index]['terca'],
          quarta: maps[index]['quarta'],
          quinta: maps[index]['quinta'],
          sexta: maps[index]['sexta'],
          ativo: maps[index]['ativo']);
    });
  }
}
