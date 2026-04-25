package com.aaddoune.khayr

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val SETTINGS_CHANNEL = "com.khayr.app/settings"
    private val ALARM_CHANNEL    = "com.khayr.app/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ── Existing settings channel ─────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openExactAlarmSettings") {
                    try {
                        startActivity(Intent().apply {
                            action = Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM
                            data   = Uri.fromParts("package", packageName, null)
                        })
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Could not open settings", e.message)
                    }
                } else result.notImplemented()
            }

        // ── Native alarm channel ──────────────────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAlarm" -> {
                        val epochMs     = (call.argument<Number>("epochMs") ?: run { result.error("ARG","missing epochMs",null); return@setMethodCallHandler }).toLong()
                        val ringtoneKey = call.argument<String>("ringtoneKey")  ?: "adhan_1"
                        val isEnglish   = call.argument<Boolean>("isEnglish")   ?: false
                        scheduleNativeAlarm(epochMs, ringtoneKey, isEnglish)
                        result.success(true)
                    }
                    "cancelAlarm" -> {
                        cancelNativeAlarm()
                        result.success(true)
                    }
                    "startTestAlarm" -> {
                        val ringtoneKey = call.argument<String>("ringtoneKey")  ?: "adhan_1"
                        val isEnglish   = call.argument<Boolean>("isEnglish")   ?: false
                        startAlarmService(ringtoneKey, isEnglish)
                        result.success(true)
                    }
                    "stopAlarmService" -> {
                        stopAlarmService()
                        result.success(true)
                    }
                    "isAlarmRinging" -> {
                        result.success(AlarmForegroundService.isRinging)
                    }
                    "requestIgnoreBatteryOptimization" -> {
                        requestIgnoreBatteryOptimization()
                        result.success(true)
                    }
                    "isIgnoringBatteryOptimization" -> {
                        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                        result.success(pm.isIgnoringBatteryOptimizations(packageName))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private fun makeAlarmPendingIntent(ringtoneKey: String, isEnglish: Boolean): PendingIntent {
        val intent = Intent(this, AlarmReceiver::class.java).apply {
            putExtra("ringtoneKey", ringtoneKey)
            putExtra("isEnglish", isEnglish)
        }
        return PendingIntent.getBroadcast(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun scheduleNativeAlarm(epochMs: Long, ringtoneKey: String, isEnglish: Boolean) {
        // Persist for BootReceiver
        getSharedPreferences("khayr_alarm", Context.MODE_PRIVATE).edit()
            .putLong("alarm_epoch_ms", epochMs)
            .putString("alarm_ringtone_key", ringtoneKey)
            .putBoolean("alarm_is_english", isEnglish)
            .apply()

        val pi = makeAlarmPendingIntent(ringtoneKey, isEnglish)
        val am = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        // setAlarmClock is the most reliable — survives Doze, shows clock icon in status bar
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            am.setAlarmClock(AlarmManager.AlarmClockInfo(epochMs, pi), pi)
        } else {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, epochMs, pi)
        }
    }

    private fun cancelNativeAlarm() {
        // Clear persisted data
        getSharedPreferences("khayr_alarm", Context.MODE_PRIVATE).edit()
            .remove("alarm_epoch_ms").apply()

        val pi = PendingIntent.getBroadcast(
            this, 0, Intent(this, AlarmReceiver::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        (getSystemService(Context.ALARM_SERVICE) as AlarmManager).cancel(pi)
        stopAlarmService()
    }

    private fun startAlarmService(ringtoneKey: String, isEnglish: Boolean) {
        val intent = Intent(this, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_START
            putExtra("ringtoneKey", ringtoneKey)
            putExtra("isEnglish", isEnglish)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(intent)
        else startService(intent)
    }

    private fun stopAlarmService() {
        startService(Intent(this, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_STOP
        })
    }

    private fun requestIgnoreBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                startActivity(Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:$packageName")
                })
            }
        }
    }
}
