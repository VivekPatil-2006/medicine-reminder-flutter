import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/medicine.dart';
import '../provider/medicine_provider.dart';
import '../core/notification_service.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() =>
      _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveMedicine() {
    if (_nameController.text.isEmpty ||
        _doseController.text.isEmpty ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final medicine = Medicine(
      name: _nameController.text,
      dose: _doseController.text,
      time: scheduledTime,
    );

    ref.read(medicineProvider.notifier).addMedicine(medicine);

    NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      medicineName: medicine.name,
      time: scheduledTime,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InputField(
              controller: _nameController,
              label: 'Medicine Name',
              icon: Icons.medication,
            ),

            const SizedBox(height: 12),

            _InputField(
              controller: _doseController,
              label: 'Dose (e.g. 1 tablet)',
              icon: Icons.description,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.access_time),
              label: Text(
                _selectedTime == null
                    ? 'Pick Time'
                    : _selectedTime!.format(context),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMedicine,
                child: const Text(
                  'Save Medicine',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- INPUT FIELD ----------------
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
