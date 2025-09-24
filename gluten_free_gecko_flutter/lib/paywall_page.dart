import 'package:flutter/material.dart';

class PaywallPage extends StatelessWidget {
  final String currentSubscription;
  final Function(String) onSubscriptionChange;

  const PaywallPage({
    Key? key,
    required this.currentSubscription,
    required this.onSubscriptionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                // Free Plan
                PlanCard(
                  title: 'Free (always)',
                  features: [
                    PlanFeature(text: 'Search restaurants', included: true),
                    PlanFeature(text: 'Community reviews & votes', included: true),
                    PlanFeature(text: 'Food stalls locked', included: false),
                    PlanFeature(text: 'Custom gecko', included: false),
                    PlanFeature(text: 'Ad-free', included: false),
                  ],
                  isCurrentPlan: currentSubscription == 'free',
                ),
                SizedBox(height: 16),
                // Monthly Plan
                PlanCard(
                  title: 'Gecko Unlimited – \$1 / month',
                  features: [
                    PlanFeature(text: 'Unlock food stalls', included: true),
                    PlanFeature(text: 'Customize your gecko', included: true),
                    PlanFeature(text: 'Exclusive food deals', included: true),
                    PlanFeature(text: 'Ad-free experience', included: true),
                  ],
                  buttonText: 'Subscribe Monthly',
                  onSubscribe: () => _handleSubscription(context, 'monthly'),
                  isCurrentPlan: currentSubscription == 'monthly',
                ),
                SizedBox(height: 16),
                // Lifetime Plan
                PlanCard(
                  title: 'Gecko Unlimited – \$9.99 Lifetime',
                  features: [
                    PlanFeature(text: 'Everything in monthly plan', included: true),
                    PlanFeature(text: 'No renewals, no hassle', included: true),
                  ],
                  buttonText: 'Buy Lifetime',
                  onSubscribe: () => _handleSubscription(context, 'lifetime'),
                  isLifetime: true,
                  isCurrentPlan: currentSubscription == 'lifetime',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscription(BuildContext context, String subscription) {
    onSubscriptionChange(subscription);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscribed to ${subscription} plan!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final List<PlanFeature> features;
  final String? buttonText;
  final VoidCallback? onSubscribe;
  final bool isLifetime;
  final bool isCurrentPlan;

  const PlanCard({
    Key? key,
    required this.title,
    required this.features,
    this.buttonText,
    this.onSubscribe,
    this.isLifetime = false,
    this.isCurrentPlan = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlan ? Color(0xFF4CAF50) : Colors.grey[300]!,
          width: isCurrentPlan ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Current',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      feature.included ? Icons.check : Icons.close,
                      color: feature.included ? Color(0xFF4CAF50) : Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      feature.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )),
          if (buttonText != null && !isCurrentPlan) ...[
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLifetime ? Color(0xFFFF9800) : Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PlanFeature {
  final String text;
  final bool included;

  PlanFeature({required this.text, required this.included});
}