import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminAnalyticsTab extends StatefulWidget {
  const AdminAnalyticsTab({super.key});

  @override
  State<AdminAnalyticsTab> createState() => _AdminAnalyticsTabState();
}

class _AdminAnalyticsTabState extends State<AdminAnalyticsTab> {
  final _monthly = AdminMockData.monthlyData;
  final _districts = AdminMockData.districtData;
  final _topProducts = AdminMockData.topProducts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform Analytics', style: AdminTheme.heading1),
                  const SizedBox(height: 4),
                  Text('Aug 2025 — Jul 2026 · All time data', style: AdminTheme.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Row 1: Revenue Line Chart + Seller Growth
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildCard(
                  'Revenue Trend (12 Months)',
                  Icons.show_chart,
                  child: SizedBox(height: 260, child: _RevenueTrendChart(monthlyData: _monthly)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildCard(
                  'Seller Growth',
                  Icons.group_add_outlined,
                  child: SizedBox(height: 260, child: _SellerGrowthChart(monthlyData: _monthly)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 2: District Table + Top Products Chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildCard(
                  'District-wise Performance',
                  Icons.map_outlined,
                  child: _DistrictTable(districts: _districts),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildCard(
                  'Top Products by Revenue',
                  Icons.leaderboard_outlined,
                  child: SizedBox(height: 340, child: _TopProductsChart(products: _topProducts)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 3: Revenue Split Donut + Ad Spend Line
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildCard(
                  'Revenue Split',
                  Icons.donut_large_outlined,
                  child: SizedBox(height: 240, child: _RevenueSplitDonut()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildCard(
                  'Ad Spend vs. Seller Growth Over Time',
                  Icons.multiline_chart,
                  child: SizedBox(height: 240, child: _MultiLineChart(monthlyData: _monthly)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminTheme.borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AdminTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminTheme.accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(title, style: AdminTheme.heading2),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ─── Revenue Trend Line Chart ─────────────────────────────────────────────────
class _RevenueTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  const _RevenueTrendChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final spots = monthlyData.asMap().entries.map((e) =>
      FlSpot(e.key.toDouble(), (e.value['revenue'] as num).toDouble())
    ).toList();

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AdminTheme.textPrimary,
            getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
              '₹${(s.y / 1000).toStringAsFixed(0)}K',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            )).toList(),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AdminTheme.borderColor, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, reservedSize: 44,
              getTitlesWidget: (v, _) => Text('₹${(v / 1000).toStringAsFixed(0)}K', style: AdminTheme.caption.copyWith(fontSize: 9)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                return i < monthlyData.length ? Text(monthlyData[i]['month'], style: AdminTheme.caption.copyWith(fontSize: 9)) : const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AdminTheme.accentBlue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [AdminTheme.accentBlue.withValues(alpha: 0.2), AdminTheme.accentBlue.withValues(alpha: 0)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Seller Growth Bar Chart ──────────────────────────────────────────────────
class _SellerGrowthChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  const _SellerGrowthChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AdminTheme.textPrimary,
            getTooltipItem: (g, _, rod, __) => BarTooltipItem(
              '${rod.toY.toInt()} sellers',
              const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AdminTheme.borderColor, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                return i < monthlyData.length ? Text(monthlyData[i]['month'], style: AdminTheme.caption.copyWith(fontSize: 9)) : const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32,
            getTitlesWidget: (v, _) => Text('${v.toInt()}', style: AdminTheme.caption.copyWith(fontSize: 9)),
          )),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: monthlyData.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [BarChartRodData(
            toY: (e.value['sellers'] as num).toDouble(),
            gradient: LinearGradient(colors: [AdminTheme.accentPurple, AdminTheme.accentBlue], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            width: 12,
            borderRadius: BorderRadius.circular(4),
          )],
        )).toList(),
      ),
    );
  }
}

// ─── District Table ───────────────────────────────────────────────────────────
class _DistrictTable extends StatelessWidget {
  final List<Map<String, dynamic>> districts;
  const _DistrictTable({required this.districts});

  @override
  Widget build(BuildContext context) {
    final maxRevenue = districts.fold(0, (m, d) => d['revenue'] > m ? d['revenue'] as int : m);
    return Table(
      columnWidths: const {0: FlexColumnWidth(1.5), 1: FixedColumnWidth(50), 2: FlexColumnWidth(2)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: AdminTheme.bgGrey),
          children: ['District', 'Sellers', 'Revenue'].map((c) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(c, style: AdminTheme.caption.copyWith(fontWeight: FontWeight.w700, fontSize: 10)),
          )).toList(),
        ),
        ...districts.map((d) => TableRow(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text(d['district'], style: AdminTheme.bodyText.copyWith(fontSize: 12))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('${d['sellers']}', style: AdminTheme.labelBold.copyWith(fontSize: 12))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (_) {
                    final rev = d['revenue'] as int;
                    return Text('\u20b9${(rev / 1000).toStringAsFixed(0)}K', style: AdminTheme.labelBold.copyWith(color: AdminTheme.accentGold, fontSize: 12));
                  }),
                  const SizedBox(height: 3),
                  LinearProgressIndicator(
                    value: d['revenue'] / maxRevenue,
                    backgroundColor: AdminTheme.bgGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(AdminTheme.accentGold),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }
}

// ─── Top Products Horizontal Bar Chart ───────────────────────────────────────
class _TopProductsChart extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const _TopProductsChart({required this.products});

  @override
  Widget build(BuildContext context) {
    final maxRevenue = products.fold(0, (m, p) => (p['revenue'] as int) > m ? p['revenue'] as int : m);
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AdminTheme.textPrimary,
            getTooltipItem: (g, gi, rod, _) => BarTooltipItem(
              '₹${(rod.toY / 1000).toStringAsFixed(1)}K\n${products[gi]['orders']} orders',
              const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true, drawVerticalLine: true, drawHorizontalLine: false,
          getDrawingVerticalLine: (_) => FlLine(color: AdminTheme.borderColor, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, reservedSize: 160,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                return i < products.length ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(products[i]['name'], style: AdminTheme.caption.copyWith(fontSize: 11), textAlign: TextAlign.right),
                ) : const SizedBox();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28,
              getTitlesWidget: (v, _) => Text('₹${(v / 1000).toStringAsFixed(0)}K', style: AdminTheme.caption.copyWith(fontSize: 9)),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        maxY: maxRevenue.toDouble() * 1.1,
        barGroups: products.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [BarChartRodData(
            toY: (e.value['revenue'] as int).toDouble(),
            color: e.key == 0 ? AdminTheme.accentGold : (e.key < 3 ? AdminTheme.accentBlue : AdminTheme.accentBlue.withValues(alpha: 0.6)),
            width: 22,
            borderRadius: BorderRadius.circular(4),
          )],
        )).toList(),
      ),
    );
  }
}

// ─── Revenue Split Donut ──────────────────────────────────────────────────────
class _RevenueSplitDonut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: 80, color: AdminTheme.accentGreen, title: '80%\nSellers', radius: 70, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                PieChartSectionData(value: 20, color: AdminTheme.accentBlue, title: '20%\nPlatform', radius: 65, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legend(AdminTheme.accentGreen, 'Seller Payout (80%)'),
            const SizedBox(width: 16),
            _legend(AdminTheme.accentBlue, 'Platform Fee (20%)'),
          ],
        ),
      ],
    );
  }

  Widget _legend(Color c, String label) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(label, style: AdminTheme.caption.copyWith(fontSize: 11)),
  ]);
}

