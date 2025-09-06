package com.rechain.vc

import android.os.Bundle
import androidx.multidex.MultiDex
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize MultiDex for large apps
        MultiDex.install(this)
    }
}
