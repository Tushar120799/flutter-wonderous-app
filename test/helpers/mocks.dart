import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:wonders/logic/artifact_api_service.dart';
import 'package:wonders/logic/native_widget_service.dart';

@GenerateMocks([
  ArtifactAPIService,
  NativeWidgetService,
  http.Client,
])
void main() {}
