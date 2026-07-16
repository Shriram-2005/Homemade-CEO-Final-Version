class MockData {
  static const Map<String, dynamic> sellerProfile = {
    'id': 'seller_123',
    'name': 'Saina',
    'location': 'Ernakulam, Kerala',
    'joined': 'January 2026',
    'lms_progress': 85, // percentage
    'active_products': 4,
    'total_revenue': 14500, // INR
    'pending_payouts': 2400,
    'profile_image': 'https://images.unsplash.com/photo-1574338556126-8eb0cbffa6e5?auto=format&fit=crop&q=80&w=200',
    'story': 'I started making banana chips using my grandmother\'s secret recipe. What began as a small passion to feed my children healthy snacks has now become a proud business. Every chip is sliced by hand and fried in pure coconut oil sourced from our local farmers.',
  };

  static const List<Map<String, dynamic>> mockProducts = [
    {
      'id': 'prod_1',
      'title': 'Authentic Kerala Banana Chips',
      'price': 150,
      'status': 'Live', // Live, Pending, Paused
      'views': 1240,
      'orders': 45,
      'ad_spend': 300,
      'seller_id': 'seller_123',
      'seller_name': 'Saina',
      'images': [
        'https://images.unsplash.com/photo-1599598425947-330026206a05?auto=format&fit=crop&q=80&w=600',
        'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=600',
      ],
      'description': 'Crispy, golden banana chips fried in 100% pure coconut oil.',
    },
    {
      'id': 'prod_2',
      'title': 'Spicy Mango Pickle',
      'price': 200,
      'status': 'Live',
      'views': 890,
      'orders': 32,
      'ad_spend': 150,
      'seller_id': 'seller_123',
      'seller_name': 'Saina',
      'images': [
        'https://images.unsplash.com/photo-1626200419109-380d60317e08?auto=format&fit=crop&q=80&w=600',
      ],
      'description': 'Traditional Kerala style spicy mango pickle made with home-ground spices.',
    },
    {
      'id': 'prod_3',
      'title': 'Organic Jackfruit Chips',
      'price': 180,
      'status': 'Pending',
      'views': 0,
      'orders': 0,
      'ad_spend': 0,
      'seller_id': 'seller_123',
      'seller_name': 'Saina',
      'images': [
        'https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&q=80&w=600',
      ],
      'description': 'Sun-dried organic jackfruit pieces gently fried for a sweet and savory crunch.',
    },
  ];

  static const Map<String, dynamic> buyerProfile = {
    'id': 'buyer_456',
    'name': 'Rahul',
    'email': 'rahul@example.com',
    'saved_products': ['prod_1'],
    'orders': [
      {
        'order_id': 'ord_999',
        'product': 'Spicy Mango Pickle',
        'status': 'Shipped',
        'date': '12 July 2026',
        'total': 200,
      }
    ]
  };
  static const List<Map<String, dynamic>> lmsModules = [
    {
      'id': 'mod_1',
      'title': 'Business Fundamentals (ബിസിനസ് അടിസ്ഥാനങ്ങൾ)',
      'status': 'Completed', // Completed, Unlocked, Locked
      'videoUrl': 'placeholder',
    },
    {
      'id': 'mod_2',
      'title': 'Product Photography (ഉൽപ്പന്ന ഫോട്ടോഗ്രാഫി)',
      'status': 'Completed',
      'videoUrl': 'placeholder',
    },
    {
      'id': 'mod_3',
      'title': 'Pricing & Margins (വിലനിർണ്ണയവും ലാഭവും)',
      'status': 'Unlocked',
      'videoUrl': 'placeholder',
    },
    {
      'id': 'mod_4',
      'title': 'Packaging & Shipping (പാക്കേജിംഗും ഷിപ്പിംഗും)',
      'status': 'Locked',
      'videoUrl': 'placeholder',
    },
  ];

  static const List<Map<String, dynamic>> payments = [
    {
      'id': 'pay_1',
      'date': '15 July 2026',
      'amount': 2400,
      'status': 'Processed',
      'details': 'Payout for 12 Orders (80% Split)',
    },
    {
      'id': 'pay_2',
      'date': '01 July 2026',
      'amount': 12100,
      'status': 'Processed',
      'details': 'Payout for 56 Orders (80% Split)',
    },
  ];

  static const List<Map<String, dynamic>> supportTickets = [
    {
      'id': 'tick_1',
      'subject': 'Delay in pickup (പിക്കപ്പിലെ കാലതാമസം)',
      'status': 'Open',
      'date': '16 July 2026',
    },
    {
      'id': 'tick_2',
      'subject': 'Payment not reflected (പേയ്‌മെന്റ് ലഭിച്ചില്ല)',
      'status': 'Resolved',
      'date': '10 July 2026',
    },
  ];

  static const List<Map<String, String>> faqs = [
    {
      'questionEn': 'How is the 80/20 revenue split calculated?',
      'questionMl': '80/20 വരുമാന വിഭജനം എങ്ങനെയാണ് കണക്കാക്കുന്നത്?',
      'answerEn': 'You receive 80% of the total selling price. The remaining 20% is used by Homemade CEO to cover platform fees, payment gateways, and Meta Ads for your products.',
      'answerMl': 'മൊത്തം വിൽപ്പന വിലയുടെ 80% നിങ്ങൾക്ക് ലഭിക്കും. ബാക്കി 20% പ്ലാറ്റ്ഫോം ഫീസ്, പേയ്‌മെന്റ് ഗേറ്റ്‌വേകൾ, നിങ്ങളുടെ ഉൽപ്പന്നങ്ങൾക്കായുള്ള മെറ്റാ പരസ്യങ്ങൾ എന്നിവയ്ക്കായി ഉപയോഗിക്കുന്നു.',
    },
    {
      'questionEn': 'When will I receive my payouts?',
      'questionMl': 'എനിക്ക് എപ്പോഴാണ് പേഔട്ടുകൾ ലഭിക്കുക?',
      'answerEn': 'Payouts are processed automatically every 15 days directly to your registered bank account.',
      'answerMl': 'ഓരോ 15 ദിവസത്തിലും നിങ്ങളുടെ രജിസ്റ്റർ ചെയ്ത ബാങ്ക് അക്കൗണ്ടിലേക്ക് നേരിട്ട് പേഔട്ടുകൾ നൽകും.',
    },
    {
      'questionEn': 'How do I take a good product photo?',
      'questionMl': 'ഒരു നല്ല ഉൽപ്പന്ന ഫോട്ടോ എങ്ങനെ എടുക്കാം?',
      'answerEn': 'Ensure good natural lighting (near a window), a clean background, and focus on the product. Do not add text or filters.',
      'answerMl': 'നല്ല പ്രകൃതിദത്ത വെളിച്ചം (ജനലിനടുത്ത്), വൃത്തിയുള്ള പശ്ചാത്തലം എന്നിവ ഉറപ്പാക്കുക. വാചകങ്ങളോ ഫിൽട്ടറുകളോ ചേർക്കരുത്.',
    },
  ];
}
