import 'package:flutter/material.dart';
import '../models/homestay.dart';

class HomestayDetailScreen extends StatelessWidget {
  final Homestay homestay;

  const HomestayDetailScreen({
    super.key,
    required this.homestay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homestay.name.toString()),
        backgroundColor: const Color.fromARGB(255, 239, 187, 238),
        foregroundColor: const Color.fromARGB(255, 138, 22, 111),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.home_work,
                    size: 90,
                    color: Color.fromARGB(255, 138, 22, 111),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  homestay.name.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 138, 22, 111),
                  ),
                ),
                const SizedBox(height: 12),
                Text('State: ${homestay.state}'),
                Text('District: ${homestay.district}'),
                Text('Price: RM ${homestay.price}'),
                const SizedBox(height: 18),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(homestay.description.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}