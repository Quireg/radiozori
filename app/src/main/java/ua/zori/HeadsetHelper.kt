package ua.zori

import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.media.AudioManager
import android.os.Build


/**
 * Created by artur.menchenko@globallogic.com on 18/01/21.
 */
class HeadsetHelper(context: Context, c: Callback) {

    init {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            bluetoothManager.adapter.getProfileProxy(context,
                    object : BluetoothProfile.ServiceListener {
                        /** */
                        override fun onServiceDisconnected(profile: Int) {
                            c.onResult(false)
                        }

                        /** */
                        override fun onServiceConnected(profile: Int, proxy: BluetoothProfile?) {
                            val am = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                            c.onResult(proxy!!.connectedDevices.size > 0 || am.isWiredHeadsetOn())
                        }
                    }, BluetoothProfile.HEADSET)
        }
    }

    interface Callback {
        fun onResult(connected: Boolean)
    }

}