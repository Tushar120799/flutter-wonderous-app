import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/l10n/app_localizations.dart';
import 'package:wonders/logic/artifact_api_logic.dart';
import 'package:wonders/logic/artifact_api_service.dart';
import 'package:wonders/logic/collectibles_logic.dart';
import 'package:wonders/logic/locale_logic.dart';
import 'package:wonders/logic/native_widget_service.dart';
import 'package:wonders/logic/navigation_service.dart';
import 'package:wonders/logic/timeline_logic.dart';
import 'package:wonders/logic/unsplash_logic.dart';
import 'package:wonders/logic/wonders_logic.dart';
import 'package:wonders/ui/common/app_shortcuts.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash screen up until app is finished bootstrapping
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Start app
  registerSingletons();

  runApp(WondersApp());
  await appLogic.bootstrap();

  // Remove splash screen when bootstrap is complete
  FlutterNativeSplash.remove();
}

/// Creates an app using the [MaterialApp.router] constructor and the global `appRouter`, an instance of [GoRouter].
class WondersApp extends StatefulWidget with GetItStatefulWidgetMixin {
  WondersApp({super.key});

  @override
  State<WondersApp> createState() => _WondersAppState();
}

class _WondersAppState extends State<WondersApp> with GetItStateMixin {
  bool _imagesCached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesCached && kIsWeb) {
      _precacheIcons(context);
      _precacheWonderImages(context);
      _imagesCached = true;
    }
  }

  void _precacheUrl(String url, BuildContext context) async {
    await precacheImage(
      AssetImage(url),
      context,
      onError: (error, stackTrace) {
        print('Loading $url failed - ${error.toString()}');
      },
    );
  }

  void _precacheIcons(BuildContext context) {
    List<String> urls = [];
    for (var i = 0; i < 2; i++) {
      urls.add('${ImagePaths.common}/tab-editorial${i == 0 ? '-active' : ''}.png');
      urls.add('${ImagePaths.common}/tab-photos${i == 0 ? '-active' : ''}.png');
      urls.add('${ImagePaths.common}/tab-artifacts${i == 0 ? '-active' : ''}.png');
      urls.add('${ImagePaths.common}/tab-timeline${i == 0 ? '-active' : ''}.png');
    }
    for (var url in urls) {
      _precacheUrl(url, context);
    }
  }

  void _precacheWonderImages(BuildContext context) {
    List<String> urls = [
      '${ImagePaths.root}/chichen_itza/chichen.png',
      '${ImagePaths.root}/chichen_itza/foreground-left.png',
      '${ImagePaths.root}/chichen_itza/foreground-right.png',
      '${ImagePaths.root}/chichen_itza/top-left.png',
      '${ImagePaths.root}/chichen_itza/top-right.png',
      '${ImagePaths.root}/chichen_itza/sun.png',
      '${ImagePaths.root}/christ_the_redeemer/redeemer.png',
      '${ImagePaths.root}/christ_the_redeemer/foreground-left.png',
      '${ImagePaths.root}/christ_the_redeemer/foreground-right.png',
      '${ImagePaths.root}/christ_the_redeemer/sun.png',
      '${ImagePaths.root}/colosseum/colosseum.png',
      '${ImagePaths.root}/colosseum/foreground-left.png',
      '${ImagePaths.root}/colosseum/foreground-right.png',
      '${ImagePaths.root}/colosseum/sun.png',
      '${ImagePaths.root}/great_wall_of_china/great-wall.png',
      '${ImagePaths.root}/great_wall_of_china/foreground-left.png',
      '${ImagePaths.root}/great_wall_of_china/foreground-right.png',
      '${ImagePaths.root}/great_wall_of_china/sun.png',
      '${ImagePaths.root}/machu_picchu/machu-picchu.png',
      '${ImagePaths.root}/machu_picchu/foreground-back.png',
      '${ImagePaths.root}/machu_picchu/foreground-front.png',
      '${ImagePaths.root}/machu_picchu/sun.png',
      '${ImagePaths.root}/petra/petra.png',
      '${ImagePaths.root}/petra/foreground-left.png',
      '${ImagePaths.root}/petra/foreground-right.png',
      '${ImagePaths.root}/petra/moon.png',
      '${ImagePaths.root}/pyramids/pyramids.png',
      '${ImagePaths.root}/pyramids/foreground-back.png',
      '${ImagePaths.root}/pyramids/foreground-front.png',
      '${ImagePaths.root}/pyramids/moon.png',
      '${ImagePaths.root}/taj_mahal/taj-mahal.png',
      '${ImagePaths.root}/taj_mahal/foreground-left.png',
      '${ImagePaths.root}/taj_mahal/foreground-right.png',
      '${ImagePaths.root}/taj_mahal/sun.png',
      '${ImagePaths.root}/taj_mahal/pool.png',
    ];
    List<String> folderNames = [
      'chichen_itza',
      'christ_the_redeemer',
      'colosseum',
      'great_wall_of_china',
      'machu_picchu',
      'petra',
      'pyramids',
      'taj_mahal',
    ];
    for (var name in folderNames) {
      urls.add('${ImagePaths.root}/$name/flattened.jpg');
      urls.add('${ImagePaths.root}/$name/wonder-button.png');
      urls.add('${ImagePaths.root}/$name/photo-1.jpg');
      urls.add('${ImagePaths.root}/$name/photo-2.jpg');
      urls.add('${ImagePaths.root}/$name/photo-3.jpg');
      urls.add('${ImagePaths.root}/$name/photo-4.jpg');
    }
    for (var url in urls) {
      _precacheUrl(url, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = watchX((SettingsLogic s) => s.currentLocale);
    return MaterialApp.router(
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      locale: locale == null ? null : Locale(locale),
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.routerDelegate,
      shortcuts: AppShortcuts.defaults,
      theme: ThemeData(fontFamily: $styles.text.body.fontFamily, useMaterial3: true),
      color: $styles.colors.black,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

/// Create singletons (logic and services) that can be shared across the app.
void registerSingletons() {
  // Top level app controller
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  // Wonders
  GetIt.I.registerLazySingleton<WondersLogic>(() => WondersLogic());
  // Timeline / Events
  GetIt.I.registerLazySingleton<TimelineLogic>(() => TimelineLogic());
  // Search
  GetIt.I.registerLazySingleton<ArtifactAPILogic>(() => ArtifactAPILogic());
  GetIt.I.registerLazySingleton<ArtifactAPIService>(() => ArtifactAPIService());
  // Settings
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  // Unsplash
  GetIt.I.registerLazySingleton<UnsplashLogic>(() => UnsplashLogic());
  // Collectibles
  GetIt.I.registerLazySingleton<CollectiblesLogic>(() => CollectiblesLogic());
  // Localizations
  GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
  // Home Widget Service
  GetIt.I.registerLazySingleton<NativeWidgetService>(() => NativeWidgetService());
  // Navigation
  GetIt.I.registerLazySingleton<NavigationService>(() => NavigationService());
}

/// Add syntax sugar for quickly accessing the main "logic" controllers in the app
/// We deliberately do not create shortcuts for services, to discourage their use directly in the view/widget layer.
AppLogic get appLogic => GetIt.I.get<AppLogic>();
WondersLogic get wondersLogic => GetIt.I.get<WondersLogic>();
TimelineLogic get timelineLogic => GetIt.I.get<TimelineLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
UnsplashLogic get unsplashLogic => GetIt.I.get<UnsplashLogic>();
ArtifactAPILogic get artifactLogic => GetIt.I.get<ArtifactAPILogic>();
CollectiblesLogic get collectiblesLogic => GetIt.I.get<CollectiblesLogic>();
LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();
NavigationService get navigationService => GetIt.I.get<NavigationService>();

/// Global helpers for readability
AppLocalizations get $strings => localeLogic.strings;
AppStyle get $styles => WondersAppScaffold.style;
