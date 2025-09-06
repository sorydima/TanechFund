# Monitoring and Alerting Configuration

This document provides comprehensive guidance on monitoring and alerting configuration for the REChain VC Flutter project. It covers application performance monitoring, infrastructure monitoring, error tracking, and alerting systems integration.

## 🎯 Monitoring Strategy Overview

### Monitoring Objectives
- **Application Performance:** Track Flutter app performance across all platforms
- **Error Tracking:** Real-time error detection and crash reporting
- **Infrastructure Health:** Monitor servers, containers, and cloud resources
- **Business Metrics:** Track user engagement and blockchain transaction metrics
- **Security Monitoring:** Detect security events and compliance violations
- **Cost Management:** Monitor cloud resource usage and costs

### Monitoring Layers
1. **Application Layer:** Flutter app performance, API response times, user interactions
2. **Infrastructure Layer:** Server health, container metrics, database performance
3. **Business Layer:** User metrics, transaction volumes, conversion rates
4. **Security Layer:** Authentication events, access patterns, vulnerability alerts
5. **Compliance Layer:** Audit logs, data retention, regulatory compliance

## 📊 Application Performance Monitoring

### Sentry Configuration
**sentry.properties (gitignored):**
```properties
defaults.url=https://sentry.io/
defaults.org=rechain-vc
defaults.project=flutter-app
auth.token=sntrys_YOUR_AUTH_TOKEN
project=123456
organization=789012
dhcp=true
```

**.github/workflows/sentry-release.yml:**
```yaml
name: Sentry Release

on:
  push:
    tags: [ 'v*.*.*' ]
  release:
    types: [published]

jobs:
  sentry:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Create Sentry release
        uses: getsentry/action-release@v1
        env:
          SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
          SENTRY_ORG: rechain-vc
          SENTRY_PROJECT: flutter-app
        with:
          environment: production
          version: ${{ github.ref_name }}
          set_commits: 'url:${{ github.server_url }}/${{ github.repository }}'
          finalize: true

      - name: Upload sourcemaps
        run: |
          flutter build web --release --sourcemaps
          sentry-cli releases files ${{ github.ref_name }} upload-sourcemaps build/web/ --url-prefix '~/'
        env:
          SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
          SENTRY_ORG: rechain-vc
          SENTRY_PROJECT: flutter-app
```

**lib/services/sentry_service.dart:**
```dart
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> initialize() async {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = 'https://YOUR_DSN@sentry.io/PROJECT_ID'
          ..tracesSampleRate = 1.0
          ..environment = kReleaseMode ? 'production' : 'development'
          ..release = 'rechain-vc@${PackageInfo().version}';
        
        // Performance monitoring
        options.tracesSampleRate = 1.0;
        
        // Add breadcrumbs for user actions
        options.beforeSend = (event, hint) {
          // Add Flutter-specific context
          event.contexts.add(Context(
            'flutter',
            data: {
              'platform': Platform.operatingSystem,
              'flutter_version': flutterVersion,
              'device_model': deviceInfo.model,
            },
          ));
          return event;
        };
      },
      appRunner: () => runZonedGuarded(
        () => main(),
        (error, stackTrace) => Sentry.captureException(
          error,
          stackTrace: stackTrace,
        ),
      ),
    );
  }

  static void captureError(dynamic error, [StackTrace? stackTrace]) {
    Sentry.captureException(
      error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  static void addBreadcrumb(String message, Map<String, dynamic>? data) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        data: data,
        category: 'user_action',
        timestamp: DateTime.now(),
      ),
    );
  }

  static void capturePerformance(String operation, Duration duration) {
    Sentry.captureMessage(
      '$operation completed in ${duration.inMilliseconds}ms',
      level: SentryLevel.info,
    );
  }
}

// Usage in app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryService.initialize();
  runApp(MyApp());
}
```

### Firebase Performance Monitoring
**pubspec.yaml:**
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_performance: ^0.9.3+8
```

**lib/services/firebase_perf.dart:**
```dart
import 'package:firebase_performance/firebase_performance.dart';

