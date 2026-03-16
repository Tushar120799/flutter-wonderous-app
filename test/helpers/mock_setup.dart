import 'package:get_it/get_it.dart';
import 'package:wonders/logic/artifact_api_service.dart';
import 'package:wonders/logic/native_widget_service.dart';

import 'mocks.mocks.dart';

/// Registers test doubles in GetIt for the duration of a test.
///
/// Call [setupMocks] in your test's `setUp` callback and
/// [tearDownMocks] in `tearDown` to keep GetIt clean between tests.
MockArtifactAPIService? mockArtifactAPIService;
MockNativeWidgetService? mockNativeWidgetService;

void setupMocks() {
  final gi = GetIt.instance;
  gi.reset();

  mockArtifactAPIService = MockArtifactAPIService();
  mockNativeWidgetService = MockNativeWidgetService();

  gi.registerSingleton<ArtifactAPIService>(mockArtifactAPIService!);
  gi.registerSingleton<NativeWidgetService>(mockNativeWidgetService!);
}

void tearDownMocks() {
  GetIt.instance.reset();
  mockArtifactAPIService = null;
  mockNativeWidgetService = null;
}
