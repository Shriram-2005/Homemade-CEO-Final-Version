import 'package:flutter/material.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminCampaignsTab extends StatefulWidget {
  const AdminCampaignsTab({super.key});

  @override
  State<AdminCampaignsTab> createState() => _AdminCampaignsTabState();
}

class _AdminCampaignsTabState extends State<AdminCampaignsTab> {
  double _roasPauseThreshold = 1.5;
  double _roasScaleThreshold = 4.0;
  bool _autoPause = true;
  bool _autoScale = false;

  final _stats = AdminMockData.platformStats;
  final _ledger = AdminMockData.campaignLedger;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Ledger
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
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
                        Text('Campaign Spend Ledger', style: AdminTheme.heading1),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.lock_outline, size: 12, color: AdminTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text('Immutable audit-grade record — read-only', style: AdminTheme.caption.copyWith(color: AdminTheme.accentRed)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined, size: 16, color: AdminTheme.accentBlue),
                      label: const Text('Export CSV', style: TextStyle(color: AdminTheme.accentBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AdminTheme.accentBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: AdminTheme.accentPurple),
                      label: const Text('Export PDF (Govt.)', style: TextStyle(color: AdminTheme.accentPurple, fontSize: 13, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AdminTheme.accentPurple),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary Cards
                Row(
                  children: [
                    _summaryCard('Total Spend', '₹${_fmt(_stats['total_ad_spend'])}', Icons.payments_outlined, AdminTheme.accentBlue),
                    const SizedBox(width: 12),
                    _summaryCard('Impressions', _fmt(_stats['total_impressions']), Icons.visibility_outlined, AdminTheme.accentPurple),
                    const SizedBox(width: 12),
                    _summaryCard('Total Clicks', _fmt(_stats['total_clicks']), Icons.ads_click_outlined, AdminTheme.accentCyan),
                    const SizedBox(width: 12),
                    _summaryCard('Avg. ROAS', '${_stats['avg_roas']}x', Icons.trending_up, AdminTheme.accentGreen),
                  ],
                ),
                const SizedBox(height: 24),

                // Ledger Table
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AdminTheme.borderColor),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AdminTheme.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(90),
                        1: FlexColumnWidth(1.8),
                        2: FlexColumnWidth(2),
                        3: FixedColumnWidth(110),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                        7: FlexColumnWidth(0.8),
                        8: FlexColumnWidth(0.8),
                        9: FlexColumnWidth(1.2),
                      },
                      children: [
                        _ledgerHeaderRow(),
                        ..._ledger.asMap().entries.map((e) => _ledgerDataRow(e.value, e.key.isEven)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        VerticalDivider(color: AdminTheme.borderColor, width: 1),
        // ROI Controls Sidebar
        SizedBox(
          width: 280,
          child: _RoiControlsSidebar(
            pauseThreshold: _roasPauseThreshold,
            scaleThreshold: _roasScaleThreshold,
            autoPause: _autoPause,
            autoScale: _autoScale,
            onPauseChanged: (v) => setState(() => _roasPauseThreshold = v),
            onScaleChanged: (v) => setState(() => _roasScaleThreshold = v),
            onAutoPauseChanged: (v) => setState(() => _autoPause = v),
            onAutoScaleChanged: (v) => setState(() => _autoScale = v),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AdminTheme.borderColor),
          borderRadius: BorderRadius.circular(10),
          boxShadow: AdminTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AdminTheme.heading2.copyWith(color: color, fontSize: 18)),
                Text(label, style: AdminTheme.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _ledgerHeaderRow() {
    final cols = ['Date', 'Seller', 'Product', 'Campaign ID', 'Impressions', 'Clicks', 'Spend', 'Orders', 'ROAS', 'Status'];
    return TableRow(
      decoration: BoxDecoration(color: AdminTheme.bgGrey),
      children: cols.map((c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Text(c, style: AdminTheme.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 10)),
      )).toList(),
    );
  }

  TableRow _ledgerDataRow(Map<String, dynamic> row, bool even) {
    final roas = row['roas'] as double;
    Color roasColor = roas >= 3.0 ? AdminTheme.accentGreen : roas >= 1.5 ? AdminTheme.accentOrange : AdminTheme.accentRed;
    return TableRow(
      decoration: BoxDecoration(color: even ? Colors.white : AdminTheme.bgPage),
      children: [
        _lCell(row['date'].toString().substring(5)),
        _lCell(row['seller']),
        _lCell(row['product'], maxLines: 2),
        _lCell(row['campaign_id'], color: AdminTheme.accentBlue, mono: true),
        _lCell(_fmtNum(row['impressions'])),
        _lCell('${row['clicks']}'),
        _lCell('₹${row['spend']}', bold: true),
        _lCell('${row['orders']}'),
        _lCell('${roas}x', bold: true, color: roasColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: AdminTheme.statusChip(row['status']),
        ),
      ],
    );
  }

  Widget _lCell(String text, {bool bold = false, Color? color, int maxLines = 1, bool mono = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          color: color ?? AdminTheme.textPrimary,
          fontFamily: mono ? 'monospace' : null,
          height: 1.4,
        ),
      ),
    );
  }

