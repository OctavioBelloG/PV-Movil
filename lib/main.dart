import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/extenciones-creo/cuenta_bloc.dart';
import 'package:punto_de_venta_movil/firebase/screen/add_producto_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/delete_producto_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/edit_producto_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/inicio_screen.dart';
import 'package:punto_de_venta_movil/firebase/screen/list_producto_screen.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';
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

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CuentaBloc()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Mi Primera App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
            ),
            themeMode: themeMode,
            initialRoute: '/',
            routes: {
              '/': (_) => Inicio_Screen(),
              '/listProducto': (_) => ListProductosScreen(),
              '/addProducto': (_) => AddProductoScreen(),
              '/editProducto': (_) => EditProductoScreen(),
              '/deleteProducto': (_) => DeleteProductoScreen(),
            },
          );
        },
      ),
    );
  }

}

//home: const ImageWidget(),