class FirebasePerfService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;

  static Trace startTrace(String name) {
    return _performance.trace(name);
  }

  static Future<void> logCustomMetric(String metricName, double value) async {
    final metric = CustomTrace(metricName);
    await metric.start();
    metric.setMetric('value', value);
    await metric.stop();
  }

  static Future<void> logHttpRequest(String url, int statusCode, Duration duration) async {
    final httpMetric = HttpMetric(url, HttpMethod.get);
    await httpMetric.start();
    httpMetric.responseCode = statusCode;
    httpMetric.responsePayloadBytes = 1024; // Approximate
    httpMetric.requestPayloadBytes = 512;
    await httpMetric.stop();
  }
}

// Usage example
Future<void> fetchUserData() async {
  final trace = FirebasePerfService.startTrace('fetch_user_data');
  try {
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse('/api/user'));
    stopwatch.stop();
    
    await FirebasePerfService.logHttpRequest(
      'user_api',
      response.statusCode,
      stopwatch.elapsed,
    );
    
    trace.stop();
  } catch (e) {
    trace.stop();
    rethrow;
  }
}
```

## 🏢 Infrastructure Monitoring

### Prometheus Configuration
**prometheus.yml:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s

rule_files:
  - 'alert.rules.yml'

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  # Flutter Web Application
  - job_name: 'flutter-web'
    static_configs:
      - targets: ['web-app:9113']
    metrics_path: '/metrics'
    scrape_interval: 10s
    relabel_configs:
      - source_labels: [__meta_traefik_service_name]
        target_label: service
        regex: (.*)

  # Backend API
  - job_name: 'backend-api'
    static_configs:
      - targets: ['backend:3000']
    metrics_path: '/metrics'
    scrape_interval: 15s

  # Database
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']
    scrape_interval: 30s

  # Redis
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
    scrape_interval: 30s

  # Node Exporter (System Metrics)
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
    scrape_interval: 15s

  # Docker Daemon
  - job_name: 'docker'
    static_configs:
      - targets: ['cadvisor:8080']
    scrape_interval: 15s

  # Blockchain Node
  - job_name: 'geth'
    static_configs:
      - targets: ['geth:6060']
    scrape_interval: 30s
```

### Grafana Dashboard Configuration
**grafana-provisioning/dashboards/flutter-app.json:**
```json
{
  "dashboard": {
    "title": "Flutter App Monitoring",
    "panels": [
      {
        "title": "API Response Time",
        "type": "timeseries",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(backend_http_request_duration_seconds_bucket[5m])) * 1000",
            "legendFormat": "95th percentile"
          },
          {
            "expr": "rate(backend_http_request_duration_seconds_sum[5m]) / rate(backend_http_request_duration_seconds_count[5m]) * 1000",
            "legendFormat": "Average"
          }
        ],
        "yaxis": {
          "unit": "ms",
          "min": 0
        },
        "thresholds": [
          {
            "color": "green",
            "value": null
          },
          {
            "color": "yellow",
            "value": 200
          },
          {
            "color": "red",
            "value": 500
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "stat",
        "targets": [
          {
            "expr": "rate(backend_http_requests_total{status=~\"5..\"}[5m]) / rate(backend_http_requests_total[5m]) * 100",
            "format": "percent"
          }
        ],
        "colorMode": "value",
        "thresholds": [
          {
            "color": "green",
            "value": null
          },
          {
            "color": "yellow",
            "value": 1
          },
          {
            "color": "red",
            "value": 5
          }
        ]
      },
      {
        "title": "Database Query Duration",
        "type": "timeseries",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(pg_stat_database_xact_commit_time_bucket[5m]))",
            "legendFormat": "95th percentile commit time"
          }
        ],
        "yaxis": {
          "unit": "s"
        }
      },
      {
        "title": "Blockchain Transaction Rate",
        "type": "timeseries",
        "targets": [
          {
            "expr": "rate(geth_eth_transactions[5m])",
            "legendFormat": "Transactions per second"
          }
        ],
        "yaxis": {
          "unit": "reqps"
        }
      },
      {
        "title": "Container Resource Usage",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(container_cpu_usage_seconds_total{container=~\"backend|flutter-web\"}) by (container)",
            "legendFormat": "{{container}} CPU"
          }
        ],
        "colorMode": "background"
      }
    ],
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "refresh": "30s",
    "timezone": "browser",
    "repeat": "1m"
  },
  "folder": 0,
  "overwrite": false
}
```

