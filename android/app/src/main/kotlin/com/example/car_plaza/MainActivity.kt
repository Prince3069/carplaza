package com.example.car_plaza

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Handle null bundle gracefully
        if (savedInstanceState != null) {
            try {
                // Process saved instance state safely
                super.onCreate(savedInstanceState)
            } catch (e: Exception) {
                // Log the error and continue without saved state
                println("Error restoring saved state: ${e.message}")
                super.onCreate(null)
            }
        }
    }
    
    override fun onSaveInstanceState(outState: Bundle) {
        try {
            super.onSaveInstanceState(outState)
        } catch (e: Exception) {
            // Handle bundle creation errors
            println("Error saving instance state: ${e.message}")
        }
    }
}