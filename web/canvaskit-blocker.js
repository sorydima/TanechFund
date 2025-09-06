// CanvasKit Blocker Script
// This script completely blocks any CanvasKit loading attempts

(function () {
    'use strict';

    console.log('🚫 CanvasKit Blocker loaded - blocking all CanvasKit requests');

    // Block fetch requests to CanvasKit
    const originalFetch = window.fetch;
    window.fetch = function (url, options) {
        if (typeof url === 'string') {
            if (url.includes('canvaskit') || url.includes('gstatic.com/flutter-canvaskit')) {
                console.warn('🚫 Blocked CanvasKit fetch request:', url);
                return Promise.reject(new Error('CanvasKit blocked - using HTML renderer'));
            }
        }
        return originalFetch.call(this, url, options);
    };

    // Block XMLHttpRequest to CanvasKit
    const originalXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function (method, url, async, user, password) {
        if (typeof url === 'string' && (url.includes('canvaskit') || url.includes('gstatic.com/flutter-canvaskit'))) {
            console.warn('🚫 Blocked CanvasKit XHR request:', url);
            throw new Error('CanvasKit blocked - using HTML renderer');
        }
        return originalXHROpen.call(this, method, url, async, user, password);
    };

    // Block dynamic imports of CanvasKit
    const originalImport = window.import;
    if (originalImport) {
        window.import = function (specifier) {
            if (typeof specifier === 'string' && specifier.includes('canvaskit')) {
                console.warn('🚫 Blocked CanvasKit dynamic import:', specifier);
                return Promise.reject(new Error('CanvasKit blocked - using HTML renderer'));
            }
            return originalImport.call(this, specifier);
        };
    }

    // Override Flutter configuration
    window.flutterConfiguration = {
        renderer: "html",
        canvasKitBaseUrl: null,
        canvasKitVariant: null,
        canvasKitForceCpuOnly: false
    };

    // Block CanvasKit global variables
    window.flutterCanvasKit = null;
    window.flutterCanvasKitBaseUrl = null;

    // Override any CanvasKit detection
    Object.defineProperty(window, 'flutterCanvasKit', {
        get: function () {
            console.warn('🚫 CanvasKit access blocked');
            return null;
        },
        set: function (value) {
            console.warn('🚫 CanvasKit assignment blocked');
        },
        configurable: false
    });

    console.log('✅ CanvasKit Blocker active - all CanvasKit requests will be blocked');
})();