### Alert Rules (prometheus/alert.rules.yml)
```yaml
groups:
  - name: flutter-app
    rules:
      # API Response Time Alerts
      - alert: APISlowResponse
        expr: histogram_quantile(0.95, rate(backend_http_request_duration_seconds_bucket[5m])) > 0.5
        for: 2m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "API response time is above 500ms ({{ $value }}s)"
          description: "95th percentile API response time is {{ $value }}s for the last 5 minutes"
          runbook_url: "https://rechain.vc/docs/runbooks/api-performance"

      - alert: APIHighErrorRate
        expr: rate(backend_http_requests_total{status=~\"5..\"}[5m]) / rate(backend_http_requests_total[5m]) > 0.05
        for: 1m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High error rate detected ({{ $value | humanizePercentage }})"
          description: "Error rate is {{ $value | humanizePercentage }} for the last 5 minutes"
          runbook_url: "https://rechain.vc/docs/runbooks/error-rate"

      # Database Alerts
      - alert: DatabaseHighLoad
        expr: rate(pg_stat_activity_count[5m]) > 100
        for: 2m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Database under high load ({{ $value }} active connections)"
          description: "PostgreSQL has {{ $value }} active connections"
          runbook_url: "https://rechain.vc/docs/runbooks/database-load"

      - alert: DatabaseReplicationLag
        expr: pg_replication_lag > 30
        for: 1m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "Database replication lag is {{ $value }} seconds"
          description: "Replication lag between primary and replica is {{ $value }} seconds"
          runbook_url: "https://rechain.vc/docs/runbooks/replication-lag"

      # Infrastructure Alerts
      - alert: ContainerHighMemory
        expr: (container_memory_usage_bytes{container=~\"backend|flutter-web\"} / container_spec_memory_limit_bytes{container=~\"backend|flutter-web\"}) > 0.8
        for: 2m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Container memory usage high ({{ $value | humanizePercentage }})"
          description: "Container {{ $labels.container }} using {{ $value | humanizePercentage }} of memory limit"
          runbook_url: "https://rechain.vc/docs/runbooks/memory-usage"

      - alert: ContainerDown
        expr: up{job="docker"} == 0
        for: 1m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "Container {{ $labels.container }} is down"
          description: "Docker container {{ $labels.container }} is not responding"
          runbook_url: "https://rechain.vc/docs/runbooks/container-down"

      # Business Alerts
      - alert: LowTransactionVolume
        expr: rate(backend_eth_transactions_total[1h]) < 10
        for: 30m
        labels:
          severity: warning
          team: business
        annotations:
          summary: "Low transaction volume detected ({{ $value }}/hour)"
          description: "Transaction volume is {{ $value }}/hour, below expected threshold"
          runbook_url: "https://rechain.vc/docs/runbooks/transaction-volume"

      - alert: HighFailedTransactions
        expr: rate(backend_eth_transaction_errors_total[5m]) / rate(backend_eth_transactions_total[5m]) > 0.1
        for: 2m
        labels:
          severity: critical
          team: blockchain
        annotations:
          summary: "High failed transaction rate ({{ $value | humanizePercentage }})"
          description: "Failed transactions rate is {{ $value | humanizePercentage }}"
          runbook_url: "https://rechain.vc/docs/runbooks/failed-transactions"
```

## 📱 Flutter-Specific Monitoring

### Platform-Specific Metrics
**Android Performance (lib/services/android_perf.dart):**
```dart
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AndroidPerformanceMonitor {
  static const MethodChannel _channel = MethodChannel('android_perf');

  static Future<Map<String, dynamic>> getPerformanceMetrics() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getMetrics');
      return {
        'cpu_usage': result['cpuUsage'],
        'memory_usage': result['memoryUsage'],
        'battery_level': result['batteryLevel'],
        'network_speed': result['networkSpeed'],
        'app_start_time': result['appStartTime'],
      };
    } catch (e) {
      SentryService.captureError(e);
      return {};
    }
  }

  static void logFrameMetrics(int frameTime) {
    // Log frame rendering time
    FirebasePerfService.logCustomMetric('frame_render_time', frameTime.toDouble());
    
    if (frameTime > 16) { // Below 60 FPS
      SentryService.addBreadcrumb(
        'Slow frame detected',
        {'frame_time_ms': frameTime, 'threshold': 16},
      );
    }
  }
}
```

