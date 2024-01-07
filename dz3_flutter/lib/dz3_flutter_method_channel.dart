import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dz3_flutter_platform_interface.dart';

/// An implementation of [Dz3FlutterPlatform] that uses method channels.
class MethodChannelDz3Flutter extends Dz3FlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dz3_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
