package com.getbouncer;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNCardscanModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNCardscanModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNCardscan";
    }

    @ReactMethod
    public void testing(String stringArgument, int numberArgument, Callback callback) {
        // TODO: Implement some actually useful functionality
        callback.invoke('Testing bridge');
    }
}
