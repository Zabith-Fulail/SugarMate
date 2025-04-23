import '../../utils/enums.dart';

const DeviceOS kDeviceOS = DeviceOS.ANDROID;
const Flavor kFlavor = Flavor.DEV;

///Security Configs
const bool kIsRootCheckAvailable = false;
const bool kIsEmulatorCheckAvailable = false;
const bool kIsADBCheckAvailable = false;

const bool kIsSSLAvailable = false;
const bool kIsSourceVerificationAvailable = false;

const bool kIsSimulatorCheckAvailable = false;
const bool kIsCheckJailBroken = false;

const bool isObfuscation = false;
const bool isDeviceBinding = false;
const bool isHookAvailable = false;

class AppConfig {
  static DeviceOS kDeviceOS = DeviceOS.ANDROID;
}
