import 'package:file_manager/app/router/route/folder_route_args.dart';
import 'package:file_manager/core/utils/utils.dart';
import 'package:file_manager/presentation/explorer/page/explorer_page.dart';
import 'package:file_manager/presentation/search/page/search_page.dart';
import 'package:file_manager/presentation/settings/page/settings_page.dart';
import 'package:file_manager/presentation/text/page/text_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  initialExtra: FolderRouteArgs(
    path: defaultPath,
  ),
  routes: [
    ExplorerPage.route,
    SettingsPage.route,
    TextEditorPage.route,
    SearchPage.route,
  ],
);
