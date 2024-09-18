import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/folder_bloc.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  static String routeName = 'folder';

  static RouteBase route = GoRoute(
    path: '/',
    name: routeName,
    builder: (context, state) => BlocProvider(
      create: (context) => FolderBloc(
        path: state.path ?? '/',
      ),
      child: const FolderPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FolderBloc, FolderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Placeholder();
      },
    );
  }
}
