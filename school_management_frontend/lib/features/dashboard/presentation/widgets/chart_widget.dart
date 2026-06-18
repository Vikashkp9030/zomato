import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List<dynamic> data;

  const ChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    double maxValue = 0;
    for (var item in data) {
      if (item['count'] != null && (item['count'] as num) > maxValue) {
        maxValue = (item['count'] as num).toDouble();
      }
    }

    if (maxValue == 0) maxValue = 100;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data.take(7).map((item) {
          final count = (item['count'] as num?)?.toDouble() ?? 0;
          final height = (count / maxValue) * 150;
          final label = item['date']?.toString().split('-').last ?? 'N/A';

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: '$count',
                child: Container(
                  width: 30,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
