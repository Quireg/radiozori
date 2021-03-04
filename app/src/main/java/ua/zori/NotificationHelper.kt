package ua.zori

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.*
import android.graphics.Color
import android.os.Build
import android.os.Handler
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat


/**
 * Created by artur.menchenko@globallogic.com on 18/01/21.
 */
const val NOTIFICATION_ID = 101

class NotificationHelper(val context: Context, c: PlaybackControlCallback) {

    val ACTION_START_PLAYBACK = "ua.zori.play"
    val ACTION_STOP_PLAYBACK = "ua.zori.pause"

    var notificationManager: NotificationManager? = null

    init {
        val intentFilterPlayPause = IntentFilter()
        intentFilterPlayPause.addAction(ACTION_START_PLAYBACK)
        intentFilterPlayPause.addAction(ACTION_STOP_PLAYBACK)
        context.registerReceiver(object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (ACTION_STOP_PLAYBACK == intent?.action) {
                    c.onPause()
                }
                if (ACTION_START_PLAYBACK == intent?.action) {
                    c.onResume()
                }
            }
        }, intentFilterPlayPause)
    }

    val play_pause = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (ACTION_STOP_PLAYBACK.equals(intent?.action)) {
                c.onPause()
            }
            if (ACTION_START_PLAYBACK.equals(intent?.action)) {
                c.onResume()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun getDefaultOnStartNotification(): Notification? {
        val chan = NotificationChannel("RadioZoriService",
                        "RadioZori", NotificationManager.IMPORTANCE_LOW)
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager?.createNotificationChannel(chan)

        return getNotification(true)
    }

    fun setPaused() {
        Handler().post {
            Handler().post {
                notificationManager?.notify(NOTIFICATION_ID, getNotification(false))
            }
        }
    }

    fun setResumed() {
        Handler().post {
            notificationManager?.notify(NOTIFICATION_ID, getNotification(true))
        }
    }

    private fun getNotification(start : Boolean) : Notification {
        var notificationLayout : RemoteViews
        if (start) {
            notificationLayout = RemoteViews(context.packageName, R.layout.notification_start)
            notificationLayout.setOnClickPendingIntent(R.id.pause,
                    PendingIntent.getBroadcast(context, 0, Intent(ACTION_STOP_PLAYBACK), 0))
        } else {
            notificationLayout = RemoteViews(context.packageName, R.layout.notification_pause)
            notificationLayout.setOnClickPendingIntent(R.id.play,
                    PendingIntent.getBroadcast(context, 0, Intent(ACTION_START_PLAYBACK), 0))
        }

        val _builder = NotificationCompat.Builder(context, "RadioZoriService")
                .setOngoing(true)
                .setSmallIcon(R.drawable.zzz)
                .setCustomContentView(notificationLayout)
                .setContentIntent(PendingIntent.getActivity(context, 0,
                        Intent.makeMainActivity(ComponentName(
                                context, MainActivity::class.java.name)), 0))

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            _builder.setCategory(Notification.CATEGORY_TRANSPORT)
        }
        return _builder.build()
    }

    fun onDestroy() {
        try {
            context.unregisterReceiver(play_pause)
        } catch (e : IllegalArgumentException) {
        }
    }


    interface PlaybackControlCallback {
        fun onPause()
        fun onResume()
    }
}