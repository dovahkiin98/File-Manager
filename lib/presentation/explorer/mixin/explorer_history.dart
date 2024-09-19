import 'package:file_manager/app/router/route/folder_route_args.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin ExplorerHistory<T extends StatefulWidget> on State<T> {
  String get currentPath => history.last;

  List<String> get history {
    final router = GoRouter.of(context);

    final configuration = router.routerDelegate.currentConfiguration;
    // This is the Main Shell that holds the Bottom Navigation
    final mainShell = configuration.matches.last;

    if (mainShell is! ShellRouteMatch) {
      return [''];
    }

    // This is the shell that holds the Docs Page
    final routes = mainShell.matches;

    return routes.map((e) {
      // If we are in a shell that was pushed, use the matches
      if (e is ImperativeRouteMatch) {
        return (e.matches.extra as FolderRouteArgs).path;
      }

      // Otherwise, use the configuration URI, as it holds the first route
      return (configuration.extra as FolderRouteArgs).path;
    }).toList();
  }
}
