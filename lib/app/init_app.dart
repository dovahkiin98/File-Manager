import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> initApp() async {
  // final androidInfo = await DeviceInfoPlugin().androidInfo;

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // if(androidInfo.version.sdkInt >= 29) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.transparent,
    // ));
  // } else {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.black12,
    //   // systemNavigationBarIconBrightness: Brightness.dark,
    // ));
  // }

  await initHydratedStorage();

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
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
