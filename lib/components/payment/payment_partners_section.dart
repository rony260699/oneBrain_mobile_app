import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme_colors.dart';

class PaymentPartnersSection extends StatelessWidget {
  const PaymentPartnersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: ThemeColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          SizedBox(height: 24.h),
          
          // Payment Methods
          _buildPaymentMethods(),
          SizedBox(height: 24.h),
          
          // Security Info
          _buildSecurityInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: ThemeColors.primaryLinearGradient,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.payment,
            color: Colors.white,
            size: 28.w,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Payment Methods',
          style: TextStyle(
            color: ThemeColors.textPrimary,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Choose from multiple secure payment options',
          style: TextStyle(
            color: ThemeColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {
        'name': 'bKash',
        'description': 'Pay with your bKash account',
        'icon': Icons.account_balance_wallet,
        'color': ThemeColors.primaryBlue,
        'isPopular': true,
      },
      {
        'name': 'Nagad',
        'description': 'Digital wallet payment',
        'icon': Icons.mobile_friendly,
        'color': ThemeColors.primaryCyan,
        'isPopular': false,
      },
      {
        'name': 'Rocket',
        'description': 'Mobile financial service',
        'icon': Icons.rocket_launch,
        'color': ThemeColors.primaryPurple,
        'isPopular': false,
      },
      {
        'name': 'Credit Card',
        'description': 'Visa, MasterCard, American Express',
        'icon': Icons.credit_card,
        'color': ThemeColors.successColor,
        'isPopular': false,
      },
      {
        'name': 'Bank Transfer',
        'description': 'Direct bank account transfer',
        'icon': Icons.account_balance,
        'color': ThemeColors.warningColor,
        'isPopular': false,
      },
    ];

    return Column(
      children: [
        // Popular Payment Methods
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ThemeColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ThemeColors.primaryBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: ThemeColors.primaryBlue,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Text(
                'Most Popular in Bangladesh',
                style: TextStyle(
                  color: ThemeColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Payment Methods Grid
        ...paymentMethods.map((method) => _buildPaymentMethodCard(
          method['name'] as String,
          method['description'] as String,
          method['icon'] as IconData,
          method['color'] as Color,
          method['isPopular'] as bool,
        )),
      ],
    );
  }

  Widget _buildPaymentMethodCard(String name, String description, IconData icon, Color color, bool isPopular) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPopular ? color.withOpacity(0.3) : ThemeColors.borderColor,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.w,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Method Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: ThemeColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isPopular) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: color,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: ThemeColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          
          // Status Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ThemeColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.check_circle,
              color: ThemeColors.successColor,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: ThemeColors.successColor,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Text(
                'Secure & Trusted',
                style: TextStyle(
                  color: ThemeColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Security Features
          ..._buildSecurityFeatures(),
          
          SizedBox(height: 16.h),
          
          // Trust Indicators
          _buildTrustIndicators(),
        ],
      ),
    );
  }

  List<Widget> _buildSecurityFeatures() {
    final features = [
      {
        'icon': Icons.lock,
        'title': 'SSL Encryption',
        'description': 'All transactions are protected with bank-level encryption',
      },
      {
        'icon': Icons.verified_user,
        'title': 'PCI DSS Compliant',
        'description': 'Meets international security standards for payment processing',
      },
      {
        'icon': Icons.shield,
        'title': '2-Factor Authentication',
        'description': 'Additional security layer for your account protection',
      },
      {
        'icon': Icons.history,
        'title': 'Transaction History',
        'description': 'Complete record of all your payments and subscriptions',
      },
    ];

    return features.map((feature) => _buildSecurityFeature(
      feature['icon'] as IconData,
      feature['title'] as String,
      feature['description'] as String,
    )).toList();
  }

  Widget _buildSecurityFeature(IconData icon, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ThemeColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: ThemeColors.successColor,
              size: 16.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ThemeColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: ThemeColors.textSecondary,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicators() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: ThemeColors.successColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'Trusted by 10,000+ users',
                style: TextStyle(
                  color: ThemeColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTrustBadge(Icons.verified_user, '100% Secure'),
              _buildTrustBadge(Icons.support_agent, '24/7 Support'),
              _buildTrustBadge(Icons.money_off, 'No Hidden Fees'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: ThemeColors.primaryBlue,
          size: 24.w,
        ),
        SizedBox(height: 4.h),
        Text(
          text,
          style: TextStyle(
            color: ThemeColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 