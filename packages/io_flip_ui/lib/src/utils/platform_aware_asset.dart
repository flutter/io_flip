import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Definition of a platform aware asset function.
typedef PlatformAwareAsset<T> = T Function({
  required T desktop,
  required T mobile,
  bool isWeb,
  TargetPlatform? overrideDefaultTargetPlatform,
});

/// Returns an asset based on the current platform.
T platformAwareAsset<T>({
  required T desktop,
  required T mobile,
  bool isWeb = kIsWeb,
  TargetPlatform? overrideDefaultTargetPlatform,
}) {
  final platform = overrideDefaultTargetPlatform ?? defaultTargetPlatform;
  final isWebMobile = isWeb &&
      (platform == TargetPlatform.iOS || platform == TargetPlatform.android);

  return isWebMobile ? mobile : desktop;
}

/// {@template device_info}
/// Model with device information.
/// {@endtemplate}
class DeviceInfo extends Equatable {
  /// {@macro device_info}
  const DeviceInfo({
    required this.osVersion,
    required this.platform,
  });

  /// The OS version of the device.
  final int osVersion;

  /// The platform of the device.
  final TargetPlatform platform;

  @override
  List<Object?> get props => [osVersion, platform];
}

/// A predicate that checks if the device is an older Android.
bool isOlderAndroid(DeviceInfo deviceInfo) {
  return deviceInfo.platform == TargetPlatform.android &&
      deviceInfo.osVersion <= 11;
}

/// A predicate that checks if the device is an android device.
bool isAndroid(DeviceInfo deviceInfo) {
  return deviceInfo.platform == TargetPlatform.android;
}

/// Platform aware predicate.
typedef DeviceInfoPredicate = bool Function(DeviceInfo deviceInfo);

/// Device aware predicate.
typedef DeviceInfoAwareAsset<T> = Future<T> Function({
  required DeviceInfoPredicate predicate,
  required T Function() asset,
  required T Function() orElse,
});

/// Returns an asset based on the device information.
Future<T> deviceInfoAwareAsset<T>({
  required DeviceInfoPredicate predicate,
  required T Function() asset,
  required T Function() orElse,
  TargetPlatform? overrideDefaultTargetPlatform,
  DeviceInfoPlugin? overrideDeviceInfoPlugin,
}) async {
  final deviceInfo = overrideDeviceInfoPlugin ?? DeviceInfoPlugin();
  final platform = overrideDefaultTargetPlatform ?? defaultTargetPlatform;

  late DeviceInfo info;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.android) {
    final webInfo = await deviceInfo.webBrowserInfo;
    final userAgent = webInfo.userAgent;

    try {
      late int version;
      if (platform == TargetPlatform.android) {
        version = int.parse(
          userAgent?.split('Android ')[1].split(';')[0].split('.')[0] ?? '',
        );
      } else {
        version = int.parse(
          userAgent?.split('Version/')[1].split(' Mobile')[0].split('.')[0] ??
              '',
        );
      }

      info = DeviceInfo(
        osVersion: version,
        platform: platform,
      );
    } catch (_) {
      return orElse();
    }
  } else {
    return orElse();
  }

  if (predicate(info)) {
    return asset();
  } else {
    return orElse();
  }
}
