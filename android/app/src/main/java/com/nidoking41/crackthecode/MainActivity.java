package com.nidoking41.crackthecode;

import android.os.Bundle;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        // The game's own plugins must be registered before the app starts.
        registerPlugin(GameServicesPlugin.class);
        super.onCreate(savedInstanceState);
    }
}
