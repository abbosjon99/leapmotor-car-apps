package uz.carhelper.passenger.adb;

/** Told how many bytes of an APK have been sent to the installer. Called on the installing thread. */
public interface AdbProgress {
    void onProgress(long done, long total);
}
