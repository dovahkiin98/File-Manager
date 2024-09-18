import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'app/bloc/app_cubit/app_cubit.dart';
import 'app/init_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initApp();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AppCubit(),
      ),
    ],
    child: const MyApp(),
  ));
}
