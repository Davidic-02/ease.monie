// lib/presentation/widgets/fintech/finance_chart.dart
import 'package:esae_monie/models/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:esae_monie/constants/app_colors.dart';

class FinanceChart extends StatefulWidget {
  final List<DailyBalance> dailyBalances;

  const FinanceChart({super.key, required this.dailyBalances});

  @override
  State<FinanceChart> createState() => _FinanceChartState();
}

class _FinanceChartState extends State<FinanceChart> {
  late List<FlSpot> spots;

  @override
  void initState() {
    super.initState();
    spots = widget.dailyBalances
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.balance / 1000))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const dates = [
                          'Nov 10',
                          'Nov 15',
                          'Nov 20',
                          'Nov 25',
                          'Nov 30',
                        ];
                        if (value.toInt() < dates.length) {
                          return Text(
                            dates[value.toInt()],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.greyColor,
                                  fontSize: 10,
                                ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blueColor.withOpacity(0.8),
                        AppColors.blueColor.withOpacity(0.2),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: AppColors.blueColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blueColor.withOpacity(0.3),
                          AppColors.blueColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.blueColor,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedBarSpot) {
                        return LineTooltipItem(
                          '\$${(touchedBarSpot.y * 1000).toStringAsFixed(0)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
