package ua.zori

import android.content.ServiceConnection
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel


/**
 * Created by artur.menchenko on 14/01/21.
 */

class UIStateViewModel:ViewModel() {

    val currentState:MutableLiveData<Int> by lazy {
        MutableLiveData<Int>().also {
            loadState()
        }
    }

    private fun loadState() {

    }

}