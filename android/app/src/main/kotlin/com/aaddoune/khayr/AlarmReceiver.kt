package com.aaddoune.khayr

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val ringtoneKey = intent.getStringExtra("ringtoneKey") ?: "adhan_1"
        val isEnglish   = intent.getBooleanExtra("isEnglish", false)

        val serviceIntent = Intent(context, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_START
            putExtra("ringtoneKey", ringtoneKey)
            putExtra("isEnglish", isEnglish)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}
