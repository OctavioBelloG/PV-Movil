import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'movimiento.dart';

part 'cuenta_event.dart'; 
part 'cuenta_state.dart';

class CuentaBloc extends Bloc<CuentaEvent, CuentaState>{
  CuentaBloc() : super (const CuentaState()) {
    on<Abonar>((event, emit){
      emit(state.copyWith( //crear un nuevo estado con nuevos movimientos/istas
        total: state.total + event.movimiento.cantidad, //se suma el total actual con la cantidad del movimiento a agregar
        movimientos: [...state.movimientos, //crear una nueva instancia del arrego
          event.movimiento], //se agrega el nuevo movimiento a la lista de movimientos
      ));
    });
    on<Retirar>((event, emit){
      emit(state.copyWith( //crear un nuevo estado con nuevos movimientos/istas
        total: state.total - event.movimiento.cantidad, //se resta la cantidad del movimiento a retirar
        movimientos: [...state.movimientos, //crear una nueva instancia del arrego
          event.movimiento], //se agrega el nuevo movimiento a la lista de movimientos
      ));
    });
  }
}

// class CuentaBloc extends Bloc<CuentaEvent, CuentaState>{//primero eventos luego estados
//   CuentaBloc() : super(const CuentaState()){
//     on<Abonar>((event, emit){
//       emit(state.copyWith(//instancia con nuevos valores
//         movimientos: [...state.movimientos, 
//         event.movimiento], //se agrega el nuevo movimiento a la lista de movimientos
//       ));
//     });
    
//     on<Retirar>((event, emit){

//     });
//   }
// }