
import 'dz3_flutter_platform_interface.dart';

class Dz3Flutter {
  Future<String?> getPlatformVersion() {
    return Dz3FlutterPlatform.instance.getPlatformVersion();
  }
}
