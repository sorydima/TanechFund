import 'package:flutter/material.dart';

class CosmosScreen extends StatelessWidget {
  const CosmosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmos'),
      ),
      body: const Center(
        child: Text('Cosmos Screen'),
      ),
    );
  }
}
