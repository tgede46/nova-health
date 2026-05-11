import 'package:flutter/material.dart';
import '../models/chat_response.dart';
import 'pharmacy_card.dart';

class PharmacyList extends StatelessWidget {
  final List<Pharmacy> pharmacies;
  final String message;

  const PharmacyList({
    super.key,
    required this.pharmacies,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              return PharmacyCard(pharmacy: pharmacies[index]);
            },
          ),
        ),
      ],
    );
  }
}
