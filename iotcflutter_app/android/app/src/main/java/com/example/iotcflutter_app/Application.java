package com.example.iotcflutter_app;

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;

public class Application extends FlutterApplication
        implements io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        AlarmService.setPluginRegistrant(this);
    }

    @Override

    public void registerWith(io.flutter.plugin.common.PluginRegistry registry) {
        AndroidAlarmManagerPlugin.registerWith(
                registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
                FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
                SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    }
}