import 'package:cloud_firestore/cloud_firestore.dart';

//clase para el producto
class Producto {
  String? id;
  String? url;
  String nombre;
  String codigoBarras;
  int stock;
  bool activo;
  DateTime fecha;
  Map<String, dynamic> pago; // Map = { metodo, montoRecibido, cambio }

  Producto({
    this.id,
    this.url,
    required this.nombre,
    required this.codigoBarras,
    required this.stock,
    required this.activo,
    required this.fecha,
    required this.pago,
  });

  factory Producto.fromFirebase(Map<String, dynamic> json) {
    final dynamic rawFecha = json['fecha'];
    DateTime fechaValue;
    if (rawFecha is Timestamp) {
      fechaValue = rawFecha.toDate();
    } else if (rawFecha is String) {
      fechaValue = DateTime.tryParse(rawFecha) ?? DateTime.now();
    } else {
      fechaValue = DateTime.now();
    }

    return Producto(
      id: json['id'],
      url: json['url'],
      nombre: json['nombre'],
      codigoBarras: json['codigoBarras'],
      stock: json['stock'] ?? 0,
      activo: json['activo'] ?? false,
      fecha: fechaValue,
      pago: Map<String, dynamic>.from(json['pago'] ?? {}),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'url': url,
      'nombre': nombre,
      'codigoBarras': codigoBarras,
      'stock': stock,
      'activo': activo,
      'fecha': fecha.toIso8601String(),
      'pago': pago,
    };
  }

  factory Producto.fromFirebaseDoc(String doc, Map<String, dynamic> json) {
    final dynamic rawFecha = json['fecha'];
    DateTime fechaValue;
    if (rawFecha is Timestamp) {
      fechaValue = rawFecha.toDate();
    } else if (rawFecha is String) {
      fechaValue = DateTime.tryParse(rawFecha) ?? DateTime.now();
    } else {
      fechaValue = DateTime.now();
    }

    return Producto(
      id: doc,
      url: json['url'] as String?,
      nombre: json['nombre'],
      codigoBarras: json['codigoBarras'],
      stock: json['stock'] ?? 0,
      activo: json['activo'] ?? false,
      fecha: fechaValue,
      pago: Map<String, dynamic>.from(json['pago'] ?? {}),
    );
  }

}