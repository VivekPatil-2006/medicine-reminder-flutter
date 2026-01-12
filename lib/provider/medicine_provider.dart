import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/medicine.dart';

final medicineProvider =
StateNotifierProvider<MedicineNotifier, List<Medicine>>(
      (ref) => MedicineNotifier(),
);

class MedicineNotifier extends StateNotifier<List<Medicine>> {
  final Box<Medicine> _box = Hive.box<Medicine>('medicines');

  MedicineNotifier() : super([]) {
    loadMedicines();
  }

  void loadMedicines() {
    state = _box.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  void addMedicine(Medicine medicine) {
    _box.add(medicine);
    loadMedicines();
  }
}
