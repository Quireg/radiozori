package ua.zori

import android.content.*
import android.content.pm.ActivityInfo
import android.graphics.ImageDecoder
import android.graphics.drawable.AnimatedImageDrawable
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async

/**
 * Created by Artur Menchenko on 1/4/2021, 5:42 PM.
 * Radiozori
 */
class MainActivity : AppCompatActivity() {
    private var TAG = "MainActivity"
    private var mService: IRadioServiceInterface? = null
    private var mBound: Boolean = false
    private var playpausebutton: PlayPauseButton? = null
    private var _playing: ImageView? = null
    private var _track: TextView? = null
    private var _serviceIntent: Intent? = null
    private var isPaused = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_activity)
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        _serviceIntent = Intent(this, RadioService::class.java)

        playpausebutton = findViewById(R.id.playpausebutton)

        _playing = findViewById(R.id.playing)
        _track = findViewById(R.id.track)

        setupPlayPauseButton()
        setupCopyToClipboardOnTrackTouch()
        setupLinks()

        GlobalScope.async {
            val anim: AnimatedImageDrawable =
                    ImageDecoder.decodeDrawable(ImageDecoder.createSource(resources, R.raw.equi))
                            as AnimatedImageDrawable
            _playing?.setImageDrawable(anim)
            anim.start()
        }
    }

    fun startPlaybackInternal() {
        ContextCompat.startForegroundService(applicationContext, _serviceIntent!!);
        bindService(_serviceIntent, _connection, 0)
    }


    override fun onStart() {
        super.onStart()
        bindService(_serviceIntent, _connection, 0)
        HeadsetHelper(this, object : HeadsetHelper.Callback {
            override fun onResult(connected: Boolean) {
                if (connected) {
                    startPlaybackInternal()
                }
            }
        })
    }

    override fun onStop() {
        super.onStop()
        try {
            unbindService(_connection)
        } catch (ignored: IllegalArgumentException) {
        }
        mBound = false
    }

    private val _connection = object : ServiceConnection {

        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            mService = IRadioServiceInterface.Stub.asInterface(service)
            mBound = true

            mService?.setStateListener(object : IStateListener.Stub() {
                override fun onStateChanged(state: Int) {
                    Handler(Looper.getMainLooper()).post {
                        Log.d(TAG, "StateListener state: " + state)
                        if (state == RadioService.State.LOADING.ordinal) {
                            playpausebutton?.setToPause()
                            _track?.visibility = View.INVISIBLE
                        } else if (state == RadioService.State.STARTED.ordinal) {
                            isPaused = false
                            playpausebutton?.setToPause()
                            _track?.visibility = View.VISIBLE
                            _playing?.visibility = View.VISIBLE
                        } else if (state == RadioService.State.STOPPED.ordinal) {
                            playpausebutton?.setToPlay()
                            _track?.visibility = View.INVISIBLE
                        } else if (state == RadioService.State.PAUSED.ordinal) {
                            isPaused = true
                            playpausebutton?.setToPlay()
                            _track?.visibility = View.INVISIBLE
                            _playing?.visibility = View.INVISIBLE
                        }
                    }
                }
            })
            mService?.setTrackListener(object : ITrackListener.Stub() {
                override fun onStateChanged(track: String?) {
                    Handler(Looper.getMainLooper()).post {
                        Log.d(TAG, "TrackListener state: " + track)
                        _track?.visibility = View.VISIBLE
                        _track?.text = track
                    }
                }
            })
            mService?.startPlayback()
        }

        override fun onServiceDisconnected(arg0: ComponentName) {
            mBound = false
        }
    }

    fun setupCopyToClipboardOnTrackTouch() {
        val clipboardManager: ClipboardManager =
                getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        _track?.setOnClickListener {
            clipboardManager.setPrimaryClip(ClipData.newPlainText(
                    "Track from radiozori", _track?.text))
            Toast.makeText(this, getString(R.string.copied), Toast.LENGTH_SHORT).show()
        }
        _track?.setOnLongClickListener {
            clipboardManager.setPrimaryClip(ClipData.newPlainText(
                    "Track from radiozori", _track?.text))
            Toast.makeText(this, getString(R.string.copied), Toast.LENGTH_SHORT).show()
            true
        }
    }

    fun setupLinks() {
        val radio_link : Button = findViewById(R.id.radio_link)
        radio_link.setOnClickListener {
            startActivity(Intent(Intent.ACTION_VIEW,
                    Uri.parse("https://radiozori.wixsite.com/radio")))
        }
        val fb_link : Button = findViewById(R.id.fb_link)
        fb_link.setOnClickListener {
            startActivity(Intent(Intent.ACTION_VIEW,
                    Uri.parse("https://www.facebook.com/Radiozori")))
        }
    }

    fun setupPlayPauseButton() {
        playpausebutton?.animDuration = 300
        playpausebutton?.setOnClickListener {
            _track?.visibility = View.INVISIBLE
            if (playpausebutton?.state == PlayPauseButton.PLAY) {
                if (isPaused) {
                    isPaused = false
                    mService?.resume()
                } else {
                    startPlaybackInternal()
                }
                playpausebutton?.setToPause()
            } else if (playpausebutton?.state == PlayPauseButton.PAUSE) {
                mService?.setTrackListener(null)
                mService?.setStateListener(null)
                _playing?.visibility = View.INVISIBLE
                mService?.stopPlayback()
                playpausebutton?.setToPlay()
            }
        }
    }
}