package com.getbouncer;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.getbouncer.cardscan.CreditCard;
import com.getbouncer.cardscan.ScanActivity;
import com.getbouncer.cardscan.base.ScanActivityImpl;
import com.getbouncer.cardscan.base.ScanBaseActivity;

public class RNCardscanModule extends ReactContextBaseJavaModule {
    private static final int SCAN_REQUEST_CODE = 51234;

    private final ReactApplicationContext reactContext;

    private Promise scanPromise;

    public RNCardscanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(new ActivityEventListener() {

            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
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

                        final String canceled_reason;
                        if (data.getBooleanExtra(ScanBaseActivity.RESULT_ENTER_CARD_MANUALLY_REASON, false)) {
                            canceled_reason = "enter_card_manually";
                        } else if (data.getBooleanExtra(ScanBaseActivity.RESULT_CAMERA_OPEN_ERROR, false)) {
                            canceled_reason = "camera_error";
                        } else if (data.getBooleanExtra(ScanBaseActivity.RESULT_FATAL_ERROR, false)) {
                            canceled_reason = "fatal_error";
                        } else {
                            canceled_reason = "user_canceled";
                        }

                        map.putString("canceled_reason", canceled_reason);
                    } else if (resultCode == ScanActivity.RESULT_CANCELED) {
                        map.putString("action", "canceled");
                    } else {
                        map.putString("action", "unknown");
                    }

                    scanPromise.resolve(map);
                    scanPromise = null;
                }
            }

            @Override
            public void onNewIntent(Intent intent) { }
        });
    }

    @Override
    @NonNull
    public String getName() {
        return "RNCardscan";
    }

    @ReactMethod
    public void isSupportedAsync(Promise promise) {
        promise.resolve(true);
    }

    @ReactMethod
    public void scan(String apiKey, Promise promise) {
        scanPromise = promise;

        ScanBaseActivity.warmUp(this.reactContext.getApplicationContext());
        Intent intent = new Intent(this.reactContext, ScanActivityImpl.class);
        intent.putExtra(ScanActivityImpl.API_KEY, apiKey);
        this.reactContext.startActivityForResult(intent, SCAN_REQUEST_CODE, null);
    }
}