**iOS Performance (lib/services/ios_perf.dart):**
```dart
import 'package:flutter/services.dart';

class IosPerformanceMonitor {
  static const MethodChannel _channel = MethodChannel('ios_perf');

  static Future<Map<String, dynamic>> getPerformanceMetrics() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getMetrics');
      return {
        'cpu_usage': result['cpuUsage'],
        'memory_usage': result['memoryUsage'],
        'battery_level': result['batteryLevel'],
        'graphics_rendering': result['graphicsRendering'],
        'app_launch_time': result['appLaunchTime'],
      };
    } catch (e) {
      SentryService.captureError(e);
      return {};
    }
  }
}
```

### Web Performance Monitoring
**web/performance_observer.js:**
```javascript
// Performance observer for Flutter web
if ('PerformanceObserver' in window) {
  const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      if (entry.entryType === 'navigation') {
        // Log navigation timing
        console.log('Navigation timing:', {
          loadTime: entry.loadEventEnd,
          domContentLoaded: entry.domContentLoadedEventEnd,
          firstPaint: entry.firstPaint,
        });
        
        // Send to monitoring service
        fetch('/api/performance/navigation', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            loadTime: entry.loadEventEnd,
            domContentLoaded: entry.domContentLoadedEventEnd,
            firstPaint: entry.firstPaint,
            url: window.location.href,
          }),
        });
      }
      
      if (entry.entryType === 'paint') {
        // Track paint events
        gtag('event', 'paint_timing', {
          event_category: 'performance',
          event_label: entry.name,
          value: Date.now() - entry.startTime,
        });
      }
    }
  });
  
  observer.observe({ entryTypes: ['navigation', 'paint', 'largest-contentful-paint'] });
}

// Long task detection
if ('PerformanceObserver' in window) {
  const longTaskObserver = new PerformanceObserver((list) => {
    for (const task of list.getEntries()) {
      if (task.duration > 50) { // Long task threshold
        console.warn('Long task detected:', task.duration, 'ms');
        
        // Report to monitoring service
        fetch('/api/performance/long-task', {
          method: 'POST',
          body: JSON.stringify({
            duration: task.duration,
            startTime: task.startTime,
          }),
        });
      }
    }
  });
  
  longTaskObserver.observe({ entryTypes: ['longtask'] });
}
```

## 🔔 Alerting Configuration

### Slack Integration
**.github/workflows/slack-alerts.yml:**
```yaml
name: Slack Alerts

on:
  push:
    branches: [ main ]
  pull_request:
    types: [closed]
  workflow_run:
    workflows: ["CI", "Performance Monitoring"]
    types: [completed]

jobs:
  slack:
    runs-on: ubuntu-latest
    if: github.event_name == 'push' || (github.event.pull_request.merged == true) || github.event.workflow_run.conclusion == 'failure'
    steps:
      - name: Send Slack Notification
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          fields: repo,message,commit,author,action,eventName,ref,workflow
          dispatch: true
          author_name: 'GitHub Actions'
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Custom Slack Message
        if: failure()
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data '{
              "text": "🚨 *CI/CD Failure Alert*",
              "attachments": [{
                "color": "danger",
                "fields": [
                  {"title": "Repository", "value": "${{ github.repository }}", "short": true},
                  {"title": "Workflow", "value": "${{ github.workflow }}", "short": true},
                  {"title": "Branch", "value": "${{ github.ref }}", "short": true},
                  {"title": "Commit", "value": "${{ github.sha }}", "short": false}
                ],
                "actions": [
                  {"type": "button", "text": "View Workflow", "url": "${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"}
                ]
              }]
            }' \
            ${{ secrets.SLACK_WEBHOOK_URL }}
```

