import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mpesa_ledger_flutter/blocs/base_bloc.dart';

import 'package:mpesa_ledger_flutter/utils/method_channel/methodChannel.dart';

class RuntimePermissionsBloc extends BaseBloc {
  StreamController<void> _checkAndRequestPermissionController =
      StreamController<void>();
  Stream<void> get checkAndRequestPermissionStream =>
      _checkAndRequestPermissionController.stream;
  StreamSink<void> get checkAndRequestPermissionSink =>
      _checkAndRequestPermissionController.sink;

  StreamController<void> _continueToAppController = StreamController<void>();
  Stream<void> get continueToAppStream => _continueToAppController.stream;
  StreamSink<void> get continueToAppSink => _continueToAppController.sink;

  StreamController<bool> _permissionDenialController = StreamController<bool>.broadcast();
  Stream<bool> get permissionDenialStream => _permissionDenialController.stream;
  StreamSink<bool> get permissionDenialSink => _permissionDenialController.sink;

  StreamController<bool> _openAppSettingsController = StreamController<bool>();
  Stream<bool> get openAppSettingsStream => _openAppSettingsController.stream;
  StreamSink<bool> get openAppSettingsSink => _openAppSettingsController.sink;

  RuntimePermissionsBloc() {
    var methodChannel = MethodChannelClass();
    methodChannel.setMethodCallHandler(_handleCallsFromNative);
    checkAndRequestPermissionStream.listen((void data) async {
      await methodChannel.invokeMethod("isPermissionsAllowed");
    });
  }

  Future<void> _handleCallsFromNative(MethodCall call) async {
    switch (call.method) {
      case "showDialogForDenial":
        permissionDenialSink.add(true);
        break;
      case "showDialogForGoToSettings":
        openAppSettingsSink.add(true);
        break;
      case "continueToApp":
        continueToAppSink.add(null);
        break;
    }
  }

  @override
  void dispose() {
    _continueToAppController.close();
    _checkAndRequestPermissionController.close();
    _permissionDenialController.close();
    _openAppSettingsController.close();
  }
}
