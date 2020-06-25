package com.getbouncer;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.getbouncer.cardscan.ui.CardScanActivity;
import com.getbouncer.cardscan.ui.CardScanActivityResult;
import com.getbouncer.cardscan.ui.CardScanActivityResultHandler;

public class RNCardscanModule extends ReactContextBaseJavaModule {
    private static final int SCAN_REQUEST_CODE = 51234;

    public static String apiKey = null;
    public static Boolean enableNameExtraction = false;
    public static Boolean enableEnterCardManually = false;

    private final ReactApplicationContext reactContext;

    private Promise scanPromise;

    @Override
    public void initialize() {
        CardScanActivity.initializeNameExtraction(this.reactContext.getApplicationContext(), apiKey);
    }

    public RNCardscanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(new ActivityEventListener() {

            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
                if (requestCode == SCAN_REQUEST_CODE) {
                    CardScanActivity.parseScanResult(resultCode, data, new CardScanActivityResultHandler() {
                        @Override
                        public void cardScanned(
                                @Nullable String scanId,
                                @NonNull CardScanActivityResult cardScanActivityResult
                        ) {

                            final WritableMap cardMap = new WritableNativeMap();
                            cardMap.putString("number", cardScanActivityResult.getPan());
                            cardMap.putString("expiryMonth", cardScanActivityResult.getExpiryMonth());
                            cardMap.putString("expiryYear", cardScanActivityResult.getExpiryYear());
                            cardMap.putString("issuer", cardScanActivityResult.getNetworkName());
                            cardMap.putString("cardholderName", cardScanActivityResult.getCardholderName());
                            cardMap.putString("cvc", cardScanActivityResult.getCvc());

                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "scanned");
                            map.putMap("payload", cardMap);
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }

                        @Override
                        public void enterManually(String scanId) {
                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "canceled");
                            map.putString("canceled_reason", "enter_card_manually");
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }

                        @Override
                        public void userCanceled(String scanId) {
                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "canceled");
                            map.putString("canceled_reason", "user_canceled");
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }

                        @Override
                        public void cameraError(String scanId) {
                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "canceled");
                            map.putString("canceled_reason", "camera_error");
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }

                        @Override
                        public void analyzerFailure(String scanId) {
                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "canceled");
                            map.putString("canceled_reason", "fatal_error");
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }

                        @Override
                        public void canceledUnknown(String scanId) {
                            final WritableMap map = new WritableNativeMap();
                            map.putString("action", "canceled");
                            map.putString("canceled_reason", "unknown");
                            map.putString("scanId", scanId);

                            scanPromise.resolve(map);
                            scanPromise = null;
                        }
                    });
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
    public void scan(Promise promise) {
        scanPromise = promise;

        final Intent intent = CardScanActivity.buildIntent(this.reactContext.getApplicationContext(), apiKey, enableEnterCardManually, enableNameExtraction, true, true);
        this.reactContext.startActivityForResult(intent, SCAN_REQUEST_CODE, null);
    }
}