### PagerDuty Integration
**pagerduty-configuration.json:**
```json
{
  "name": "REChain VC Production",
  "description": "Production environment for REChain VC Flutter app",
  "severity": "critical",
  "type": "service",
  "escalation_policy": {
    "name": "Engineering On-Call",
    "schedule": "Engineering Rotation"
  },
  "integrations": [
    {
      "name": "GitHub",
      "type": "github",
      "config": {
        "repo": "REChainVC/rechain-vc",
        "events": ["deployment", "failure", "security"]
      }
    },
    {
      "name": "Prometheus",
      "type": "prometheus",
      "config": {
        "url": "http://prometheus:9090",
        "alert_rules": "alert.rules.yml"
      }
    },
    {
      "name": "Sentry",
      "type": "sentry",
      "config": {
        "organization": "rechain-vc",
        "project": "flutter-app",
        "thresholds": {
          "error_rate": 0.05,
          "performance": 0.9
        }
      }
    }
  ],
  "response_play": {
    "name": "Standard Incident Response",
    "steps": [
      "Acknowledge alert",
      "Review monitoring dashboards",
      "Check recent deployments",
      "Rollback if necessary",
      "Notify stakeholders",
      "Post-mortem analysis"
    ]
  }
}
```

### Alertmanager Configuration
**alertmanager.yml:**
```yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@rechain.vc'
  smtp_auth_username: 'alerts@rechain.vc'
  smtp_auth_password: '${SMTP_PASSWORD}'

route:
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'team-X-mails'
  routes:
    # Critical alerts
    - match:
        severity: critical
      receiver: 'critical-alerts'
      continue: true
    
    # Warning alerts
    - match:
        severity: warning
      receiver: 'team-X-mails'
      continue: true

receivers:
  - name: 'team-X-mails'
    email_configs:
      - to: 'team-x@rechain.vc'
        html: '{{ template "email.default.html" . }}'
        headers:
          subject: '[Alert] {{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }} {{ .GroupLabels.SortedPairs.Values | join " " }}'

  - name: 'critical-alerts'
    slack_configs:
      - api_url: '${SLACK_WEBHOOK_URL}'
        channel: '#critical-incidents'
        text: '🚨 {{ .CommonAnnotations.summary }}'
        title: '{{ .CommonAnnotations.summary }}'
        color: 'danger'
        fields:
          - title: 'Severity'
            value: '{{ .CommonLabels.severity }}'
            short: true
          - title: 'Instance'
            value: '{{ .CommonLabels.instance }}'
            short: true
          - title: 'Description'
            value: '{{ .CommonAnnotations.description }}'
            short: false

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']
```

## 📈 Business Intelligence and Analytics

### Google Analytics Configuration
**web/analytics.js:**
```javascript
// Google Analytics 4 Configuration
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID','gtag');

gtag('js', new Date());
gtag('config', 'GA_MEASUREMENT_ID', {
  'send_page_view': false,
  'anonymize_ip': true,
  'custom_map': {
    'dimension1': 'user_type',
    'dimension2': 'platform',
    'metric1': 'transaction_count',
    'metric2': 'wallet_balance'
  }
});

// Track Flutter app events
window.trackFlutterEvent = function(eventName, parameters) {
  gtag('event', eventName, {
    ...parameters,
    'event_category': 'flutter_app',
    'event_label': eventName,
    'user_type': window.env?.userType || 'anonymous',
    'platform': navigator.userAgent.includes('Mobile') ? 'mobile' : 'desktop'
  });
};

// Track blockchain transactions
window.trackTransaction = function(transactionHash, value, gasUsed) {
  gtag('event', 'blockchain_transaction', {
    'transaction_hash': transactionHash,
    'value_eth': value,
    'gas_used': gasUsed,
    'event_category': 'blockchain',
    'value': value * 2000, // Approximate USD value
    'currency': 'USD'
  });
};
```

