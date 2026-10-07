import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../calendar/calendar_controller.dart';
import 'package:isar/isar.dart';
import 'package:host_babminton/core/database_service.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/venue.dart';

class CreateSessionController extends GetxController {
  var selectedDate = DateTime(2026, 10, 7).obs;
  var startTime = const TimeOfDay(hour: 19, minute: 0).obs;
  var endTime = const TimeOfDay(hour: 21, minute: 0).obs;

  final venueNameController = TextEditingController();
  final addressController = TextEditingController();

  final numCourtsController = TextEditingController();
  final courtNumbersController = TextEditingController();
  final maxPlayersController = TextEditingController();
  final pricePerCourtController = TextEditingController();
  final extraFeeController = TextEditingController();

  var selectedVenueIndex = (-1).obs;

  final savedVenues = [];

  var venueError = ''.obs;
  var timeError = ''.obs;

  String get sessionCode {
    return 'S${DateFormat('ddMM').format(selectedDate.value)}';
  }

  int get totalHours {
    int startMinutes = startTime.value.hour * 60 + startTime.value.minute;
    int endMinutes = endTime.value.hour * 60 + endTime.value.minute;
    if (endMinutes <= startMinutes) return 0;
    return ((endMinutes - startMinutes) / 60).round();
  }

  int get totalCourtCost {
    int courts =
        int.tryParse(numCourtsController.text.replaceAll('.', '')) ?? 0;
    int price =
        int.tryParse(pricePerCourtController.text.replaceAll('.', '')) ?? 0;
    return courts * totalHours * price;
  }

  void selectVenue(int index) {
    selectedVenueIndex.value = index;
    if (index >= 0 && index < savedVenues.length) {
      venueNameController.text = savedVenues[index]['name']!;
      addressController.text = savedVenues[index]['address']!;
      venueError.value = '';
    }
  }

  Future<void> saveSession() async {
    bool isValid = true;
    venueError.value = '';
    timeError.value = '';

    if (venueNameController.text.trim().isEmpty) {
      venueError.value = 'Vui lòng nhập tên địa điểm';
      isValid = false;
    }

    int startMinutes = startTime.value.hour * 60 + startTime.value.minute;
    int endMinutes = endTime.value.hour * 60 + endTime.value.minute;
    if (endMinutes <= startMinutes) {
      timeError.value = 'Giờ kết thúc phải sau giờ bắt đầu';
      isValid = false;
    }

    if (!isValid) return;

    final db = Get.find<DatabaseService>().db;
    final isar = await db;

    String startTimeStr =
        '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}';
    String endTimeStr =
        '${endTime.value.hour.toString().padLeft(2, '0')}:${endTime.value.minute.toString().padLeft(2, '0')}';

    final newSession = Session(
      code: sessionCode,
      date: selectedDate.value,
      startTime: startTimeStr,
      endTime: endTimeStr,
      numberOfCourts:
          int.tryParse(numCourtsController.text.replaceAll('.', '')) ?? 0,
      courtNumbers: courtNumbersController.text,
      maxPlayers: int.tryParse(maxPlayersController.text) ?? 16,
      courtPricePerHour:
          int.tryParse(pricePerCourtController.text.replaceAll('.', '')) ?? 0,
      status: SessionStatus.draft,
    );

    await isar.writeTxn(() async {
      var venue = await isar.venues
          .filter()
          .nameEqualTo(venueNameController.text)
          .findFirst();
      if (venue == null) {
        venue = Venue(
          name: venueNameController.text,
          address: addressController.text,
        );
        await isar.venues.put(venue);
      }

      await isar.sessions.put(newSession);
      newSession.venue.value = venue;
      await newSession.venue.save();
    });

    if (Get.isRegistered<CalendarController>()) {
      await Get.find<CalendarController>().reloadData();
    }

    Get.back();
  }

  @override
  void onClose() {
    venueNameController.dispose();
    addressController.dispose();
    numCourtsController.dispose();
    courtNumbersController.dispose();
    maxPlayersController.dispose();
    pricePerCourtController.dispose();
    extraFeeController.dispose();
    super.onClose();
  }
}
