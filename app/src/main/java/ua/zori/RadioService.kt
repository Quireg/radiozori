package ua.zori

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.MediaPlayer
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.*
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.PRIORITY_MIN
import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.audio.AudioAttributes
import java.net.URL


/**
 * Created by artur.menchenko on 14/01/21.
 */

const val LOADING = 0
const val PLAYING = 1
const val STOPPED = 2

class RadioService : Service() {

    private var TAG = "RadioService"

    private var NOTIFICATION_ID = 101
    private val TOKEN_TRACK = "acuireTrackToken"
    private val TOKEN_START = "start"
    private val TOKEN_STOP = "stop"

    private val binder = LocalBinder()
    private var bH: Handler? = null
    private var stateListener: StateListener? = null
    private var trackListener: TrackListener? = null
    private var lastState: Int = LOADING
    private var lastTrack: String = ""
    private var wifiLock: WifiManager.WifiLock? = null
    private var isRunning = false
    private var innerState = State.STOPPED
    private var _player: SimpleExoPlayer? = null

    override fun onBind(intent: Intent?): IBinder? {
        return binder
    }

    inner class LocalBinder : Binder() {
        fun getService(): RadioService = this@RadioService
    }

    override fun onCreate() {
        super.onCreate()
        val ht = HandlerThread("ht")
        ht.start()
        bH = Handler(ht.looper)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!isRunning) {
            startPlayback()
        }
        return super.onStartCommand(intent, flags, startId)
    }

    fun setStateListener(l: StateListener) {
        stateListener = l
        l.onStateChanged(lastState)
    }

    fun setTrackListener(l: TrackListener) {
        trackListener = l
        l.onStateChanged(lastTrack)
    }

    fun startPlayback() {
        bH?.post {
            if (innerState == State.STOPPED) {
                innerState = State.LOADING
                bH?.removeCallbacksAndMessages(TOKEN_START)
                bH?.postAtTime(startRunnable, TOKEN_START, SystemClock.uptimeMillis())
            }
        }
    }

    fun stopPlayback() {
        bH?.post {
            if (innerState == State.STARTED) {
                innerState = State.LOADING
                bH?.removeCallbacksAndMessages(TOKEN_STOP)
                bH?.postAtTime(stopRunnable, TOKEN_STOP, SystemClock.uptimeMillis())
            }
        }
    }

    private val startRunnable: Runnable
        get() = Runnable {
            Log.d(TAG, "Starting")
            lastState = LOADING
            stateListener?.onStateChanged(lastState)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val chan = NotificationChannel("RadioZoriService",
                        "RadioZori", NotificationManager.IMPORTANCE_NONE)
                chan.lightColor = Color.BLUE
                chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
                val service = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                service.createNotificationChannel(chan)

                val notificationBuilder = NotificationCompat.Builder(this, "RadioZoriService")
                val notification = notificationBuilder.setOngoing(true)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setPriority(PRIORITY_MIN)
                        .setCategory(Notification.CATEGORY_SERVICE)
                        .build()
                startForeground(NOTIFICATION_ID, notification)
            }


            _player = SimpleExoPlayer.Builder(this)
                    .setWakeMode(PowerManager.PARTIAL_WAKE_LOCK)
                    .build()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                _player?.setAudioAttributes(AudioAttributes.Builder()
                                .setContentType(C.CONTENT_TYPE_MUSIC)
                                .build()
                )
            }
            _player?.setMediaItem(
                    MediaItem.fromUri(Uri.parse("https://myradio24.org/65822")))

            _player?.playWhenReady = true
            _player?.prepare()

            val wifiManager =
                    applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            wifiLock = wifiManager.createWifiLock(WifiManager.WIFI_MODE_FULL_HIGH_PERF, "lock")
            wifiLock?.acquire()
            bH?.postAtTime(acquireTrackRunnable, TOKEN_TRACK, SystemClock.uptimeMillis())
            innerState = State.STARTED
            lastState = PLAYING
            stateListener?.onStateChanged(lastState)
        }


    private val stopRunnable: Runnable
        get() = Runnable {
            Log.d(TAG, "Stopping")
            _player?.release()
            wifiLock?.release()
            stopForeground(true)
            bH?.removeCallbacksAndMessages(TOKEN_TRACK)
            innerState = State.STOPPED
            lastState = STOPPED
            stateListener?.onStateChanged(lastState)
        }

    private val acquireTrackRunnable: Runnable
        get() = Runnable {
            Log.d(TAG, "acquireTrack")

            _player?.currentMediaItem?.mediaMetadata?.let {
                Log.d(TAG,             "ASD")
            }


            val p = ParsingHeaderData()
            val t = p.getTrackDetails(URL("https://myradio24.org/65822"))
            lastTrack = t.artist + " " + t.title
            trackListener?.onStateChanged(lastTrack)
            bH?.postAtTime(acquireTrackRunnable, TOKEN_TRACK, SystemClock.uptimeMillis() + 5000)
        }

    interface StateListener {
        fun onStateChanged(state: Int)
    }

    interface TrackListener {
        fun onStateChanged(track: String)
    }

    enum class State {
        STARTED,
        STOPPED,
        LOADING
    }
}

