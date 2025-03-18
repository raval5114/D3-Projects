import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifetime/Data/Models/chartData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DaysCompletedSection extends StatefulWidget {
  const DaysCompletedSection({super.key});

  @override
  State<DaysCompletedSection> createState() => _DaysCompletedSectionState();
}

class _DaysCompletedSectionState extends State<DaysCompletedSection>
    with SingleTickerProviderStateMixin {
  double completedDays = 0.0;
  double remainingDays = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays = prefs.getDouble('completedDays') ?? 0.0;
      remainingDays = prefs.getDouble('remainingDays') ?? 0.0;
    });

    _animationController.forward();
  }

  List<ChartData> getChartData() {
    return [
      ChartData('Completed', completedDays, Colors.deepPurple),
      ChartData('Remaining', remainingDays, Colors.deepPurple.shade300),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320, // Increased width
        height: 320, // Increased height
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: SfCircularChart(
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: getChartData(),
                        xValueMapper: (ChartData data, _) => data.label,
                        yValueMapper: (ChartData data, _) => data.value,
                        pointColorMapper: (ChartData data, _) => data.color,
                        innerRadius: '68%',
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        animationDuration: 1500,
                      ),
                    ],
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DAYS COMPLETED',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${completedDays.toInt()} days',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
