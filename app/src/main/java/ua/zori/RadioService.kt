package ua.zori

import android.app.Service
import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.*
import android.util.Log
import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.audio.AudioAttributes
import java.net.URL

/**
 * Created by Artur Menchenko on 14/01/21.
 */

class RadioService : Service() {

    private var TAG = "RadioService"

    private val STREAM_URL = "https://myradio24.org/65822"

    private val TOKEN_TRACK = "acquireTrackToken"
    private val TOKEN_START = "start"
    private val TOKEN_STOP = "stop"

    private var bH: Handler? = null
    private var stateListener: IStateListener? = null
    private var trackListener: ITrackListener? = null
    private var lastTrack: String = ""
    private var wifiLock: WifiManager.WifiLock? = null
    private var innerState = State.STOPPED
    private var _player: SimpleExoPlayer? = null
    private var _notificationHelper: NotificationHelper? = null


    inner class RadioServiceImpl : IRadioServiceInterface.Stub() {
        override fun setTrackListener(t: ITrackListener?) {
            trackListener = t
            trackListener?.onStateChanged(lastTrack)
        }

        override fun stopPlayback() {
            stopPlaybackInternal()
        }

        override fun resume() {
            resumePlaybackInternal()
        }

        override fun startPlayback() {
            startPlaybackInternal()
        }

        override fun setStateListener(t: IStateListener?) {
            stateListener = t
            stateListener?.onStateChanged(innerState.ordinal)
        }

    }

    override fun onBind(intent: Intent?): IBinder? {
        return RadioServiceImpl()
    }

    override fun onCreate() {
        super.onCreate()
        val ht = HandlerThread("ht")
        ht.start()
        bH = Handler(ht.looper)
        setupHeadsetUnplugReceiver()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    fun startPlaybackInternal() {
        if (innerState == State.STOPPED) {
            innerState = State.LOADING
            bH?.removeCallbacksAndMessages(TOKEN_START)
            bH?.postAtTime(startRunnable, TOKEN_START, SystemClock.uptimeMillis())
        }
    }

    fun stopPlaybackInternal() {
        bH?.removeCallbacksAndMessages(TOKEN_TRACK)
        if (innerState == State.STARTED) {
            innerState = State.LOADING
            bH?.removeCallbacksAndMessages(TOKEN_STOP)
            bH?.postAtTime(stopRunnable, TOKEN_STOP, SystemClock.uptimeMillis())
        }
    }

    fun pausePlaybackInternal() {
        bH?.post {
            _player?.pause()
            _notificationHelper?.setPaused()
            innerState = State.PAUSED
            stateListener?.onStateChanged(innerState.ordinal)
        }
    }

    fun resumePlaybackInternal() {
        bH?.post {
            _player?.play()
            _notificationHelper?.setResumed()
            innerState = State.STARTED
            stateListener?.onStateChanged(innerState.ordinal)
        }
    }

    private val startRunnable: Runnable
        get() = Runnable {
            Log.d(TAG, "Starting")
            stateListener?.onStateChanged(innerState.ordinal)

            _notificationHelper = NotificationHelper(this,
                    object : NotificationHelper.PlaybackControlCallback {
                        override fun onPause() {
                            pausePlaybackInternal()
                        }

                        override fun onResume() {
                            resumePlaybackInternal()
                        }
                    })

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForeground(NOTIFICATION_ID,
                        _notificationHelper?.getDefaultOnStartNotification())
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
                    MediaItem.fromUri(Uri.parse(STREAM_URL)))

            _player?.playWhenReady = true
            _player?.prepare()

            //uncomment this if playback stops during wi-fi data transfer.
//            val wifiManager =
//                    applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
//            wifiLock = wifiManager.createWifiLock(WifiManager.WIFI_MODE_FULL_HIGH_PERF, "lock")
//            wifiLock?.acquire()
            bH?.postAtTime(acquireTrackRunnable, TOKEN_TRACK, SystemClock.uptimeMillis())
            innerState = State.STARTED
            stateListener?.onStateChanged(innerState.ordinal)
        }


    private val stopRunnable: Runnable
        get() = Runnable {
            Log.d(TAG, "Stopping")
            _player?.release()
//            if (wifiLock!!.isHeld) {
//                wifiLock?.release()
//            }
            stopForeground(true)
            stopSelf()
            innerState = State.STOPPED
            stateListener?.onStateChanged(innerState.ordinal)
        }

    private val acquireTrackRunnable: Runnable
        get() = Runnable {
            val p = ParsingHeaderData()
            val t = p.getTrackDetails(URL(STREAM_URL))
            lastTrack = t.artist + " " + t.title
            trackListener?.onStateChanged(lastTrack)
            bH?.postAtTime(acquireTrackRunnable, TOKEN_TRACK,
                    SystemClock.uptimeMillis() + 5000)
        }


    private fun setupHeadsetUnplugReceiver() {
        val intentFilter = IntentFilter()
        intentFilter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED)
        intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED)
        registerReceiver(br_bt, intentFilter)
        registerReceiver(br, IntentFilter(Intent.ACTION_HEADSET_PLUG))

    }

    val br_bt = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(intent?.getAction())) {
                val state = intent?.getIntExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE, -1)
                if (state == BluetoothAdapter.STATE_DISCONNECTED) {
                    stopPlaybackInternal()
                }
            }
            if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent?.getAction())) {
                if (intent?.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1)
                        == BluetoothAdapter.STATE_OFF) {
                    stopPlaybackInternal()
                }
            }
        }
    }

    val br = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val state = intent?.getIntExtra("state", -1)
            if (state == 0) {
                stopPlaybackInternal()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(br)
        unregisterReceiver(br_bt)
        _notificationHelper?.onDestroy()
    }

    enum class State {
        STARTED,
        STOPPED,
        LOADING,
        PAUSED
    }
}

