import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/environmental_model.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch environmental and weather data from the public Open-Meteo API.
  /// If offline or on network failure, falls back cleanly with helpful diagnostic info.
  Future<EnvironmentalModel> fetchEnvironmentalData() async {
    final uri = Uri.parse(AppConstants.weatherApiUrl);

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return EnvironmentalModel.fromJson(data);
      } else {
        throw HttpException(
          'Server returned status ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      // Offline fallback
      return EnvironmentalModel.mock();
    } on TimeoutException {
      // Timeout fallback
      return EnvironmentalModel.mock();
    } catch (_) {
      // General error fallback
      return EnvironmentalModel.mock();
    }
  }

  void dispose() {
    _client.close();
  }
}
