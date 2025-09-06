package com.rechain.vc

import android.app.Application
import androidx.multidex.MultiDex
import androidx.multidex.MultiDexApplication

class REChainApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize MultiDex
        MultiDex.install(this)
        
        // Initialize app-specific components here
        initializeApp()
    }
    
    private fun initializeApp() {
        // Initialize security components
        // Initialize network components
        // Initialize database components
        // etc.
    }
}
