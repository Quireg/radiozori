package me.sithiramunasinghe.flutter.flutter_radio_player.core.services.support

import android.app.Notification
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
import android.os.Build
import com.google.android.exoplayer2.ui.PlayerNotificationManager
import io.flutter.Log
import me.sithiramunasinghe.flutter.flutter_radio_player.core.services.FRPCoreService

class FRPPlayerNotificationListener(private val frpCoreService: FRPCoreService) :
    PlayerNotificationManager.NotificationListener {

    companion object {
        private const val TAG = "FRPPlayerNotificationListener"
    }

    override fun onNotificationCancelled(
        notificationId: Int,
        dismissedByUser: Boolean
    ) {
        Log.i(TAG, ":::: onNotificationCancelled :::: $dismissedByUser")
        if (dismissedByUser) {
            frpCoreService.stopSelf()
        }
    }

    override fun onNotificationPosted(
        notificationId: Int,
        notification: Notification,
        ongoing: Boolean
    ) {
        Log.i(TAG, "Attaching player to foreground... $notificationId $ongoing")
        if (Build.VERSION.SDK_INT < 34) {
            Log.i(TAG, "startForeground")
            frpCoreService.startForeground(notificationId, notification)
        } else {
            Log.i(TAG, "startForeground with pb")
            frpCoreService.startForeground(notificationId, notification,
                FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        }
    }
}