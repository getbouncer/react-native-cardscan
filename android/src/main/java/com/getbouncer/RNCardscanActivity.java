package com.getbouncer;

import android.content.Intent;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import com.getbouncer.cardscan.ScanActivity;

public class RNCardscanActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ScanActivity.start(this);
    }

    protected void onActivityResult(Integer requestCode, Integer resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (ScanActivity.isScanResult(requestCode)) {
            if (resultCode == ScanActivity.RESULT_OK && data != null) {
                ScanActivity.creditCardFromResult(data);
            } else if (resultCode == ScanActivity.RESULT_CANCELED) {
                if (data.getBooleanExtra(ScanActivity.RESULT_FATAL_ERROR, false)) {
                    // TODO: handle a fatal error with cardscan
                } else {
                    // TODO: the user pressed the back button
                }
            }
        }
    }


}
