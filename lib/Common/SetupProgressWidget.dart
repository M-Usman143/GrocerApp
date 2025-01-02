import 'package:flutter/material.dart';

class StepProgressWidget extends StatelessWidget {
  final int currentStep;

  const StepProgressWidget({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light gray background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Row of Circles and Lines
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStepCircle(isActive: currentStep >= 1, isComplete: currentStep > 1),
              _buildProgressLine(isActive: currentStep > 1),
              _buildStepCircle(isActive: currentStep >= 2, isComplete: currentStep > 2),
              _buildProgressLine(isActive: currentStep > 2),
              _buildStepCircle(isActive: currentStep >= 3, isComplete: false),
            ],
          ),
          const SizedBox(height: 8),
          // Row of Step Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("1.Your Bill", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text("2.Place Order", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text("3.Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget for a Step Circle
  Widget _buildStepCircle({required bool isActive, required bool isComplete}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isComplete ? Colors.green : (isActive ? Colors.white : Colors.grey[300]),
        border: Border.all(
          color: isActive ? Colors.green : (Colors.grey[400] ?? Colors.grey),
          width: 2,
        ),
      ),
      child: isComplete
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }

  /// Widget for Progress Line
  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 4,
        color: isActive ? Colors.green : Colors.grey[300],
      ),
    );
  }
}