// ─── Multi Line Chart ─────────────────────────────────────────────────────────
class _MultiLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  const _MultiLineChart({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final spendSpots = monthlyData.asMap().entries.map((e) =>
      FlSpot(e.key.toDouble(), (e.value['ad_spend'] as num).toDouble())
    ).toList();

    final sellerSpots = monthlyData.asMap().entries.map((e) =>
      FlSpot(e.key.toDouble(), (e.value['sellers'] as num).toDouble() * 400)
    ).toList();

    return Column(
      children: [
        Row(
          children: [
            _legend(AdminTheme.accentOrange, 'Ad Spend'),
            const SizedBox(width: 16),
            _legend(AdminTheme.accentPurple, 'Sellers × 400 (scaled)'),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: AdminTheme.borderColor, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40,
                  getTitlesWidget: (v, _) => Text('₹${(v / 1000).toStringAsFixed(0)}K', style: AdminTheme.caption.copyWith(fontSize: 8)),
                )),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    return i < monthlyData.length ? Text(monthlyData[i]['month'], style: AdminTheme.caption.copyWith(fontSize: 9)) : const SizedBox();
                  },
                )),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spendSpots, isCurved: true,
                  color: AdminTheme.accentOrange, barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: sellerSpots, isCurved: true,
                  color: AdminTheme.accentPurple, barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 3],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(Color c, String label) => Row(children: [
    Container(width: 14, height: 3, color: c),
    const SizedBox(width: 6),
    Text(label, style: AdminTheme.caption.copyWith(fontSize: 11)),
  ]);
}
