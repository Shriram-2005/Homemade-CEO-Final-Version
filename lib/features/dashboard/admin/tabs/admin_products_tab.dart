import 'package:flutter/material.dart';
import '../../../../core/mocks/admin_mock_data.dart';
import '../admin_theme.dart';

class AdminProductsTab extends StatefulWidget {
  const AdminProductsTab({super.key});

  @override
  State<AdminProductsTab> createState() => _AdminProductsTabState();
}

class _AdminProductsTabState extends State<AdminProductsTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final queue = AdminMockData.reviewQueue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Queue List
        SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Review Queue', style: AdminTheme.heading1),
                    const SizedBox(height: 4),
                    Text('${queue.length} products awaiting review', style: AdminTheme.caption),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: queue.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = queue[index];
                    final isSelected = index == _selectedIndex;
                    final daysPending = item['days_pending'] as int;
                    return InkWell(
                      onTap: () => setState(() => _selectedIndex = index),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? AdminTheme.accentBlue.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AdminTheme.accentBlue : AdminTheme.borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected ? [] : AdminTheme.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(item['title'], style: AdminTheme.labelBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                                if (daysPending > 1)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: (daysPending > 2 ? AdminTheme.accentRed : AdminTheme.accentOrange).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${daysPending}d',
                                      style: TextStyle(
                                        color: daysPending > 2 ? AdminTheme.accentRed : AdminTheme.accentOrange,
                                        fontSize: 10, fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(item['seller'], style: AdminTheme.caption),
                            Text(item['seller_district'], style: AdminTheme.caption),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.currency_rupee, size: 13, color: AdminTheme.textSecondary),
                                Text('${item['price']}', style: AdminTheme.caption.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Icon(Icons.trending_up, size: 13, color: AdminTheme.accentGreen),
                                Text('${item['margin']}% margin', style: AdminTheme.caption.copyWith(color: AdminTheme.accentGreen)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(color: AdminTheme.borderColor, width: 1),
        // Detail Panel
        Expanded(child: _ProductDetailPanel(product: queue[_selectedIndex])),
      ],
    );
  }
}

class _ProductDetailPanel extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductDetailPanel({required this.product});

  @override
  State<_ProductDetailPanel> createState() => _ProductDetailPanelState();
}

class _ProductDetailPanelState extends State<_ProductDetailPanel> {
  String? _rejectReason;
  final _rejectionReasons = [
    'Blurry or low quality photos',
    'Photo has text/watermarks',
    'Product not visible clearly',
    'Misleading description',
    'Price below minimum margin',
    'Other (specify below)',
  ];

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final sellerPayout = ((p['price'] as int) * 0.8).toInt();
    final platformFee = ((p['price'] as int) * 0.2).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Actions
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['title'], style: AdminTheme.heading1),
                  const SizedBox(height: 4),
                  Text('Submitted by ${p['seller']} · ${p['seller_district']} · ${p['days_pending']} day(s) pending', style: AdminTheme.caption),
                ],
              ),
              const Spacer(),
              _actionButton(Icons.check_circle_outline, 'Approve', AdminTheme.accentGreen, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product approved! Seller will be notified via WhatsApp.'), backgroundColor: AdminTheme.accentGreen),
                );
              }),
              const SizedBox(width: 12),
              _actionButton(Icons.flag_outlined, 'Flag', AdminTheme.accentOrange, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product flagged for further review.'), backgroundColor: AdminTheme.accentOrange),
                );
              }),
              const SizedBox(width: 12),
              _actionButton(Icons.cancel_outlined, 'Reject', AdminTheme.accentRed, () => _showRejectDialog(context)),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Images
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Images', style: AdminTheme.heading2),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        (p['images'] as List).first,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 280,
                          color: AdminTheme.bgGrey,
                          child: const Center(child: Icon(Icons.image_not_supported_outlined, color: AdminTheme.textSecondary, size: 40)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Description', style: AdminTheme.heading2),
                    const SizedBox(height: 8),
                    Text(p['description'], style: AdminTheme.bodyText),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right: Data Panel
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Margin Validation', style: AdminTheme.heading2),
                    const SizedBox(height: 12),
                    _buildMarginCard('Selling Price', '₹${p['price']}', AdminTheme.textPrimary, isTotal: true),
                    const SizedBox(height: 8),
                    _buildMarginCard('Cost of Goods', '₹${p['cost']}', AdminTheme.accentRed),
                    const SizedBox(height: 8),
                    _buildMarginCard('Gross Margin', '${p['margin']}%', AdminTheme.accentGreen),
                    const SizedBox(height: 16),
                    Divider(color: AdminTheme.borderColor),
                    const SizedBox(height: 16),
                    Text('Revenue Split (80/20)', style: AdminTheme.heading2),
                    const SizedBox(height: 12),
                    _buildMarginCard('Seller Payout (80%)', '₹$sellerPayout', AdminTheme.accentGreen),
                    const SizedBox(height: 8),
                    _buildMarginCard('Platform Fee (20%)', '₹$platformFee', AdminTheme.accentBlue),
                    const SizedBox(height: 24),
                    // Ad Poster Preview Placeholder
                    Text('Auto-Generated Ad Poster', style: AdminTheme.heading2),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AdminTheme.bgGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AdminTheme.borderColor),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_search_outlined, size: 32, color: AdminTheme.textSecondary),
                            SizedBox(height: 8),
                            Text('Ad poster generated by Jami\nwill appear here', textAlign: TextAlign.center, style: TextStyle(color: AdminTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarginCard(String label, String value, Color color, {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTotal ? AdminTheme.bgGrey : Colors.white,
        border: Border.all(color: AdminTheme.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AdminTheme.bodyText.copyWith(fontSize: 13)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    String? selectedReason = _rejectReason;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.cancel_outlined, color: AdminTheme.accentRed, size: 20),
              const SizedBox(width: 8),
              Text('Reject Product', style: AdminTheme.heading2.copyWith(color: AdminTheme.accentRed)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select a reason. The seller will be notified via WhatsApp.', style: AdminTheme.bodyText),
                const SizedBox(height: 16),
                ..._rejectionReasons.map((r) => InkWell(
                  onTap: () => setDialogState(() => selectedReason = r),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 18, height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedReason == r ? AdminTheme.accentRed : AdminTheme.borderColor,
                              width: 2,
                            ),
                          ),
                          child: selectedReason == r
                              ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AdminTheme.accentRed, shape: BoxShape.circle)))
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(r, style: AdminTheme.bodyText.copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selectedReason == null ? null : () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rejected: "$selectedReason". WhatsApp sent to seller.'), backgroundColor: AdminTheme.accentRed),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AdminTheme.accentRed, foregroundColor: Colors.white),
              child: const Text('Confirm Rejection'),
            ),
          ],
        ),
      ),
    );
  }
}
