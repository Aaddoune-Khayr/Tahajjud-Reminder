package com.aaddoune.khayr

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

/**
 * Re-schedules the alarm after device reboot by reading the saved
 * epoch time + ringtone key from SharedPreferences.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != "android.intent.action.QUICKBOOT_POWERON" &&
            action != Intent.ACTION_MY_PACKAGE_REPLACED) return

        val prefs = context.getSharedPreferences("khayr_alarm", Context.MODE_PRIVATE)
        val epochMs    = prefs.getLong("alarm_epoch_ms", -1L)
        val ringtoneKey = prefs.getString("alarm_ringtone_key", "adhan_1") ?: "adhan_1"
        val isEnglish  = prefs.getBoolean("alarm_is_english", false)

        if (epochMs <= 0 || epochMs < System.currentTimeMillis()) return

        val alarmIntent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("ringtoneKey", ringtoneKey)
            putExtra("isEnglish", isEnglish)
        }
        val pi = PendingIntent.getBroadcast(
            context, 0, alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            am.setAlarmClock(AlarmManager.AlarmClockInfo(epochMs, pi), pi)
        } else {
            am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, epochMs, pi)
        }
    }
}
