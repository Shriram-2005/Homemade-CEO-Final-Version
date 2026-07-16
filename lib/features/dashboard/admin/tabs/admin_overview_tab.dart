import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminOverviewTab extends StatefulWidget {
  const AdminOverviewTab({super.key});

  @override
  State<AdminOverviewTab> createState() => _AdminOverviewTabState();
}

class _AdminOverviewTabState extends State<AdminOverviewTab> {
  final _stats = AdminMockData.platformStats;
  final _monthly = AdminMockData.monthlyData;
  final _activity = AdminMockData.activityFeed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Operations Overview', style: AdminTheme.heading1),
                  const SizedBox(height: 4),
                  Text('Last updated: Today, 11:30 AM IST', style: AdminTheme.caption),
                ],
              ),
              const Spacer(),
              _buildHeaderAction(Icons.refresh, 'Refresh', AdminTheme.accentBlue),
              const SizedBox(width: 12),
              _buildHeaderAction(Icons.download_outlined, 'Export Report', AdminTheme.accentBlue),
            ],
          ),
          const SizedBox(height: 32),

          // KPI Cards Row 1
          Row(
            children: [
              _buildKpiCard('Total Sellers', '${_stats['total_sellers']}', '+${_stats['sellers_growth']} this month', Icons.people_outline, AdminTheme.accentBlue, true),
              const SizedBox(width: 16),
              _buildKpiCard('Active Campaigns', '${_stats['active_campaigns']}', 'Live right now', Icons.campaign_outlined, AdminTheme.accentGreen, true),
              const SizedBox(width: 16),
              _buildKpiCard('Total Revenue', '₹${_formatNum(_stats['total_revenue'])}', '+${_stats['revenue_growth']}% MoM', Icons.trending_up, AdminTheme.accentGold, true),
              const SizedBox(width: 16),
              _buildKpiCard('Platform Commission', '₹${_formatNum(_stats['platform_commission'])}', '20% of revenue', Icons.account_balance_outlined, AdminTheme.accentPurple, false),
            ],
          ),
          const SizedBox(height: 16),

          // KPI Cards Row 2
          Row(
            children: [
              _buildKpiCard('Pending Approvals', '${_stats['pending_approvals']}', 'Needs review', Icons.pending_actions_outlined, AdminTheme.accentOrange, false),
              const SizedBox(width: 16),
              _buildKpiCard('Open Tickets', '${_stats['open_tickets']}', 'Unresolved', Icons.support_agent_outlined, AdminTheme.accentRed, false),
              const SizedBox(width: 16),
              _buildKpiCard('Avg. ROAS', '${_stats['avg_roas']}x', 'Return on ad spend', Icons.bar_chart_outlined, AdminTheme.accentGreen, true),
              const SizedBox(width: 16),
              _buildKpiCard('Total Impressions', _formatNum(_stats['total_impressions']), 'All time', Icons.visibility_outlined, AdminTheme.accentBlue, false),
            ],
          ),
          const SizedBox(height: 32),

          // Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Revenue vs Ad Spend Bar Chart
              Expanded(
                flex: 3,
                child: _buildChartCard(
                  'Revenue vs. Ad Spend (12 Months)',
                  Icons.bar_chart,
                  child: SizedBox(
                    height: 260,
                    child: _RevenueSpendBarChart(monthlyData: _monthly),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Seller Pipeline
              Expanded(
                flex: 2,
                child: _buildChartCard(
                  'Seller Pipeline Status',
                  Icons.filter_list,
                  child: SizedBox(
                    height: 260,
                    child: _SellerPipelineChart(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Second Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Conversion Funnel
              Expanded(
                flex: 2,
                child: _buildChartCard(
                  'Conversion Funnel',
                  Icons.filter_list,
                  child: SizedBox(
                    height: 220,
                    child: _ConversionFunnelChart(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Activity Feed
              Expanded(
                flex: 3,
                child: _buildChartCard(
                  'Live Activity Feed',
                  Icons.bolt,
                  child: SizedBox(
                    height: 220,
                    child: _buildActivityFeed(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon, Color color, bool isPositive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminTheme.borderColor),
          boxShadow: AdminTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.remove,
                  color: isPositive ? AdminTheme.accentGreen : AdminTheme.textSecondary,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: AdminTheme.heading1.copyWith(fontSize: 26, color: AdminTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(title, style: AdminTheme.bodyText),
            const SizedBox(height: 2),
            Text(subtitle, style: AdminTheme.caption.copyWith(color: isPositive ? AdminTheme.accentGreen : AdminTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, IconData icon, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminTheme.borderColor),
        boxShadow: AdminTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminTheme.accentBlue, size: 18),
              const SizedBox(width: 10),
              Text(title, style: AdminTheme.heading2),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, Color color) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildActivityFeed() {
    final typeConfig = {
      'seller_registered': {'icon': Icons.person_add_outlined, 'color': AdminTheme.accentBlue},
      'product_approved': {'icon': Icons.check_circle_outline, 'color': AdminTheme.accentGreen},
      'campaign_stalled': {'icon': Icons.warning_amber_outlined, 'color': AdminTheme.accentOrange},
      'payout_processed': {'icon': Icons.payments_outlined, 'color': AdminTheme.accentGold},
      'kyc_rejected': {'icon': Icons.gpp_bad_outlined, 'color': AdminTheme.accentRed},
      'product_submitted': {'icon': Icons.inbox_outlined, 'color': AdminTheme.accentPurple},
    };

    return ListView.separated(
      itemCount: _activity.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => Divider(color: AdminTheme.borderColor, height: 1),
      itemBuilder: (context, index) {
        final item = _activity[index];
        final cfg = typeConfig[item['type']] ?? {'icon': Icons.info_outline, 'color': AdminTheme.textSecondary};
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(cfg['icon'] as IconData, color: cfg['color'] as Color, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item['message'], style: AdminTheme.bodyText.copyWith(fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Text(item['time'], style: AdminTheme.caption),
            ],
          ),
        );
      },
    );
  }

  String _formatNum(dynamic val) {
    final n = (val as num).toInt();
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }
}

// ─── Revenue vs Spend Bar Chart ───────────────────────────────────────────────
class _RevenueSpendBarChart extends StatefulWidget {
  final List<Map<String, dynamic>> monthlyData;
  const _RevenueSpendBarChart({required this.monthlyData});

  @override
  State<_RevenueSpendBarChart> createState() => _RevenueSpendBarChartState();
}

class _RevenueSpendBarChartState extends State<_RevenueSpendBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _legend(AdminTheme.accentBlue, 'Revenue'),
            const SizedBox(width: 16),
            _legend(AdminTheme.accentGold, 'Ad Spend'),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AdminTheme.textPrimary,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = widget.monthlyData[group.x];
                    final revenue = (data['revenue'] as num).toDouble();
                    final adSpend = (data['ad_spend'] as num).toDouble();
                    final val = rodIndex == 0 ? revenue : adSpend;
                    return BarTooltipItem(
                      '₹${(val / 1000).toStringAsFixed(0)}K',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  setState(() {
                    touchedIndex = (response?.spot?.touchedBarGroupIndex ?? -1);
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        widget.monthlyData[value.toInt()]['month'],
                        style: AdminTheme.caption.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₹${(value / 1000).toStringAsFixed(0)}K',
                        style: AdminTheme.caption.copyWith(fontSize: 9),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (_) => FlLine(color: AdminTheme.borderColor, strokeWidth: 1),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: widget.monthlyData.asMap().entries.map((entry) {
                final isTouched = entry.key == touchedIndex;
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: (entry.value['revenue'] as num).toDouble(),
                      color: isTouched ? AdminTheme.accentBlue : AdminTheme.accentBlue.withValues(alpha: 0.75),
                      width: 8, borderRadius: BorderRadius.circular(3),
                    ),
                    BarChartRodData(
                      toY: (entry.value['ad_spend'] as num).toDouble(),
                      color: isTouched ? AdminTheme.accentGold : AdminTheme.accentGold.withValues(alpha: 0.75),
                      width: 8, borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                  groupVertically: false,
                  barsSpace: 3,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: AdminTheme.caption),
    ],
  );
}

// ─── Seller Pipeline Donut Chart ──────────────────────────────────────────────
class _SellerPipelineChart extends StatefulWidget {
  @override
  State<_SellerPipelineChart> createState() => _SellerPipelineChartState();
}

class _SellerPipelineChartState extends State<_SellerPipelineChart> {
  int _touchedIndex = -1;

  final sections = [
    {'label': 'Live', 'count': 148, 'color': AdminTheme.accentGreen},
    {'label': 'LMS In-Progress', 'count': 54, 'color': AdminTheme.accentBlue},
    {'label': 'KYC Pending', 'count': 32, 'color': AdminTheme.accentOrange},
    {'label': 'Applied', 'count': 14, 'color': AdminTheme.accentRed},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                  });
                },
              ),
              sections: sections.asMap().entries.map((e) {
                final isTouched = e.key == _touchedIndex;
                final total = sections.fold(0, (sum, s) => sum + (s['count'] as int));
                final pct = ((e.value['count'] as int) / total * 100).toStringAsFixed(0);
                return PieChartSectionData(
                  color: e.value['color'] as Color,
                  value: (e.value['count'] as int).toDouble(),
                  radius: isTouched ? 80 : 70,
                  title: isTouched ? '${e.value['label']}\n$pct%' : '$pct%',
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: isTouched ? 12 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12, runSpacing: 6,
          children: sections.map((s) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: s['color'] as Color, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text('${s['label']} (${s['count']})', style: AdminTheme.caption.copyWith(fontSize: 11)),
            ],
          )).toList(),
        ),
      ],
    );
  }
}

// ─── Conversion Funnel Chart ──────────────────────────────────────────────────
class _ConversionFunnelChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final funnel = AdminMockData.conversionFunnel;
    final max = (funnel[0]['count'] as int).toDouble();

    return Column(
      children: funnel.asMap().entries.map((e) {
        final fraction = (e.value['count'] as int) / max;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(e.value['stage'], style: AdminTheme.caption.copyWith(fontSize: 11)),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: AdminTheme.bgGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color(e.value['color'] as int),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  child: Text(
                    e.value['count'] >= 1000
                        ? () {
                            final c = e.value['count'] as int;
                            return '${(c / 1000).toStringAsFixed(0)}K';
                          }()
                        : '${e.value['count']}',
                    style: AdminTheme.bodyText.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
