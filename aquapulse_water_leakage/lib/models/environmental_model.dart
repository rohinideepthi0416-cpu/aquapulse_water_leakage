class EnvironmentalModel {
  final double temperature;
  final double humidity;
  final double precipitation;
  final double rain;
  final String timezone;
  final DateTime fetchedAt;
  final String statusSummary;
  final String waterTip;

  EnvironmentalModel({
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.rain,
    required this.timezone,
    required this.fetchedAt,
    required this.statusSummary,
    required this.waterTip,
  });

  factory EnvironmentalModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 26.5;
    final hum = (current['relative_humidity_2m'] as num?)?.toDouble() ?? 68.0;
    final precip = (current['precipitation'] as num?)?.toDouble() ?? 0.0;
    final rainVal = (current['rain'] as num?)?.toDouble() ?? 0.0;
    final tz = json['timezone'] as String? ?? 'Local Zone';

    String summary;
    String tip;
    if (precip > 2.0 || rainVal > 2.0) {
      summary =
          'High precipitation observed. Watch for overflowing tanks and storm runoff.';
      tip =
          'Heavy rain detected! Ensure rainwater harvesting channels are clear and harvest surplus water.';
    } else if (temp > 30.0 && hum < 50.0) {
      summary =
          'High evaporation & dry weather. Community water pressure demand is high.';
      tip =
          'High heat index: Report leaking pipes immediately to avoid major ground absorption loss.';
    } else {
      summary = 'Optimal ambient conditions for municipal supply maintenance.';
      tip =
          'Fixing one dripping tap can save up to 20 litres of clean potable water every day.';
    }

    return EnvironmentalModel(
      temperature: temp,
      humidity: hum,
      precipitation: precip,
      rain: rainVal,
      timezone: tz,
      fetchedAt: DateTime.now(),
      statusSummary: summary,
      waterTip: tip,
    );
  }

  factory EnvironmentalModel.mock() {
    return EnvironmentalModel(
      temperature: 27.4,
      humidity: 64.0,
      precipitation: 0.0,
      rain: 0.0,
      timezone: 'Asia/Kolkata',
      fetchedAt: DateTime.now(),
      statusSummary:
          'Normal weather condition. Consistent water distribution status.',
      waterTip:
          'A single underground pipeline crack wastes over 1,500 litres daily. Report early!',
    );
  }
}
