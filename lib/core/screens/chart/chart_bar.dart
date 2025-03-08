import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';

class _ChartBar extends StatelessWidget {
  final Color textColor;
  final List<Color> gradientColors;
  final Map<Category, double> categoriesStatistics;

  const _ChartBar({
    required this.textColor,
    required this.gradientColors,
    required this.categoriesStatistics,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue =
        categoriesStatistics.values.reduce((a, b) => a > b ? a : b).toDouble();

    double adjustedMaxY = maxValue * 1.2;

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: adjustedMaxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 1,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          TextStyle(color: textColor, fontWeight: FontWeight.bold),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta, Category category) {
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Container(margin: EdgeInsets.all(5), child: Icon(category.icon)),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          return getTitles(
            value,
            meta,
            categoriesStatistics.keys.toList()[value.toInt()],
          );
        },
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => LinearGradient(
    colors: gradientColors,
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups =>
      categoriesStatistics.entries
          .map(
            (category) => BarChartGroupData(
              x: categoriesStatistics.keys.toList().indexOf(category.key),
              barRods: [
                BarChartRodData(
                  toY: category.value.toDouble(),
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          )
          .toList();
}

class BarChartSample3 extends StatefulWidget {
  final Color textColor;
  final List<Color> gradientColors;
  final Map<Category, double> categoriesStatistics;

  const BarChartSample3({
    super.key,
    required this.textColor,
    required this.gradientColors,
    required this.categoriesStatistics,
  });

  @override
  State<StatefulWidget> createState() => BarChartSample();
}

class BarChartSample extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: MediaQuery.of(context).size.width <= 600? 2.1 : 1.2,
      child: _ChartBar(
        textColor: widget.textColor,
        gradientColors: widget.gradientColors,
        categoriesStatistics: widget.categoriesStatistics,
      ),
    );
  }
}
