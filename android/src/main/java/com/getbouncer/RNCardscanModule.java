package com.getbouncer;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.getbouncer.cardscan.CreditCard;
import com.getbouncer.cardscan.ScanActivity;

class BaseActivityEventListener implements ActivityEventListener {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) { }

    @Override
    public void onNewIntent(Intent intent) { }
}

public class RNCardscanModule extends ReactContextBaseJavaModule {
    public static final int SCAN_REQUEST_CODE = 19283;

    private final ReactApplicationContext reactContext;

    private Promise scanPromise;

    private final ActivityEventListener scanEventListener = new BaseActivityEventListener() {

        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            if (requestCode == SCAN_REQUEST_CODE) {
                WritableMap map = new WritableNativeMap();
                if (resultCode == ScanActivity.RESULT_OK && data != null) {
                    CreditCard card = ScanActivity.creditCardFromResult(data);

                    map.putString("action", "scanned");

                    WritableMap cardMap = new WritableNativeMap();
                    cardMap.putString("number", card.getNumber());
                    cardMap.putString("expiryMonth", card.getExpiryMonth());
                    cardMap.putString("expiryYear", card.getExpiryYear());
                    map.putMap("payload", cardMap);
                } else if (resultCode == ScanActivity.RESULT_CANCELED) {
                    map.putString("action", "canceled");
                } else {
                    map.putString("action", "unknown");
                }
                scanPromise.resolve(map);
                scanPromise = null;
            }
        }
    };

    public RNCardscanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(scanEventListener);
    }

    @Override
    public String getName() {
        return "RNCardscan";
    }

    @ReactMethod
    public void isSupportedAsync(Promise promise) {
        promise.resolve(true);
    }

    @ReactMethod
    public void scan(Promise promise) {
        scanPromise = promise;

        Intent intent = new Intent(this.reactContext, RNCardscanActivity.class);
        this.reactContext.startActivityForResult(intent, SCAN_REQUEST_CODE, null);
    }
}
