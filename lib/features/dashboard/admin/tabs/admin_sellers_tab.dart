import 'package:flutter/material.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminSellersTab extends StatefulWidget {
  const AdminSellersTab({super.key});

  @override
  State<AdminSellersTab> createState() => _AdminSellersTabState();
}

class _AdminSellersTabState extends State<AdminSellersTab> {
  String _filterDistrict = 'All';
  String _filterStatus = 'All';
  String _searchQuery = '';
  Map<String, dynamic>? _selectedSeller;
  final _searchCtrl = TextEditingController();

  final _districts = ['All', 'Ernakulam', 'Thrissur', 'Kozhikode', 'Trivandrum', 'Palakkad', 'Kottayam', 'Kannur', 'Alappuzha', 'Wayanad', 'Malappuram'];
  final _statuses = ['All', 'Live', 'LMS In-Progress', 'KYC Pending', 'Applied', 'Suspended'];

  List<Map<String, dynamic>> get _filtered {
    return AdminMockData.allSellers.where((s) {
      final matchesDistrict = _filterDistrict == 'All' || s['district'] == _filterDistrict;
      final matchesStatus = _filterStatus == 'All' || s['status'] == _filterStatus;
      final matchesSearch = _searchQuery.isEmpty ||
          s['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['phone'].toString().contains(_searchQuery);
      return matchesDistrict && matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main Table Area
        Expanded(
          flex: _selectedSeller != null ? 3 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildFilterBar(),
              Expanded(child: _buildTable()),
            ],
          ),
        ),
        // Seller Detail Drawer
        if (_selectedSeller != null) ...[
          VerticalDivider(color: AdminTheme.borderColor, width: 1),
          Expanded(
            flex: 1,
            child: _SellerDetailPanel(
              seller: _selectedSeller!,
              onClose: () => setState(() => _selectedSeller = null),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seller CRM Pipeline', style: AdminTheme.heading1),
              const SizedBox(height: 4),
              Text('${_filtered.length} sellers matching current filters', style: AdminTheme.caption),
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
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
      child: Row(
        children: [
          // Search
          SizedBox(
            width: 260,
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AdminTheme.bodyText,
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                hintStyle: AdminTheme.caption,
                prefixIcon: const Icon(Icons.search, size: 18, color: AdminTheme.textSecondary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AdminTheme.borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AdminTheme.borderColor)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildDropdown('District', _districts, _filterDistrict, (v) => setState(() => _filterDistrict = v!)),
          const SizedBox(width: 12),
          _buildDropdown('Status', _statuses, _filterStatus, (v) => setState(() => _filterStatus = v!)),
          const Spacer(),
          Text('${_filtered.length} results', style: AdminTheme.caption),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String value, ValueChanged<String?> onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminTheme.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: AdminTheme.bodyText.copyWith(fontSize: 13)))).toList(),
          onChanged: onChange,
          hint: Text(label, style: AdminTheme.caption),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AdminTheme.textSecondary),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Container(
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
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.8),
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1.5),
              7: FlexColumnWidth(1.5),
              8: FlexColumnWidth(2),
            },
            children: [
              _buildHeaderRow(),
              ..._filtered.asMap().entries.map((e) => _buildDataRow(e.value, e.key.isEven)),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    final cols = ['Seller Name', 'District', 'Phone', 'KYC', 'LMS %', 'Products', 'Revenue', 'Status', 'Actions'];
    return TableRow(
      decoration: BoxDecoration(color: AdminTheme.bgGrey),
      children: cols.map((c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(c, style: AdminTheme.caption.copyWith(fontWeight: FontWeight.w700, color: AdminTheme.textSecondary, letterSpacing: 0.5, fontSize: 11)),
      )).toList(),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> seller, bool even) {
    return TableRow(
      decoration: BoxDecoration(
        color: even ? Colors.white : AdminTheme.bgPage,
      ),
      children: [
        // Name + Avatar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(seller['profile_image'])),
              const SizedBox(width: 10),
              Text(seller['name'], style: AdminTheme.labelBold),
            ],
          ),
        ),
        _cell(seller['district']),
        _cell(seller['phone']),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: AdminTheme.statusChip(seller['kyc']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${seller['lms_pct']}%', style: AdminTheme.labelBold),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: seller['lms_pct'] / 100,
                backgroundColor: AdminTheme.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(seller['lms_pct'] == 100 ? AdminTheme.accentGreen : AdminTheme.accentBlue),
                borderRadius: BorderRadius.circular(4),
                minHeight: 4,
              ),
            ],
          ),
        ),
        _cell('${seller['products']}'),
        _cell('₹${seller['revenue']}', bold: true, color: AdminTheme.accentGold),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: AdminTheme.statusChip(seller['status']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _actionBtn(Icons.visibility_outlined, 'View', AdminTheme.accentBlue, () {
                setState(() => _selectedSeller = seller);
              }),
              const SizedBox(width: 6),
              _actionBtn(Icons.block_outlined, 'Suspend', AdminTheme.accentRed, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Suspend action for ${seller['name']}'), backgroundColor: AdminTheme.accentRed),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cell(String text, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(text, style: AdminTheme.bodyText.copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.normal, color: color ?? AdminTheme.textPrimary, fontSize: 13)),
    );
  }

  Widget _actionBtn(IconData icon, String tooltip, Color color, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}

// ─── Seller Detail Panel ──────────────────────────────────────────────────────
class _SellerDetailPanel extends StatelessWidget {
  final Map<String, dynamic> seller;
  final VoidCallback onClose;

  const _SellerDetailPanel({required this.seller, required this.onClose});

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
                Text('Seller Profile', style: AdminTheme.heading2),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, size: 18, color: AdminTheme.textSecondary), onPressed: onClose),
              ],
            ),
            Divider(color: AdminTheme.borderColor, height: 24),
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 36, backgroundImage: NetworkImage(seller['profile_image'])),
                  const SizedBox(height: 12),
                  Text(seller['name'], style: AdminTheme.heading2),
                  const SizedBox(height: 4),
                  Text(seller['district'], style: AdminTheme.caption),
                  const SizedBox(height: 8),
                  AdminTheme.statusChip(seller['status']),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.phone_outlined, 'Phone', seller['phone']),
            _infoRow(Icons.calendar_today_outlined, 'Joined', seller['joined']),
            _infoRow(Icons.verified_outlined, 'KYC Status', seller['kyc']),
            _infoRow(Icons.shopping_bag_outlined, 'Products', '${seller['products']}'),
            _infoRow(Icons.currency_rupee_outlined, 'Total Revenue', '₹${seller['revenue']}'),
            const SizedBox(height: 20),
            Text('LMS Progress', style: AdminTheme.labelBold),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: seller['lms_pct'] / 100,
                minHeight: 10,
                backgroundColor: AdminTheme.bgGrey,
                valueColor: AlwaysStoppedAnimation<Color>(seller['lms_pct'] == 100 ? AdminTheme.accentGreen : AdminTheme.accentBlue),
              ),
            ),
            const SizedBox(height: 6),
            Text('${seller['lms_pct']}% complete', style: AdminTheme.caption),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_outlined, size: 16),
                label: const Text('Message via WhatsApp'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminTheme.accentGreen,
                  side: const BorderSide(color: AdminTheme.accentGreen),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.block_outlined, size: 16),
                label: const Text('Suspend Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminTheme.accentRed,
                  side: const BorderSide(color: AdminTheme.accentRed),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AdminTheme.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AdminTheme.caption),
                Text(value, style: AdminTheme.labelBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
