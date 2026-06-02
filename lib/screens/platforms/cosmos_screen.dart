import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class CosmosScreen extends StatelessWidget {
  const CosmosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmos'),
        backgroundColor: const Color(0xFF2E3148),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text('Cosmos Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Интернет блокчейнов', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
