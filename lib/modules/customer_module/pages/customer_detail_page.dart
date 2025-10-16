import 'package:flutter/material.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  const CustomerDetailPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(customer.name[0], style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 16),
            Text('Name: ${customer.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${customer.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Phone: ${customer.phone ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}
