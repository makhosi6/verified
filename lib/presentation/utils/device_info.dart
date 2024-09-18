import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:verified/domain/models/device.dart';

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'serialNumber': build.serialNumber,
  };
}

Device _readAndroidDevice(AndroidDeviceInfo build) =>
    Device(uuid: '${build.id}_${build.serialNumber}', name: build.model, brand: build.manufacturer);

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'id': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname': data.utsname.sysname,
    'utsname.nodename': data.utsname.nodename,
    'utsname.release': data.utsname.release,
    'utsname.version': data.utsname.version,
    'utsname.machine': data.utsname.machine,
  };
}

Device _readIosDevice(IosDeviceInfo data) => Device(uuid: data.identifierForVendor, name: data.name, brand: 'apple');

Future<Map<String, dynamic>> getCurrentDeviceInfo() async {
  try {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
      TargetPlatform.iOS => _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
      _ => {'name': 'Web'}
    };
  } catch (e) {
    return {'name': 'unknown'};
  }
}

Future<Device?> getCurrentDevice() async {
  try {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _readAndroidDevice(await deviceInfoPlugin.androidInfo),
      TargetPlatform.iOS => _readIosDevice(await deviceInfoPlugin.iosInfo),
      _ => null
    };
  } catch (e) {
    return null;
  }
}