### Custom Analytics Service
**lib/services/analytics_service.dart:**
```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:amplitude_flutter/amplitude_flutter.dart';

class AnalyticsService {
  static FirebaseAnalytics? _firebaseAnalytics;
  static Amplitude? _amplitude;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Firebase Analytics
    _firebaseAnalytics = FirebaseAnalytics.instance;
    await _firebaseAnalytics!.setAnalyticsCollectionEnabled(true);
    await _firebaseAnalytics!.setUserProperty(name: 'platform', value: Platform.operatingSystem);

    // Initialize Amplitude
    _amplitude = Amplitude('YOUR_AMPLITUDE_API_KEY');
    await _amplitude!.init();
    
    _initialized = true;
  }

  static Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    await _firebaseAnalytics?.logEvent(
      name: name,
      parameters: parameters,
    );

    await _amplitude?.logEvent(
      name: name,
      properties: parameters,
    );

    // Custom server-side logging
    await _logToBackend(name, parameters);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await _firebaseAnalytics?.setUserProperty(name: name, value: value);
    await _amplitude?.setUserProperties({'key': name, 'value': value});
  }

  static Future<void> logScreenView(String screenName, [Map<String, dynamic>? parameters]) async {
    await _firebaseAnalytics?.logScreenView(
      screenName: screenName,
      parameters: parameters,
    );
  }

  static Future<void> logBlockchainTransaction({
    required String transactionHash,
    required double value,
    required int gasUsed,
    required String status,
    String? walletAddress,
  }) async {
    final params = {
      'transaction_hash': transactionHash,
      'value_eth': value,
      'gas_used': gasUsed,
      'status': status,
      'wallet_address': walletAddress,
      'value_usd': value * 2000, // Approximate conversion
    };

    await logEvent('blockchain_transaction', params);
  }

  static Future<void> logPerformanceMetric(String metric, double value, [String? platform]) async {
    await _firebaseAnalytics?.logEvent(
      name: 'performance_metric',
      parameters: {
        'metric': metric,
        'value': value,
        'platform': platform ?? Platform.operatingSystem,
      },
    );
  }

  static Future<void> _logToBackend(String event, Map<String, dynamic>? params) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/api/analytics/event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event': event,
          'parameters': params,
          'timestamp': DateTime.now().toIso8601String(),
          'user_id': await _getUserId(),
          'session_id': await _getSessionId(),
        }),
      );

      if (response.statusCode != 200) {
        SentryService.captureMessage('Analytics backend error: ${response.statusCode}');
      }
    } catch (e) {
      SentryService.captureError(e, hint: 'Analytics backend call failed');
    }
  }

  static Future<String> _getUserId() async {
    // Implement user identification logic
    return 'anonymous_user_${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<String> _getSessionId() async {
    // Implement session tracking
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }
}

// Usage in app
void _trackButtonTap() {
  AnalyticsService.logEvent('button_tap', {
    'button_id': 'sign_in',
    'screen': 'login_screen',
    'user_type': 'guest',
  });
}

void _trackScreenView() {
  AnalyticsService.logScreenView('dashboard', {
    'user_type': 'authenticated',
    'wallet_connected': true,
  });
}
```

## 🛡️ Security Monitoring

### Audit Logging Configuration
**backend/middleware/audit_logger.js:**
```javascript
const winston = require('winston');
const Sentry = require('@sentry/node');

const auditLogger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json(),
    winston.format.printf(({ timestamp, level, message, ...meta }) => {
      return `${timestamp} [${level}]: ${message} ${JSON.stringify(meta)}`;
    })
  ),
  transports: [
    new winston.transports.File({ filename: 'logs/audit.log' }),
    new winston.transports.Console({ format: winston.format.simple() }),
  ],
});

function auditLog(action, userId, metadata = {}) {
  const logEntry = {
    action,
    userId,
    timestamp: new Date().toISOString(),
    ipAddress: metadata.ip || 'unknown',
    userAgent: metadata.userAgent || 'unknown',
    sessionId: metadata.sessionId || 'unknown',
    ...metadata,
  };

  // Log to file and console
  auditLogger.info(`Audit: ${action}`, logEntry);

  // Send to central audit system
  fetch('https://audit.rechain.vc/log', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(logEntry),
  }).catch(err => {
    Sentry.captureException(err);
  });

  // Security-sensitive actions
  if (['wallet_connect', 'transaction_sign', 'withdraw', 'admin_access'].includes(action)) {
    // Send to security monitoring
    Sentry.captureMessage(`Security event: ${action}`, {
      level: 'warning',
      extra: logEntry,
    });
  }
}

module.exports = { auditLog };
```

