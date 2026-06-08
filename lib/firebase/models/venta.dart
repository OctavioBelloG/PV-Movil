import 'package:cloud_firestore/cloud_firestore.dart';
import 'carrito.dart';

class Venta {
  String? id;
  List<Carrito> items;
  int totalUnidades;
  DateTime fecha;

  Venta({
    this.id,
    required this.items,
    required this.totalUnidades,
    required this.fecha,
  });

  factory Venta.fromFirebase(Map<String, dynamic> json) {
    final dynamic rawFecha = json['fecha'];
    DateTime fechaValue;
    if (rawFecha is Timestamp) {
      fechaValue = rawFecha.toDate();
    } else if (rawFecha is String) {
      fechaValue = DateTime.tryParse(rawFecha) ?? DateTime.now();
    } else {
      fechaValue = DateTime.now();
    }

    return Venta(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => Carrito.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalUnidades: json['totalUnidades'] ?? 0,
      fecha: fechaValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalUnidades': totalUnidades,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Venta.fromFirebaseDoc(String doc, Map<String, dynamic> json) {
    final dynamic rawFecha = json['fecha'];
    DateTime fechaValue;
    if (rawFecha is Timestamp) {
      fechaValue = rawFecha.toDate();
    } else if (rawFecha is String) {
      fechaValue = DateTime.tryParse(rawFecha) ?? DateTime.now();
    } else {
      fechaValue = DateTime.now();
    }

    return Venta(
      id: doc,
      items: (json['items'] as List)
          .map((item) => Carrito.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalUnidades: json['totalUnidades'] ?? 0,
      fecha: fechaValue,
    );
  }
}
