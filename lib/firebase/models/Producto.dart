//clase para el producto
class Producto {
  String? id;
  String nombre;
  String codigoBarras;
  int stock;
  bool activo;
  DateTime fecha;
  Map<String, dynamic> pago; // Map = { metodo, montoRecibido, cambio }

  Producto({
    this.id,
    required this.nombre,
    required this.codigoBarras,
    required this.stock,
    required this.activo,
    required this.fecha,
    required this.pago,
  });

  factory Producto.fromFirebase(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      codigoBarras: json['codigoBarras'],
      stock: json['stock'],
      activo: json['activo'],
      fecha: json['fecha'],
      pago: Map<String, dynamic>.from(json['pago']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'nombre': nombre,
      'codigoBarras': codigoBarras,
      'stock': stock,
      'activo': activo,
      'fecha': fecha.toIso8601String(),
      'pago': pago,
    };
  }

  factory Producto.fromFirebaseDoc(String doc, Map<String, dynamic> json) {
    return Producto(
      id: doc,
      nombre: json['nombre'],
      codigoBarras: json['codigoBarras'],
      stock: json['stock'],
      activo: json['activo'],
      fecha: json['fecha'],
      pago: Map<String, dynamic>.from(json['pago']),
    );
  }

}