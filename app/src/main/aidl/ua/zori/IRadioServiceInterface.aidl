package ua.zori;

import ua.zori.IStateListener;
import ua.zori.ITrackListener;

interface IRadioServiceInterface {

    void startPlayback();
    void stopPlayback();
    void setTrackListener(ITrackListener t);
    void setStateListener(IStateListener t);
    void resume();
}