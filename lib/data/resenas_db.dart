import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/resena.dart';

class ResenasDb {
  ResenasDb._();
  static final ResenasDb instancia = ResenasDb._();
  static const _nombreArchivo = 'resenas.db';
  static const _tabla = 'resenas';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            receta_id INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            texto TEXT NOT NULL,
            calificacion INTEGER NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertar(Resena resena) async {
    final db = await _database;
    return db.insert(_tabla, resena.toMap());
  }

  Future<List<Resena>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'receta_id = ?',
      whereArgs: [recetaId],
      orderBy: 'fecha DESC',
    );
    return filas.map(Resena.fromMap).toList();
  }

}