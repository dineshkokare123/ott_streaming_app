import 'package:flutter/material.dart';

enum PlanInterval { monthly, yearly }

class SubscriptionFeature {
  final String id;
  final String description;
  final bool isAvailable;

  SubscriptionFeature({
    required this.id,
    required this.description,
    this.isAvailable = true,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String currency;
  final PlanInterval interval;
  final List<SubscriptionFeature> features;
  final bool isPopular;
  final Color? color;
  final String? badgetLabel;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
    this.isPopular = false,
    this.color,
    this.badgetLabel,
  });
}

class SubscriptionService extends ChangeNotifier {
  bool _isPremium = false;
  String? _currentPlanId;

  bool get isPremium => _isPremium;
  String? get currentPlanId => _currentPlanId;

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'basic',
      name: 'Basic',
      price: 0.0,
      currency: '\$',
      interval: PlanInterval.monthly,
      features: [
        SubscriptionFeature(id: 'ads', description: 'Watch with Ads'),
        SubscriptionFeature(
          id: 'hd',
          description: '720p Streaming',
          isAvailable: true,
        ),
        SubscriptionFeature(
          id: 'download',
          description: 'Downloads',
          isAvailable: false,
        ),
        SubscriptionFeature(id: 'devices', description: '1 Device'),
      ],
    ),
    SubscriptionPlan(
      id: 'standard',
      name: 'Standard',
      price: 9.99,
      currency: '\$',
      interval: PlanInterval.monthly,
      isPopular: true,
      badgetLabel: 'MOST POPULAR',
      features: [
        SubscriptionFeature(id: 'no_ads', description: 'No Ads'),
        SubscriptionFeature(id: 'fhd', description: '1080p Streaming'),
        SubscriptionFeature(id: 'download', description: 'Downloads'),
        SubscriptionFeature(id: 'devices', description: '2 Devices'),
      ],
    ),
    SubscriptionPlan(
      id: 'premium',
      name: 'Premium',
      price: 15.99,
      currency: '\$',
      interval: PlanInterval.monthly,
      features: [
        SubscriptionFeature(id: 'no_ads', description: 'No Ads'),
        SubscriptionFeature(id: '4k', description: '4K HDR Streaming'),
        SubscriptionFeature(id: 'download', description: 'Downloads'),
        SubscriptionFeature(id: 'devices', description: '4 Devices'),
        SubscriptionFeature(id: 'dolby', description: 'Dolby Atmos'),
      ],
    ),
  ];

  List<SubscriptionPlan> get plans => _plans;

  Future<void> subscribe(String planId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _currentPlanId = planId;
    _isPremium = planId != 'basic';
    notifyListeners();
  }

  Future<void> cancelSubscription() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _currentPlanId = 'basic';
    _isPremium = false;
    notifyListeners();
  }
}
