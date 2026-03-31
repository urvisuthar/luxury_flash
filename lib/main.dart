import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luxury_flash/features/flash_drop/presentation/bloc/flash_drop_bloc.dart';
import 'package:luxury_flash/features/flash_drop/presentation/pages/flash_drop_page.dart';
import 'package:luxury_flash/init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlashDropBloc>(
          create: (_) => serviceLocator<FlashDropBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Luxury Flash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Color(0xFF00E676),
            surface: Colors.black,
          ),
          useMaterial3: true,
        ),
        home: const FlashDropPage(productId: "diamond-watch"),
      ),
    );
  }
}
