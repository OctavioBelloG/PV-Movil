class Carrito {
  String id;
  String nombre;
  int cantidad;

  Carrito({
    required this.id,
    required this.nombre,
    required this.cantidad,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    return Carrito(
      id: json['id'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
    };
  }
}
