import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/journey_model.dart';
import '../services/location_service.dart';

class JourneyProvider extends ChangeNotifier {
  bool _isActive = false;
  Duration _duration = Duration.zero;
  double _distanceKm = 0.0;
  double _elevationGain = 0.0;
  List<Position> _path = [];
  Timer? _timer;

  List<String> _photos = [];

  bool get isActive => _isActive;
  Duration get duration => _duration;
  double get distanceKm => _distanceKm;
  double get elevationGain => _elevationGain;
  List<Position> get path => _path;
  String? get placeName => _path.isNotEmpty ? 'مسار ${path.length}' : null;
  String get journeyId => 'j_${DateTime.now().millisecondsSinceEpoch}';
  String get difficulty => _distanceKm > 10 ? 'صعب' : (_distanceKm > 4 ? 'متوسط' : 'سهل');

  StreamSubscription<Position>? _positionStream;

  void startJourney() async {
    _timer?.cancel();
    _positionStream?.cancel();

    _isActive = true;
    _duration = Duration.zero;
    _distanceKm = 0.0;
    _elevationGain = 0.0;
    _path = [];
    _photos = [];

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });

    final hasPerms = await LocationService.requestPermissions();
    if (hasPerms) {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 5,
        ),
      ).listen((Position position) {
        if (_path.isNotEmpty) {
          final last = _path.last;
          final dist = Geolocator.distanceBetween(
            last.latitude, last.longitude, 
            position.latitude, position.longitude
          );
          _distanceKm += (dist / 1000);

          final altDiff = position.altitude - last.altitude;
          if (altDiff > 0) {
            _elevationGain += altDiff;
          }
        }
        _path.add(position);
        notifyListeners();
      });
    }
    notifyListeners();
  }

  String? _currentPlaceName;
  String? get currentPlaceName => _currentPlaceName;

  void startJourneyWithPlace(String placeName) {
    _currentPlaceName = placeName;
    startJourney();
  }

  void addPhoto(String path) {
    _photos.add(path);
    notifyListeners();
  }

  JourneyModel endJourney(String userId, String placeName) {
    _timer?.cancel();
    _positionStream?.cancel();
    _isActive = false;
    notifyListeners();

    return JourneyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      placeId: 'p_${DateTime.now().millisecondsSinceEpoch}',
      placeName: placeName,
      wilaya: 'الجزائر',
      startTime: DateTime.now().subtract(_duration),
      endTime: DateTime.now(),
      duration: _duration,
      distanceKm: _distanceKm,
      elevationGain: _elevationGain,
      photos: List.from(_photos),
      difficulty: _distanceKm > 10 ? 'صعب' : (_distanceKm > 4 ? 'متوسط' : 'سهل'),
      achievementsUnlocked: [],
      xpEarned: (_distanceKm * 10).toInt() + 50,
    );
  }

  JourneyModel getCurrentJourney(String userId, String? placeName) {
    return JourneyModel(
      id: 'current',
      userId: userId,
      placeId: 'active',
      placeName: placeName ?? 'استكشاف',
      wilaya: 'الجزائر',
      startTime: DateTime.now().subtract(_duration),
      endTime: DateTime.now(),
      duration: _duration,
      distanceKm: _distanceKm,
      elevationGain: _elevationGain,
      photos: List.from(_photos),
      difficulty: _distanceKm > 10 ? 'صعب' : (_distanceKm > 4 ? 'متوسط' : 'سهل'),
      achievementsUnlocked: [],
      xpEarned: (_distanceKm * 10).toInt(),
    );
  }
}
