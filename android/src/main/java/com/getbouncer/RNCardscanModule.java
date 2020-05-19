package com.getbouncer;

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
import com.getbouncer.cardscan.base.ScanBaseActivity;

class BaseActivityEventListener implements ActivityEventListener {

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) { }
}

public class RNCardscanModule extends ReactContextBaseJavaModule {
    public static final int SCAN_REQUEST_CODE = 19283;

    private final ReactApplicationContext reactContext;

    private Promise scanPromise;

    private final ActivityEventListener scanEventListener = new BaseActivityEventListener() {

        @Override
        public void onActivityResult(int requestCode, int resultCode, Intent data) {
            if (requestCode == SCAN_REQUEST_CODE) {
                WritableMap map = new WritableNativeMap();
                if (resultCode == ScanActivity.RESULT_OK && data != null) {
                    CreditCard card = ScanActivity.creditCardFromResult(data);
                    if (card != null) {

                        map.putString("action", "scanned");

                        WritableMap cardMap = new WritableNativeMap();
                        cardMap.putString("number", card.getNumber());
                        cardMap.putString("expiryMonth", card.getExpiryMonth());
                        cardMap.putString("expiryYear", card.getExpiryYear());
                        cardMap.putString("issuer", card.getNetwork().getDisplayName());
                        map.putMap("payload", cardMap);
                    } else {
                        map.putString("action", "canceled");
                    }
                } else if (resultCode == ScanActivity.RESULT_CANCELED && data != null) {
                    map.putString("action", "canceled");
                    map.putBoolean("enter_card_manually", data.getBooleanExtra(ScanBaseActivity.RESULT_ENTER_CARD_MANUALLY_REASON, false));
                    map.putBoolean("camera_open_error", data.getBooleanExtra(ScanBaseActivity.RESULT_CAMERA_OPEN_ERROR, false));
                    map.putBoolean("fatal_error", data.getBooleanExtra(ScanBaseActivity.RESULT_FATAL_ERROR, false));
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
