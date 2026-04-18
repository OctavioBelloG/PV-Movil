import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/extenciones-creo/cuenta_bloc.dart';
import 'package:punto_de_venta_movil/firebase/screen/add_producto_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/edit_producto_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/list_producto_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //     ),
  //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
  //   );
  // }

  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => CuentaBloc(),
      child: MaterialApp(
        title: 'Mi Primera App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {//las rutas
          '/': (_) => ListProductosScreen(),
          '/addProducto': (_) => AddProductoScreen(),
          //'/editProducto': (_) => EditProductoScreen(),
          '/deleteProducto': (_) => DeleteProductoScreen(),
        },
      ),
    );
  }

}
