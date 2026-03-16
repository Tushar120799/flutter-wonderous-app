import 'package:flutter/widgets.dart';
import 'package:wonders/ui/common/utils/page_routes.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> showFullscreenDialogRoute<T>(
    Widget child, {
    bool transparent = false,
  }) async {
    return await navigatorKey.currentState?.push<T>(
      PageRoutes.dialog<T>(child),
    );
  }
}
