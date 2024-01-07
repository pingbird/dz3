import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dz3_flutter_method_channel.dart';

abstract class Dz3FlutterPlatform extends PlatformInterface {
  /// Constructs a Dz3FlutterPlatform.
  Dz3FlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static Dz3FlutterPlatform _instance = MethodChannelDz3Flutter();

  /// The default instance of [Dz3FlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelDz3Flutter].
  static Dz3FlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Dz3FlutterPlatform] when
  /// they register themselves.
  static set instance(Dz3FlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
