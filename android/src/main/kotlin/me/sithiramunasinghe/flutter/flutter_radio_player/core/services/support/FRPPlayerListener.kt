package me.sithiramunasinghe.flutter.flutter_radio_player.core.services.support

import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaMetadata
import com.google.android.exoplayer2.PlaybackException
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.ui.PlayerNotificationManager
import io.flutter.Log
import me.sithiramunasinghe.flutter.flutter_radio_player.core.data.*
import me.sithiramunasinghe.flutter.flutter_radio_player.core.enums.FRPPlaybackStatus
import me.sithiramunasinghe.flutter.flutter_radio_player.core.events.FRPPlayerEvent
import me.sithiramunasinghe.flutter.flutter_radio_player.core.services.FRPCoreService
import org.greenrobot.eventbus.EventBus

class FRPPlayerListener(
    private val frpCoreService: FRPCoreService,
    private val exoPlayer: ExoPlayer?,
    private val playerNotificationManager: PlayerNotificationManager?,
    private val eventBus: EventBus
) : Player.Listener {

    companion object {
        private const val TAG = "FRPPlayerListener"
    }

    override fun onDeviceVolumeChanged(volume: Int, muted: Boolean) {
        if (muted) {
            eventBus.post(FRPPlayerEvent(type = FRP_VOLUME_MUTE))
        } else {
            eventBus.post(FRPPlayerEvent(type = FRP_VOLUME_CHANGED, volumeChangeEvent = FRPVolumeChangeEvent(volume = volume.toFloat())))
        }
    }

    override fun onMediaMetadataChanged(mediaMetadata: MediaMetadata) {
        Log.i(TAG, ":::: meta details changed ::::")
        if (frpCoreService.useICYData) {
            frpCoreService.currentMetaData = mediaMetadata
            if (!mediaMetadata.title.isNullOrEmpty()) {
                Log.i(TAG, "CURRENT SONG: " + mediaMetadata.title.toString())
                eventBus.post(FRPPlayerEvent(icyMetaDetails = mediaMetadata.title.toString()))
                playerNotificationManager?.invalidate()
            }
        } else {
            Log.i(TAG, "ICY details are not enabled (optional). Refer documentation")
        }
    }

    override fun onIsPlayingChanged(isPlaying: Boolean) {
        Log.i(TAG, " :::: isPlaying status changed :::: ")
        if (isPlaying) {
            frpCoreService.playbackStatus = FRP_PLAYING
            frpCoreService.currentMetaData?.let {
                eventBus.post(FRPPlayerEvent(icyMetaDetails = it.title.toString(), playbackStatus = frpCoreService.playbackStatus))
            } ?: kotlin.run {
                eventBus.post(FRPPlayerEvent(playbackStatus = frpCoreService.playbackStatus))
            }
            FRP_PLAYING
        } else {
            if (frpCoreService.playbackStatus != FRP_STOPPED) {
                frpCoreService.playbackStatus = FRP_PAUSED
                frpCoreService.currentMetaData?.let {
                    eventBus.post(FRPPlayerEvent(icyMetaDetails = it.title.toString(), playbackStatus = frpCoreService.playbackStatus))
                } ?: kotlin.run {
                    eventBus.post(FRPPlayerEvent(playbackStatus = frpCoreService.playbackStatus))
                }
                FRP_PAUSED
            }
        }
    }

    override fun onPlaybackStateChanged(playbackState: Int) {
        Log.i(TAG, ":::: PlayerEvent CHANGED ::::")
        frpCoreService.playbackStatus = when (playbackState) {
            Player.STATE_BUFFERING -> {
                eventBus.post(FRPPlayerEvent(playbackStatus = FRP_LOADING))
                FRP_LOADING
            }
            Player.STATE_IDLE -> {
                frpCoreService.stopForeground(true)
                Log.i(TAG, "Notification Removed")
                frpCoreService.stopSelf()
                frpCoreService.onDestroy()
                eventBus.post(FRPPlayerEvent(playbackStatus = FRP_STOPPED))
                FRP_STOPPED
            }
            Player.STATE_READY -> {
                if (exoPlayer!!.playWhenReady) {
                    frpCoreService.playbackStatus = FRP_PLAYING
                    frpCoreService.currentMetaData?.let {
                        eventBus.post(FRPPlayerEvent(icyMetaDetails = it.title.toString(), playbackStatus = frpCoreService.playbackStatus))
                    } ?: kotlin.run {
                        eventBus.post(FRPPlayerEvent(playbackStatus = frpCoreService.playbackStatus))
                    }
                    FRP_PLAYING
                } else {
                    frpCoreService.playbackStatus = FRP_PAUSED
                    frpCoreService.currentMetaData?.let {
                        eventBus.post(FRPPlayerEvent(icyMetaDetails = it.title.toString(), playbackStatus = frpCoreService.playbackStatus))
                    } ?: kotlin.run {
                        eventBus.post(FRPPlayerEvent(playbackStatus = frpCoreService.playbackStatus))
                    }
                    FRP_PAUSED
                }
            }
            else -> {
                eventBus.post(FRPPlayerEvent(playbackStatus = FRP_STOPPED))
                frpCoreService.stopForeground(true)
                Log.i(TAG, "Notification Removed")
                frpCoreService.stopSelf()
                FRP_STOPPED
            }
        }
        Log.i(TAG, "Current PlayBackStatus = ${frpCoreService.playbackStatus}")
    }

    override fun onPlayerError(error: PlaybackException) {
        eventBus.post(FRPPlayerEvent(playbackStatus = FRP_STOPPED))
        frpCoreService.playbackStatus = FRP_STOPPED
        Log.e(TAG, error.message!!)
    }
}