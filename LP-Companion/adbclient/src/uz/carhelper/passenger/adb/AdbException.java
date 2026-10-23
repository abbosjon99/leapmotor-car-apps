package uz.carhelper.passenger.adb;

/** A failure with a short code: NOCONN (adbd not reachable), AUTH (key not accepted / not approved), FAIL (anything else). */
public final class AdbException extends Exception {
    public final String code;

    public AdbException(String code, String message) {
        super(message);
        this.code = code;
    }
}
