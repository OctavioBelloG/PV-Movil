import 'package:flutter/material.dart';

class Venta{
String? idVenta;
double total;
DateTime fecha_venta;
String? tipo_pago;

Venta({
  this.idVenta,
  required this.total,
  required this.fecha_venta,
  this.tipo_pago,
});
}