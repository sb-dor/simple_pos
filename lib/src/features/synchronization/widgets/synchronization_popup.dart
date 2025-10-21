import 'package:flutter/material.dart';

class SynchronizationPopup extends StatefulWidget {
  const SynchronizationPopup({super.key});

  @override
  State<SynchronizationPopup> createState() => _SynchronizationPopupState();
}

class _SynchronizationPopupState extends State<SynchronizationPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.1),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
