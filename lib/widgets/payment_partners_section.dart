import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

class PaymentPartnersSection extends StatelessWidget {
  const PaymentPartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.security,
                color: ThemeColors.success,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Secure Payment Partners',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Section Description
          Text(
            'We partner with trusted payment providers to ensure your transactions are safe and secure.',
            style: TextStyle(
              color: ThemeColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          // Payment Partners Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeColors.borderColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // First Row - Bangladesh Payment Methods
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentPartner('bKash', 'bKash', ThemeColors.error),
                    _buildPaymentPartner('Nagad', 'Nagad', ThemeColors.warning),
                    _buildPaymentPartner('Rocket', 'Rocket', ThemeColors.secondary),
                    _buildPaymentPartner('DBBL', 'DBBL Mobile Banking', ThemeColors.primary),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Second Row - International Payment Methods
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentPartner('Visa', 'Visa', const Color(0xFF1A1F71)),
                    _buildPaymentPartner('MC', 'Mastercard', const Color(0xFFEB001B)),
                    _buildPaymentPartner('PayPal', 'PayPal', const Color(0xFF003087)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPartner(String shortName, String fullName, Color brandColor) {
    return Column(
      children: [
        // Payment Method Icon/Logo
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: brandColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: brandColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              shortName,
              style: TextStyle(
                color: brandColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Payment Method Name
        Text(
          fullName,
          style: TextStyle(
            color: ThemeColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 