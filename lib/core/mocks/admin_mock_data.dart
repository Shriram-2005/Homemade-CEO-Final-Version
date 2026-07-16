class AdminMockData {
  // ─── Platform KPIs ───────────────────────────────────────────────────────
  static const Map<String, dynamic> platformStats = {
    'total_sellers': 248,
    'sellers_growth': 12,
    'active_campaigns': 32,
    'total_revenue': 428000,
    'revenue_growth': 18.4,
    'platform_commission': 85600,
    'pending_approvals': 7,
    'open_tickets': 3,
    'avg_roas': 3.4,
    'total_impressions': 842000,
    'total_clicks': 12340,
    'total_ad_spend': 124500,
  };

  // ─── Monthly Revenue & Spend (12 months) ──────────────────────────────────
  static const List<Map<String, dynamic>> monthlyData = [
    {'month': 'Aug', 'revenue': 22000, 'ad_spend': 8500, 'sellers': 18},
    {'month': 'Sep', 'revenue': 31000, 'ad_spend': 10200, 'sellers': 27},
    {'month': 'Oct', 'revenue': 45000, 'ad_spend': 12000, 'sellers': 38},
    {'month': 'Nov', 'revenue': 62000, 'ad_spend': 14500, 'sellers': 55},
    {'month': 'Dec', 'revenue': 88000, 'ad_spend': 18000, 'sellers': 74},
    {'month': 'Jan', 'revenue': 71000, 'ad_spend': 15500, 'sellers': 89},
    {'month': 'Feb', 'revenue': 95000, 'ad_spend': 20000, 'sellers': 112},
    {'month': 'Mar', 'revenue': 118000, 'ad_spend': 24000, 'sellers': 140},
    {'month': 'Apr', 'revenue': 132000, 'ad_spend': 22000, 'sellers': 168},
    {'month': 'May', 'revenue': 145000, 'ad_spend': 25000, 'sellers': 198},
    {'month': 'Jun', 'revenue': 168000, 'ad_spend': 26500, 'sellers': 224},
    {'month': 'Jul', 'revenue': 188000, 'ad_spend': 28000, 'sellers': 248},
  ];

  // ─── Seller CRM Data ──────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> allSellers = [
    {
      'id': 's_001', 'name': 'Meera Krishnan', 'district': 'Ernakulam',
      'phone': '+91 94476 12345', 'kyc': 'Verified', 'lms_pct': 100,
      'products': 4, 'revenue': 14500, 'status': 'Live',
      'joined': '2026-01-12', 'profile_image': 'https://images.unsplash.com/photo-1574338556126-8eb0cbffa6e5?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_002', 'name': 'Lakshmi Devi', 'district': 'Thrissur',
      'phone': '+91 98470 23456', 'kyc': 'Verified', 'lms_pct': 75,
      'products': 2, 'revenue': 8200, 'status': 'Live',
      'joined': '2026-02-03', 'profile_image': 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_003', 'name': 'Anitha Rajesh', 'district': 'Kozhikode',
      'phone': '+91 94473 34567', 'kyc': 'Pending', 'lms_pct': 40,
      'products': 0, 'revenue': 0, 'status': 'LMS In-Progress',
      'joined': '2026-03-18', 'profile_image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_004', 'name': 'Suma Menon', 'district': 'Trivandrum',
      'phone': '+91 96330 45678', 'kyc': 'Verified', 'lms_pct': 100,
      'products': 6, 'revenue': 22400, 'status': 'Live',
      'joined': '2026-01-25', 'profile_image': 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_005', 'name': 'Priya Nair', 'district': 'Palakkad',
      'phone': '+91 94471 56789', 'kyc': 'Rejected', 'lms_pct': 0,
      'products': 0, 'revenue': 0, 'status': 'KYC Pending',
      'joined': '2026-04-02', 'profile_image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_006', 'name': 'Deepa Suresh', 'district': 'Kannur',
      'phone': '+91 98471 67890', 'kyc': 'Verified', 'lms_pct': 100,
      'products': 3, 'revenue': 11800, 'status': 'Live',
      'joined': '2026-02-14', 'profile_image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_007', 'name': 'Bindu Pillai', 'district': 'Alappuzha',
      'phone': '+91 94472 78901', 'kyc': 'Verified', 'lms_pct': 60,
      'products': 1, 'revenue': 3400, 'status': 'LMS In-Progress',
      'joined': '2026-03-30', 'profile_image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_008', 'name': 'Raji Thomas', 'district': 'Kottayam',
      'phone': '+91 96334 89012', 'kyc': 'Verified', 'lms_pct': 100,
      'products': 5, 'revenue': 19200, 'status': 'Live',
      'joined': '2026-01-08', 'profile_image': 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_009', 'name': 'Vijayalakshmi K', 'district': 'Malappuram',
      'phone': '+91 94479 90123', 'kyc': 'Pending', 'lms_pct': 20,
      'products': 0, 'revenue': 0, 'status': 'Applied',
      'joined': '2026-06-10', 'profile_image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200',
    },
    {
      'id': 's_010', 'name': 'Sindhu Gopalan', 'district': 'Wayanad',
      'phone': '+91 98479 01234', 'kyc': 'Verified', 'lms_pct': 100,
      'products': 3, 'revenue': 9800, 'status': 'Live',
      'joined': '2026-02-28', 'profile_image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&q=80&w=200',
    },
  ];

  // ─── Product Review Queue ─────────────────────────────────────────────────
  static const List<Map<String, dynamic>> reviewQueue = [
    {
      'id': 'rq_001', 'title': 'Organic Jackfruit Chips', 'seller': 'Meera Krishnan',
      'seller_district': 'Ernakulam', 'submitted_date': '2026-07-14', 'days_pending': 2,
      'price': 180, 'cost': 90, 'margin': 50.0,
      'description': 'Sun-dried organic jackfruit pieces gently fried in coconut oil for a sweet and savory crunch.',
      'images': ['https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&q=80&w=600'],
    },
    {
      'id': 'rq_002', 'title': 'Coconut Ladoo (Premium)', 'seller': 'Suma Menon',
      'seller_district': 'Trivandrum', 'submitted_date': '2026-07-15', 'days_pending': 1,
      'price': 220, 'cost': 100, 'margin': 54.5,
      'description': 'Traditional Kerala coconut ladoo made with fresh grated coconut and jaggery.',
      'images': ['https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&q=80&w=600'],
    },
    {
      'id': 'rq_003', 'title': 'Dried Ginger Candy', 'seller': 'Raji Thomas',
      'seller_district': 'Kottayam', 'submitted_date': '2026-07-13', 'days_pending': 3,
      'price': 120, 'cost': 45, 'margin': 62.5,
      'description': 'Handmade dried ginger candy with a hint of jaggery and pepper.',
      'images': ['https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?auto=format&fit=crop&q=80&w=600'],
    },
    {
      'id': 'rq_004', 'title': 'Banana Halwa', 'seller': 'Deepa Suresh',
      'seller_district': 'Kannur', 'submitted_date': '2026-07-16', 'days_pending': 0,
      'price': 160, 'cost': 70, 'margin': 56.25,
      'description': 'Nendrapazham halwa cooked in ghee with cashews and saffron.',
      'images': ['https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?auto=format&fit=crop&q=80&w=600'],
    },
  ];

  // ─── Campaign Ledger ──────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> campaignLedger = [
    {
      'id': 'cmp_001', 'date': '2026-07-10', 'seller': 'Meera Krishnan',
      'product': 'Kerala Banana Chips', 'campaign_id': 'META-23847',
      'impressions': 45200, 'clicks': 680, 'spend': 5400,
      'orders': 22, 'roas': 3.6, 'status': 'Active',
    },
    {
      'id': 'cmp_002', 'date': '2026-07-08', 'seller': 'Suma Menon',
      'product': 'Spicy Mango Pickle', 'campaign_id': 'META-23801',
      'impressions': 38900, 'clicks': 510, 'spend': 4200,
      'orders': 18, 'roas': 2.9, 'status': 'Paused',
    },
    {
      'id': 'cmp_003', 'date': '2026-07-05', 'seller': 'Raji Thomas',
      'product': 'Kerala Fish Curry Paste', 'campaign_id': 'META-23765',
      'impressions': 62100, 'clicks': 920, 'spend': 7800,
      'orders': 38, 'roas': 4.2, 'status': 'Active',
    },
    {
      'id': 'cmp_004', 'date': '2026-06-28', 'seller': 'Deepa Suresh',
      'product': 'Coconut Chutney Powder', 'campaign_id': 'META-23711',
      'impressions': 28400, 'clicks': 310, 'spend': 2900,
      'orders': 8, 'roas': 1.2, 'status': 'Stalled',
    },
    {
      'id': 'cmp_005', 'date': '2026-06-20', 'seller': 'Sindhu Gopalan',
      'product': 'Organic Turmeric Powder', 'campaign_id': 'META-23644',
      'impressions': 71500, 'clicks': 1100, 'spend': 9200,
      'orders': 44, 'roas': 5.1, 'status': 'Completed',
    },
    {
      'id': 'cmp_006', 'date': '2026-06-15', 'seller': 'Lakshmi Devi',
      'product': 'Tapioca Chips', 'campaign_id': 'META-23598',
      'impressions': 34200, 'clicks': 430, 'spend': 3600,
      'orders': 14, 'roas': 2.1, 'status': 'Completed',
    },
    {
      'id': 'cmp_007', 'date': '2026-07-12', 'seller': 'Meera Krishnan',
      'product': 'Spicy Mango Pickle', 'campaign_id': 'META-23890',
      'impressions': 55000, 'clicks': 820, 'spend': 6500,
      'orders': 30, 'roas': 3.8, 'status': 'Active',
    },
    {
      'id': 'cmp_008', 'date': '2026-07-01', 'seller': 'Raji Thomas',
      'product': 'Homemade Ghee', 'campaign_id': 'META-23820',
      'impressions': 48600, 'clicks': 740, 'spend': 5800,
      'orders': 25, 'roas': 3.2, 'status': 'Active',
    },
  ];

  // ─── District-wise Data for Analytics ────────────────────────────────────
  static const List<Map<String, dynamic>> districtData = [
    {'district': 'Ernakulam', 'sellers': 42, 'revenue': 88400, 'products': 61},
    {'district': 'Trivandrum', 'sellers': 38, 'revenue': 74200, 'products': 55},
    {'district': 'Kozhikode', 'sellers': 31, 'revenue': 58900, 'products': 44},
    {'district': 'Thrissur', 'sellers': 28, 'revenue': 52100, 'products': 38},
    {'district': 'Malappuram', 'sellers': 24, 'revenue': 44600, 'products': 31},
    {'district': 'Palakkad', 'sellers': 19, 'revenue': 36200, 'products': 24},
    {'district': 'Kottayam', 'sellers': 22, 'revenue': 41800, 'products': 30},
    {'district': 'Kannur', 'sellers': 18, 'revenue': 33500, 'products': 22},
    {'district': 'Alappuzha', 'sellers': 14, 'revenue': 26700, 'products': 18},
    {'district': 'Wayanad', 'sellers': 12, 'revenue': 20400, 'products': 15},
  ];

  // ─── Conversion Funnel ────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> conversionFunnel = [
    {'stage': 'Impressions', 'count': 842000, 'color': 0xFF3B82F6},
    {'stage': 'Ad Clicks', 'count': 12340, 'color': 0xFF6366F1},
    {'stage': 'WhatsApp Opens', 'count': 4820, 'color': 0xFF8B5CF6},
    {'stage': 'Orders Confirmed', 'count': 1940, 'color': 0xFFD97706},
  ];

  // ─── Activity Feed ────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> activityFeed = [
    {
      'type': 'seller_registered', 'time': '2 min ago',
      'message': 'Vijayalakshmi K from Malappuram registered as a new seller.',
    },
    {
      'type': 'product_approved', 'time': '18 min ago',
      'message': 'Coconut Ladoo by Suma Menon was approved and is now Live.',
    },
    {
      'type': 'campaign_stalled', 'time': '1 hr ago',
      'message': 'Campaign META-23804 (Coconut Chutney Powder) ROAS dropped below threshold.',
    },
    {
      'type': 'payout_processed', 'time': '3 hrs ago',
      'message': 'Bi-weekly payouts processed for 38 sellers. Total: ₹1,24,800.',
    },
    {
      'type': 'kyc_rejected', 'time': '5 hrs ago',
      'message': 'KYC documents for Priya Nair (Palakkad) were rejected — ID mismatch.',
    },
    {
      'type': 'product_submitted', 'time': '6 hrs ago',
      'message': 'Banana Halwa submitted by Deepa Suresh (Kannur) is pending review.',
    },
  ];

  // ─── Admin Users ──────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> adminUsers = [
    {
      'id': 'adm_001', 'name': 'Arjun Menon', 'email': 'arjun@homemadeceo.in',
      'role': 'Super Admin', 'last_active': '5 min ago',
    },
    {
      'id': 'adm_002', 'name': 'Preethi Varma', 'email': 'preethi@homemadeceo.in',
      'role': 'Product Reviewer', 'last_active': '2 hrs ago',
    },
    {
      'id': 'adm_003', 'name': 'Suresh Babu', 'email': 'suresh@kudumbashree.org',
      'role': 'Finance Officer', 'last_active': '1 day ago',
    },
  ];

  // ─── Top Products by Revenue ──────────────────────────────────────────────
  static const List<Map<String, dynamic>> topProducts = [
    {'name': 'Kerala Banana Chips', 'seller': 'Meera Krishnan', 'revenue': 28400, 'orders': 142},
    {'name': 'Organic Turmeric Powder', 'seller': 'Sindhu Gopalan', 'revenue': 22100, 'orders': 98},
    {'name': 'Fish Curry Paste', 'seller': 'Raji Thomas', 'revenue': 19800, 'orders': 88},
    {'name': 'Coconut Ladoo Premium', 'seller': 'Suma Menon', 'revenue': 18600, 'orders': 76},
    {'name': 'Spicy Mango Pickle', 'seller': 'Meera Krishnan', 'revenue': 17200, 'orders': 68},
    {'name': 'Homemade Ghee', 'seller': 'Raji Thomas', 'revenue': 15900, 'orders': 54},
    {'name': 'Coconut Chutney Powder', 'seller': 'Deepa Suresh', 'revenue': 12400, 'orders': 48},
    {'name': 'Tapioca Chips', 'seller': 'Lakshmi Devi', 'revenue': 10200, 'orders': 41},
  ];
}
