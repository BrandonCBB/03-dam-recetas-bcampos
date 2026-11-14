class Resena {
  final int? id; 
  final int recetaId;
  final String nombre;
  final String texto;
  final int calificacion;
  final DateTime fecha;

  const Resena({
    this.id,
    required this.recetaId,
    required this.nombre,
    required this.texto,
    required this.calificacion,
    required this.fecha,
  });

  factory Resena.fromMap(Map<String, dynamic> map) {
    return Resena(
      id: map['id'] as int,
      recetaId: map['receta_id'] as int,
      nombre: map['nombre'] as String,
      texto: map['texto'] as String,
      calificacion: map['calificacion'] as int,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'receta_id': recetaId,
        'nombre': nombre,
        'texto': texto,
        'calificacion': calificacion,
        'fecha': fecha.toIso8601String(),
      };

  String get fechaFormateada =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
}