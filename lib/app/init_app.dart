import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initApp() async {
  await initHydratedStorage();
}

Future<void> initHydratedStorage() async {
  try {
    HydratedBloc.storage;
  } catch (_) {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory(),
    );
  }
}
