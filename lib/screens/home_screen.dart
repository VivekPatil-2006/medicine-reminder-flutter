import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/medicine_provider.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: medicines.isEmpty
          ? _EmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];
          return _MedicineCard(
            name: med.name,
            dose: med.dose,
            time: DateFormat.jm().format(med.time),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMedicineScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// ---------------- EMPTY STATE ----------------
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.teal,
          ),
          SizedBox(height: 16),
          Text(
            'No medicines added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first reminder',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// ---------------- MEDICINE CARD ----------------
class _MedicineCard extends StatelessWidget {
  final String name;
  final String dose;
  final String time;

  const _MedicineCard({
    required this.name,
    required this.dose,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(
              Icons.medication,
              color: Colors.teal,
              size: 32,
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dose,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
