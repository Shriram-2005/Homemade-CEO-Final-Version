import 'package:flutter/material.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminSettingsTab extends StatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  State<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends State<AdminSettingsTab> {
  double _commissionPct = 20;
  String _payoutSchedule = 'Bi-Weekly';
  bool _autoApproval = false;
  final _budgetCtrl = TextEditingController(text: '5000');

  // Notification prefs
  bool _notifyNewSeller = true;
  bool _notifyProductSubmit = true;
  bool _notifyCampaignStall = true;
  bool _notifyPayout = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Settings', style: AdminTheme.heading1),
          const SizedBox(height: 4),
          Text('Configure platform-wide settings, admin accounts, and system health.', style: AdminTheme.caption),
          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  children: [
                    _buildPlatformConfig(),
                    const SizedBox(height: 24),
                    _buildNotificationPrefs(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right Column
              Expanded(
                child: Column(
                  children: [
                    _buildAdminUsers(),
                    const SizedBox(height: 24),
                    _buildSystemHealth(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformConfig() {
    return _card(
      'Platform Configuration',
      Icons.settings_outlined,
      child: Column(
        children: [
          _buildSectionItem(
            'Platform Commission (%)',
            'Percentage of revenue retained by the platform.',
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _commissionPct,
                    min: 5, max: 35, divisions: 30,
                    activeColor: AdminTheme.accentBlue,
                    onChanged: (v) => setState(() => _commissionPct = v),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AdminTheme.accentBlue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${_commissionPct.toStringAsFixed(0)}%', style: TextStyle(color: AdminTheme.accentBlue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Divider(color: AdminTheme.borderColor, height: 24),
          _buildSectionItem(
            'Payout Schedule',
            'How frequently sellers receive their earnings.',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: AdminTheme.borderColor), borderRadius: BorderRadius.circular(8)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _payoutSchedule,
                  items: ['Weekly', 'Bi-Weekly', 'Monthly'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: AdminTheme.bodyText))).toList(),
                  onChanged: (v) => setState(() => _payoutSchedule = v!),
                ),
              ),
            ),
          ),
          Divider(color: AdminTheme.borderColor, height: 24),
          _buildSectionItem(
            'Auto-Approve Products',
            'Skip manual review for products from verified sellers with 100% LMS completion.',
            child: Row(
              children: [
                Switch(value: _autoApproval, onChanged: (v) => setState(() => _autoApproval = v), activeTrackColor: AdminTheme.accentBlue, activeThumbColor: Colors.white),
                const SizedBox(width: 8),
                Text(_autoApproval ? 'Enabled' : 'Disabled', style: AdminTheme.caption),
              ],
            ),
          ),
          Divider(color: AdminTheme.borderColor, height: 24),
          _buildSectionItem(
            'Max Ad Budget Per Seller (₹/month)',
            'Ceiling on Meta ad spend allocated per seller.',
            child: SizedBox(
              width: 180,
              child: TextField(
                controller: _budgetCtrl,
                keyboardType: TextInputType.number,
                style: AdminTheme.bodyText,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AdminTheme.borderColor)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Platform settings saved.'), backgroundColor: AdminTheme.accentGreen),
              ),
              icon: const Icon(Icons.save_outlined, size: 16),
              label: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminTheme.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPrefs() {
    return _card(
      'Notification Preferences',
      Icons.notifications_outlined,
      child: Column(
        children: [
          _notifToggle('New Seller Registered', 'Get alerted when a new seller joins the platform.', _notifyNewSeller, (v) => setState(() => _notifyNewSeller = v)),
          Divider(color: AdminTheme.borderColor, height: 20),
          _notifToggle('Product Submission', 'Alert when a new product enters the review queue.', _notifyProductSubmit, (v) => setState(() => _notifyProductSubmit = v)),
          Divider(color: AdminTheme.borderColor, height: 20),
          _notifToggle('Campaign Stalled', 'Alert when a campaign ROAS drops below threshold.', _notifyCampaignStall, (v) => setState(() => _notifyCampaignStall = v)),
          Divider(color: AdminTheme.borderColor, height: 20),
          _notifToggle('Payout Processed', 'Alert when seller payouts are disbursed.', _notifyPayout, (v) => setState(() => _notifyPayout = v)),
        ],
      ),
    );
  }

  Widget _buildAdminUsers() {
    final users = AdminMockData.adminUsers;
    final roleColors = {
      'Super Admin': AdminTheme.accentRed,
      'Product Reviewer': AdminTheme.accentBlue,
      'Finance Officer': AdminTheme.accentGold,
    };

    return _card(
      'Admin Users',
      Icons.manage_accounts_outlined,
      action: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 16, color: AdminTheme.accentBlue),
        label: const Text('Add Admin', style: TextStyle(color: AdminTheme.accentBlue, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
      child: Column(
        children: users.map((u) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: (roleColors[u['role']] ?? AdminTheme.accentBlue).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(u['name'].toString()[0], style: TextStyle(color: roleColors[u['role']] ?? AdminTheme.accentBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u['name'], style: AdminTheme.labelBold),
                    Text(u['email'], style: AdminTheme.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AdminTheme.statusChip(u['role']),
                  const SizedBox(height: 4),
                  Text('Active ${u['last_active']}', style: AdminTheme.caption.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSystemHealth() {
    return _card(
      'System Health',
      Icons.health_and_safety_outlined,
      child: Column(
        children: [
          _statusRow(Icons.smart_toy_outlined, 'Jami WhatsApp Bot', 'Active', AdminTheme.accentGreen),
          Divider(color: AdminTheme.borderColor, height: 20),
          _statusRow(Icons.sync_outlined, 'Meta API Last Sync', '11:28 AM today', AdminTheme.accentBlue),
          Divider(color: AdminTheme.borderColor, height: 20),
          _statusRow(Icons.backup_outlined, 'Database Backup', 'Last: 03:00 AM today', AdminTheme.accentGreen),
          Divider(color: AdminTheme.borderColor, height: 20),
          _statusRow(Icons.cloud_done_outlined, 'Storage Usage', '68% (34 GB / 50 GB)', AdminTheme.accentOrange),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup triggered. Will complete in ~2 minutes.'), backgroundColor: AdminTheme.accentGreen),
              ),
              icon: const Icon(Icons.backup_outlined, size: 16),
              label: const Text('Trigger Backup Now', style: TextStyle(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AdminTheme.accentBlue,
                side: const BorderSide(color: AdminTheme.accentBlue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, IconData icon, {required Widget child, Widget? action}) {
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
              const Spacer(),
              if (action != null) action,
            ],
          ),
          Divider(color: AdminTheme.borderColor, height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildSectionItem(String title, String subtitle, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AdminTheme.labelBold),
        const SizedBox(height: 2),
        Text(subtitle, style: AdminTheme.caption.copyWith(fontSize: 11)),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _notifToggle(String title, String subtitle, bool value, ValueChanged<bool> onChange) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AdminTheme.labelBold.copyWith(fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle, style: AdminTheme.caption.copyWith(fontSize: 11)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChange, activeTrackColor: AdminTheme.accentBlue, activeThumbColor: Colors.white),
      ],
    );
  }

  Widget _statusRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AdminTheme.labelBold.copyWith(fontSize: 13)),
              Text(value, style: AdminTheme.caption),
            ],
          ),
        ),
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
