import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'finance_controller.dart';

class FinanceScreen extends GetView<FinanceController> {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Tài chính'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Thống kê tài chính và lịch sử'),
      ),
    );
  }
}
