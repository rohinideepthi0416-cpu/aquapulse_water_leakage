import 'package:flutter/material.dart';
import '../models/environmental_model.dart';
import '../services/api_service.dart';

class EnvironmentalProvider extends ChangeNotifier {
  final ApiService _apiService;

  EnvironmentalModel? _data;
  bool _isLoading = false;
  String? _errorMessage;

  EnvironmentalProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  EnvironmentalModel? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchData({bool force = false}) async {
    if (_data != null && !force) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await _apiService.fetchEnvironmentalData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage =
          'Could not fetch live environmental data. Displaying local model.';
      _data = EnvironmentalModel.mock();
      _isLoading = false;
      notifyListeners();
    }
  }

  void retry() {
    fetchData(force: true);
  }
}
