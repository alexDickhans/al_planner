// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.3.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../third_party/motion_profiling/path.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `actual_work_get_av`, `actual_work_get_t`, `actual_work_get_v`, `actual_work`
// These types are ignored because they are not used by any `pub` functions: `MP`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `deref`, `from`, `initialize`

BigInt getDuration({required Path path}) =>
    RustLib.instance.api.crateApiSimpleGetDuration(path: path);

Pose getPose({required double t}) =>
    RustLib.instance.api.crateApiSimpleGetPose(t: t);

double getVelocity({required double t}) =>
    RustLib.instance.api.crateApiSimpleGetVelocity(t: t);

double getAngularVelocity({required double t}) =>
    RustLib.instance.api.crateApiSimpleGetAngularVelocity(t: t);

class Pose {
  final double x;
  final double y;
  final double theta;

  const Pose({
    required this.x,
    required this.y,
    required this.theta,
  });

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ theta.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pose &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          theta == other.theta;
}
