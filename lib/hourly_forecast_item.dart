import "package:flutter/material.dart";

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastItem({
      super.key,
      required this.time,
      required this.icon,
      required this.temperature,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 6,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      padding: const EdgeInsets.all(8.0), 
                      child: Column(
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          time,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          
                          ),
                          const SizedBox(height: 16,),
                          Icon(icon, size: 24,),
                          const SizedBox(height: 16,),
                                          
                          Text(
                          temperature,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          
                          ),
                        ],
                      ),
                    ),
                  );
  }
}