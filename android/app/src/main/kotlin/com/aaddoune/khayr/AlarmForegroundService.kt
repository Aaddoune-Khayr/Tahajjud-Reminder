package com.aaddoune.khayr

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class AlarmForegroundService : Service() {

    companion object {
        const val ACTION_START    = "ACTION_START_ALARM"
        const val ACTION_STOP     = "ACTION_STOP_ALARM"
        const val NOTIFICATION_ID = 2001
        const val CHANNEL_ID      = "khayr_alarm_fg_v1"
        var isRinging = false
    }

    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP  -> { stopAlarm(); return START_NOT_STICKY }
            ACTION_START -> {
                val ringtoneKey = intent.getStringExtra("ringtoneKey") ?: "adhan_1"
                val isEnglish   = intent.getBooleanExtra("isEnglish", false)
                startAlarm(ringtoneKey, isEnglish)
            }
        }
        return START_NOT_STICKY
    }

    private fun startAlarm(ringtoneKey: String, isEnglish: Boolean) {
        // Keep CPU alive for playback
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "khayr:AlarmWakeLock")
            .apply { acquire(10 * 60 * 1000L) }

        createNotificationChannel()

        val stopPi = PendingIntent.getService(
            this, 0,
            Intent(this, AlarmForegroundService::class.java).apply { action = ACTION_STOP },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val title = "Tahajjud 🌙"
        val body  = if (isEnglish) "Time to wake up for Tahajjud!" else "Il est temps de se réveiller pour Tahajjud !"
        val stopLabel = if (isEnglish) "Stop" else "Arrêter"

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(stopPi)
            .addAction(0, stopLabel, stopPi)
            .build()

        startForeground(NOTIFICATION_ID, notification)

        // Play on STREAM_ALARM — bypasses silent AND vibrate modes
        try {
            val resId = resources.getIdentifier(ringtoneKey, "raw", packageName)
            val uri   = Uri.parse("android.resource://$packageName/$resId")
            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                setDataSource(applicationContext, uri)
                isLooping = false
                setOnCompletionListener { stopAlarm() }
                prepare()
                start()
                isRinging = true
            }
        } catch (e: Exception) {
            stopAlarm()
        }
    }

    private fun stopAlarm() {
        isRinging = false
        mediaPlayer?.runCatching { if (isPlaying) stop(); release() }
        mediaPlayer = null
        wakeLock?.runCatching { if (isHeld) release() }
        wakeLock = null
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Tahajjud Alarm",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                setBypassDnd(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setSound(null, null) // sound handled by MediaPlayer directly
                enableVibration(false)
            }
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() { stopAlarm(); super.onDestroy() }
}
