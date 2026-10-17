import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../app/theme/app_motion.dart';

enum QualityTier { high, mid, low }

/// Process-wide render quality for the 3D layer. Starts from device hints and
/// drops a tier when the first seconds of frames are consistently slow.
class QualityGate extends ChangeNotifier {
  QualityGate._();

  static final QualityGate instance = QualityGate._();

  static const int _slowFrameUs = 20000;
  static const int _slowStreakToDrop = 6;
  static const Duration _watchWindow = Duration(seconds: 3);

  QualityTier _tier = QualityTier.high;
  QualityTier get tier => _tier;

  bool _reduceMotion = false;
  bool _attached = false;
  bool _watching = false;
  int _slowStreak = 0;
  Timer? _watchTimer;

  /// Safe to call from every scene's didChangeDependencies: the first call
  /// picks the starting tier, later calls only track reduce-motion changes.
  void attach(BuildContext context) {
    final reduce = AppMotion.reduceMotion(context);
    if (_attached) {
      if (reduce != _reduceMotion) {
        _reduceMotion = reduce;
        notifyListeners();
      }
      return;
    }
    _attached = true;
    _reduceMotion = reduce;

    final wide = MediaQuery.sizeOf(context).width >= 900;
    final compact = MediaQuery.sizeOf(context).shortestSide < 600;
    if (reduce || compact || defaultTargetPlatform == TargetPlatform.iOS) {
      _tier = QualityTier.low;
    } else if (wide && _hasMouse()) {
      _tier = QualityTier.high;
    } else {
      _tier = QualityTier.mid;
    }

    if (_tier != QualityTier.low) {
      _watching = true;
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
      _watchTimer = Timer(_watchWindow, _stopWatching);
    }
  }

  int get particleBudget => switch (_tier) {
    QualityTier.high => 600,
    QualityTier.mid => 280,
    QualityTier.low => 0,
  };

  bool get enableSpin => _tier != QualityTier.low && !_reduceMotion;

  static bool _hasMouse() {
    if (RendererBinding.instance.mouseTracker.mouseIsConnected) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.macOS || TargetPlatform.windows || TargetPlatform.linux => true,
      _ => false,
    };
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      if (t.totalSpan.inMicroseconds > _slowFrameUs) {
        _slowStreak++;
      } else {
        _slowStreak = 0;
      }
      if (_slowStreak >= _slowStreakToDrop) {
        _slowStreak = 0;
        _tier = _tier == QualityTier.high ? QualityTier.mid : QualityTier.low;
        if (_tier == QualityTier.low) _stopWatching();
        notifyListeners();
        if (!_watching) return;
      }
    }
  }

  void _stopWatching() {
    if (!_watching) return;
    _watching = false;
    _watchTimer?.cancel();
    _watchTimer = null;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
  }
}