### Security Alert Configuration
**.github/workflows/security-alerts.yml:**
```yaml
name: Security Alerts

on:
  schedule:
    - cron: '0 8 * * *'  # Daily at 8 AM
  workflow_dispatch:

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Dependabot Security Updates
        uses: dependabot/fetch-metadata@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}

      - name: Check for Security Vulnerabilities
        uses: github/codeql-action/analyze@v2
        with:
          category: /language:javascript
          queries: security-extended

      - name: Security Alert Notification
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: failure
          text: "🔒 Security vulnerability detected! Review the latest scan results."
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

      - name: Create Security Issue
        if: failure()
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.PRIVATE_KEY }}

      - name: Security Issue Template
        if: failure()
        run: |
          gh issue create \
            --title "Security Vulnerability Detected" \
            --body "Automated security scan detected vulnerabilities. Please review the latest CodeQL and Dependabot results." \
            --label "security,critical" \
            --assignee "@rechain-security-team"
        env:
          GITHUB_TOKEN: ${{ steps.create_token.outputs.token }}
```

## 📈 Cost Monitoring

### Cloud Cost Alerts
**cloud-cost-monitor.js:**
```javascript
const AWS = require('aws-sdk');
const Sentry = require('@sentry/node');

class CostMonitor {
  constructor() {
    this.billing = new AWS.CostExplorer({
      region: 'us-east-1',
    });
  }

  async checkDailyCosts() {
    try {
      const params = {
        TimePeriod: {
          Start: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString().split('T')[0],
          End: new Date().toISOString().split('T')[0],
        },
        Granularity: 'DAILY',
        Metrics: ['BlendedCost'],
        GroupBy: [
          {
            Type: 'DIMENSION',
            Key: 'SERVICE',
          },
        ],
      };

      const result = await this.billing.getCostAndUsage(params).promise();

      // Check for unexpected cost spikes
      const totalCost = result.ResultsByTime[0].Total?.BlendedCost?.Amount || 0;
      const services = result.ResultsByTime[0].Groups || [];

      // Alert if daily cost exceeds threshold
      if (parseFloat(totalCost) > 100) { // $100 daily threshold
        await this.sendCostAlert(totalCost, services);
      }

      // Check for unusual service cost increases
      services.forEach(service => {
        if (parseFloat(service.Metrics.BlendedCost.Amount) > 50) {
          Sentry.captureMessage(`High service cost: ${service.Keys[0]} - $${service.Metrics.BlendedCost.Amount}`);
        }
      });

      return { totalCost, services };
    } catch (error) {
      Sentry.captureException(error);
      throw error;
    }
  }

  async sendCostAlert(totalCost, services) {
    // Send to Slack
    const slackMessage = {
      text: '💰 Cloud Cost Alert',
      attachments: [{
        color: 'warning',
        fields: [
          {
            title: 'Total Daily Cost',
            value: `$${totalCost}`,
            short: true,
          },
          {
            title: 'Top Cost Services',
            value: services
              .sort((a, b) => parseFloat(b.Metrics.BlendedCost.Amount) - parseFloat(a.Metrics.BlendedCost.Amount))
              .slice(0, 3)
              .map(s => `${s.Keys[0]}: $${s.Metrics.BlendedCost.Amount}`)
              .join('\n'),
            short: false,
          },
        ],
        actions: [
          {
            type: 'button',
            text: 'View Cost Explorer',
            url: 'https://console.aws.amazon.com/cost-management/home',
          },
        ],
      }],
    };

    await fetch(process.env.SLACK_WEBHOOK_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(slackMessage),
    });
  }
}

module.exports = CostMonitor;
```

## 🛠️ GitHub Actions Monitoring Integration

