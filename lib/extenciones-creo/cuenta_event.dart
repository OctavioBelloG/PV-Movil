//modificar valores (tercero)
part of 'cuenta_bloc.dart';

//crear una clase


sealed class CuentaEvent { //base para agregar eventos
  //declarar clase base para generar eventos
  const CuentaEvent();
}
//los eventos son los metodos y/o funciones 
//que van a modificar el estado y cada evento es una clase //agregar movimiento y quitar movimiento

class Abonar extends CuentaEvent{ //evento para agregar saldo
  final Movimiento movimiento; //cantidad a agregar
  const Abonar(this.movimiento); //constructor para recibir la cantidad a agregar
}

class Retirar extends CuentaEvent{ //evento para retirar saldo
  final Movimiento movimiento; //cantidad a retirar
  const Retirar(this.movimiento); //constructor para recibir la cantidad a retirar
}