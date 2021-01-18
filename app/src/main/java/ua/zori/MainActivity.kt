package ua.zori

import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.os.*
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

/**
 * Created by Artur Menchenko on 1/4/2021, 5:42 PM.
 * Zori App
 */
class MainActivity : AppCompatActivity() {
    private var TAG = "MainActivity"
    private var mService: RadioService? = null
    private var mBound: Boolean = false
    private var playpausebutton: PlayPauseButton? = null
    private var loading: TextView? = null
    private var track: TextView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_activity)
        playpausebutton = findViewById(R.id.playpausebutton)
        loading = findViewById(R.id.loading)
        track = findViewById(R.id.track)
        playpausebutton?.animDuration = 300
        Handler().postDelayed({ playpausebutton?.setToPause() }, 500)

        playpausebutton?.setOnClickListener {
            track?.visibility = View.INVISIBLE
            if (playpausebutton?.state == PlayPauseButton.PLAY) {
                mService?.startPlayback()
                playpausebutton?.setToPause()
            } else if (playpausebutton?.state == PlayPauseButton.PAUSE) {
                mService?.stopPlayback()
                playpausebutton?.setToPlay()
            }
        }

    }

    override fun onStart() {
        super.onStart()
        Intent(this, RadioService::class.java).also { intent ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                applicationContext.startForegroundService(intent)
            } else {
                applicationContext.startService(intent)
            }
            bindService(intent, connection, 0)
        }
    }

    override fun onStop() {
        super.onStop()
        unbindService(connection)
        mBound = false
    }

    private val connection = object : ServiceConnection {

        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance
            val binder = service as RadioService.LocalBinder
            mService = binder.getService()
            mBound = true

            mService?.setStateListener(object : RadioService.StateListener {
                override fun onStateChanged(state: Int) {
                    Handler(Looper.getMainLooper()).post {
                        Log.d(TAG, "StateListener state: " + state)
                        if (state == LOADING) {
                            playpausebutton?.setToPause()
                            loading?.visibility = View.VISIBLE
                            track?.visibility = View.INVISIBLE
                        } else if (state == PLAYING) {
                            playpausebutton?.setToPause()
                            loading?.visibility = View.INVISIBLE
                            track?.visibility = View.VISIBLE
                        } else if (state == STOPPED) {
                            playpausebutton?.setToPlay()
                            loading?.visibility = View.INVISIBLE
                            track?.visibility = View.INVISIBLE
                        }
                    }
                }
            })
            mService?.setTrackListener(object : RadioService.TrackListener {
                override fun onStateChanged(t: String) {
                    Handler(Looper.getMainLooper()).post {
                        Log.d(TAG, "TrackListener state: " + t)
                        track?.visibility = View.VISIBLE
                        track?.text = t
                    }
                }
            })
        }

        override fun onServiceDisconnected(arg0: ComponentName) {
            mBound = false
        }
    }
}