  String _fmt(dynamic val) {
    final n = (val as num).toInt();
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }

  String _fmtNum(dynamic val) {
    final n = (val as num).toInt();
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }
}

// ─── ROI Controls Sidebar ─────────────────────────────────────────────────────
class _RoiControlsSidebar extends StatelessWidget {
  final double pauseThreshold;
  final double scaleThreshold;
  final bool autoPause;
  final bool autoScale;
  final ValueChanged<double> onPauseChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<bool> onAutoPauseChanged;
  final ValueChanged<bool> onAutoScaleChanged;

  const _RoiControlsSidebar({
    required this.pauseThreshold, required this.scaleThreshold,
    required this.autoPause, required this.autoScale,
    required this.onPauseChanged, required this.onScaleChanged,
    required this.onAutoPauseChanged, required this.onAutoScaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, size: 18, color: AdminTheme.accentBlue),
                const SizedBox(width: 8),
                Text('ROI Controls', style: AdminTheme.heading2),
              ],
            ),
            const SizedBox(height: 6),
            Text('Configure automated campaign responses', style: AdminTheme.caption),
            Divider(color: AdminTheme.borderColor, height: 32),

            // Auto-Pause Toggle
            _buildToggleRow('Auto-Pause Failing Campaigns', autoPause, onAutoPauseChanged, AdminTheme.accentRed),
            const SizedBox(height: 8),
            Text('Pause if ROAS falls below:', style: AdminTheme.caption),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: pauseThreshold,
                    min: 0.5, max: 3.0, divisions: 10,
                    activeColor: AdminTheme.accentRed,
                    onChanged: autoPause ? onPauseChanged : null,
                    label: '${pauseThreshold.toStringAsFixed(1)}x',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AdminTheme.accentRed),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${pauseThreshold.toStringAsFixed(1)}x', style: TextStyle(color: AdminTheme.accentRed, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            Divider(color: AdminTheme.borderColor, height: 32),

            // Auto-Scale Toggle
            _buildToggleRow('Auto-Scale High Performers', autoScale, onAutoScaleChanged, AdminTheme.accentGreen),
            const SizedBox(height: 8),
            Text('Scale budget if ROAS exceeds:', style: AdminTheme.caption),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: scaleThreshold,
                    min: 2.0, max: 8.0, divisions: 12,
                    activeColor: AdminTheme.accentGreen,
                    onChanged: autoScale ? onScaleChanged : null,
                    label: '${scaleThreshold.toStringAsFixed(1)}x',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AdminTheme.accentGreen),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${scaleThreshold.toStringAsFixed(1)}x', style: TextStyle(color: AdminTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            Divider(color: AdminTheme.borderColor, height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ROI thresholds saved successfully.'), backgroundColor: AdminTheme.accentGreen),
                  );
                },
                icon: const Icon(Icons.save_outlined, size: 16),
                label: const Text('Save Thresholds', style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),

            Divider(color: AdminTheme.borderColor, height: 32),
            Text('Quick Legend', style: AdminTheme.heading2),
            const SizedBox(height: 12),
            _legendRow(AdminTheme.accentGreen, 'Active — Campaign running normally'),
            _legendRow(AdminTheme.accentOrange, 'Paused — Manually or auto-paused'),
            _legendRow(AdminTheme.accentRed, 'Stalled — ROAS below threshold'),
            _legendRow(AdminTheme.textSecondary, 'Completed — Campaign ended'),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChange, Color color) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AdminTheme.labelBold.copyWith(fontSize: 13))),
        Switch(value: value, onChanged: onChange, activeTrackColor: color, activeThumbColor: Colors.white),
      ],
    );
  }

  Widget _legendRow(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 3), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AdminTheme.caption.copyWith(fontSize: 11))),
        ],
      ),
    );
  }
}
