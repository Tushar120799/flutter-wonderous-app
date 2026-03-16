import 'package:http/http.dart' as http;
import 'package:wonders/logic/common/http_client.dart';
import 'package:wonders/logic/data/artifact_data.dart';

class ArtifactAPIService {
  final String _baseMETUrl = 'https://collectionapi.metmuseum.org/public/collection/v1';
  final String _baseSelfHostedUrl = 'https://www.wonderous.info/met';
  final http.Client _httpClient;

  ArtifactAPIService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<ServiceResult<ArtifactData?>> getMetObjectByID(String id) async {
    HttpResponse? response = await HttpClient.sendWithClient(_httpClient, '$_baseMETUrl/objects/$id');
    return ServiceResult<ArtifactData?>(response, _parseArtifactData);
  }

  Future<ServiceResult<ArtifactData?>> getSelfHostedObjectByID(String id) async {
    HttpResponse? response = await HttpClient.sendWithClient(_httpClient, '$_baseSelfHostedUrl/$id.json');
    return ServiceResult<ArtifactData?>(response, _parseArtifactData);
  }

  ArtifactData? _parseArtifactData(Map<String, dynamic> content) {
    // Source: https://metmuseum.github.io/
    return ArtifactData(
      objectId: content['objectID'].toString(),
      title: content['title'] ?? '',
      image: content['primaryImage'] ?? '',
      date: content['objectDate'] ?? '',
      objectType: content['objectName'] ?? '',
      period: content['period'] ?? '',
      country: content['country'] ?? '',
      medium: content['medium'] ?? '',
      dimension: content['dimension'] ?? '',
      classification: content['classification'] ?? '',
      culture: content['culture'] ?? '',
      objectBeginYear: content['objectBeginDate'],
      objectEndYear: content['objectEndDate'],
    );
  }
}
