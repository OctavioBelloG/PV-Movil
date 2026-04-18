//modificar despues del bloc
//crear el estado
//--pa modificar
part of 'cuenta_bloc.dart';

//import '';'package:equatable/equatable.dart';



class CuentaState extends Equatable{
  final double total;
  final List<Movimiento> movimientos; //se van a llevr todas la variabels o estados que se van a manejar en el bloc, en este caso el total y la lista de movimientosl

  const CuentaState({
    this.total = 0, 
    this.movimientos = const []
  });

  CuentaState copyWith({
    double? total,//deben de ser opcionales en caso de ser necesario solo actualizar un dato
    List<Movimiento>? movimientos,
  }) => CuentaState( //la funcion flecha => funciona como un return sin llaves
    total: total ?? this.total,//los ?? significa una validacion que si no llega le asigna otro valor, 
    movimientos: movimientos ?? this.movimientos, //si no llega una nueva lista de movimientos se mantiene vacio
  );
  
  @override
  List<Object> get props => [total, movimientos];
  //metodo para copiar el estado actual y modificar solo los campos necesarios
  
}