### Workflow Performance Monitoring
**.github/workflows/monitoring.yml:**
```yaml
name: Monitoring and Alerts

on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
  workflow_run:
    workflows: ["CI", "Performance Monitoring", "Docker Build"]
    types: [completed]
  push:
    branches: [ main ]
    paths: ['.github/workflows/**']

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check Application Health
        run: |
          # Health check API endpoints
          curl -f https://api.rechain.vc/health || exit 1
          curl -f https://rechain.vc/ || exit 1
          
          # Check database connectivity
          docker run --rm --network host postgres:15 psql -h localhost -U user -d rechain -c "SELECT 1"

      - name: Check Blockchain Sync
        run: |
          # Check Geth sync status
          curl -s -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' \
            http://localhost:8545 | jq '.result.syncing'
          
          # Verify latest block
          curl -s -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
            http://localhost:8545 | jq '.result'

  metrics-collection:
    runs-on: ubuntu-latest
    steps:
      - name: Collect GitHub Metrics
        run: |
          # Repository metrics
          gh api repos/${{ github.repository }} | jq '.stargazers_count, .forks_count, .open_issues_count'
          
          # Workflow run statistics
          gh run list --repo=${{ github.repository }} --limit=100 --json databaseId,status,conclusion,createdAt,updatedAt | jq '.[] | {run_id: .databaseId, status: .status, conclusion: .conclusion, duration: (.updatedAt - .createdAt | fromiso8601 | floor / 60)}'
          
          # PR metrics
          gh pr list --repo=${{ github.repository }} --state=open --json number,title,author,createdAt,updatedAt,labels | jq '.[] | {number: .number, title: .title, author: .author.login, age_days: ((now - .createdAt | fromiso8601) / 86400 | floor), labels: [.labels[].name]}'
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Collect Application Metrics
        run: |
          # API performance metrics
          curl -s https://api.rechain.vc/metrics | grep -E '(http_requests_total|http_request_duration_seconds)'
          
          # Database metrics
          docker exec postgres psql -U user -d rechain -c "SELECT pg_stat_database.datname, pg_stat_database.numbackends, pg_stat_database.xact_commit, pg_stat_database.xact_rollback FROM pg_stat_database;"
          
          # System metrics
          docker stats --no-stream --format "{{.Container}}: CPU {{.CPUPerc}}, Mem {{.MemUsage}}"

      - name: Send Metrics to InfluxDB
        run: |
          # Convert metrics to line protocol
          node scripts/metrics_to_influx.js application_metrics.json
          
          # Send to InfluxDB
          curl -XPOST "http://influxdb:8086/write?db=monitoring" \
            --data-binary @metrics.lp

  alerting:
    runs-on: ubuntu-latest
    needs: [health-check, metrics-collection]
    if: failure()
    steps:
      - name: Send Critical Alert
        uses: 8398a7/action-slack@v3
        with:
          status: failure
          fields: repo,message,commit,author,action,eventName,ref,workflow
          text: "🚨 *Critical Monitoring Alert*\nHealth check failed for ${{ github.repository }}"
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

      - name: Create Incident Issue
        run: |
          gh issue create \
            --title "Monitoring Alert: Health Check Failed" \
            --body "Automated health check failed at $(date). Review the workflow logs for details." \
            --label "monitoring,critical" \
            --milestone "Production" \
            --assignee "@rechain-devops"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 📚 Related Documentation

- **[ENVIRONMENT.md](ENVIRONMENT.md)** - Monitoring environment variables and secrets
- **[SECURITY.md](SECURITY.md)** - Security monitoring and alerting policies
- **[WORKFLOW.md](WORKFLOW.md)** - CI/CD integration with monitoring systems
- **[DOCKER.md](DOCKER.md)** - Container monitoring with Prometheus and Grafana
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development setup with local monitoring

## 🚀 Getting Started

### 1. Configure Monitoring Services
```bash
# Start monitoring stack
docker-compose -f docker-compose.monitoring.yml up -d

# Configure Grafana admin
# URL: http://localhost:3000
# User: admin
# Password: admin

# Access Prometheus
# URL: http://localhost:9090
```

### 2. Integrate with Application
```bash
# Add monitoring dependencies
flutter pub add sentry_flutter firebase_performance amplitude_flutter

# Configure in main.dart
await SentryService.initialize();
await FirebasePerfService.initialize();
await AnalyticsService.initialize();
```

### 3. Set Up GitHub Secrets
Repository Settings → Secrets and variables → Actions:
- `SENTRY_AUTH_TOKEN` - Sentry authentication token
- `SLACK_WEBHOOK_URL` - Slack webhook for alerts
- `PAGERDUTY_TOKEN` - PagerDuty integration token
- `GA_MEASUREMENT_ID` - Google Analytics ID
- `AMPLITUDE_API_KEY` - Amplitude API key

### 4. Configure Alerting
1. Set up Slack channels for different alert levels
2. Configure PagerDuty escalation policies
3. Set up email notifications for critical alerts
4. Configure mobile push notifications for on-call engineers

---

*Last updated: September 2024*

For monitoring configuration issues, see [CONTRIBUTING.md](CONTRIBUTING.md#development-setup) or create an issue using the [documentation template](.github/ISSUE_TEMPLATE/documentation.md).