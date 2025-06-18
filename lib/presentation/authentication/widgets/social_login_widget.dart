import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "أو"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'أو',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _buildSocialButton(
                onPressed: () {
                  // Handle Google login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تسجيل الدخول بـ Google قريباً'),
                    ),
                  );
                },
                icon: Icons.g_mobiledata,
                label: 'Google',
                color: const Color(0xFFDB4437),
              ),
            ),

            SizedBox(width: 3.w),

            // Facebook Login
            Expanded(
              child: _buildSocialButton(
                onPressed: () {
                  // Handle Facebook login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تسجيل الدخول بـ Facebook قريباً'),
                    ),
                  );
                },
                icon: Icons.facebook,
                label: 'Facebook',
                color: const Color(0xFF3B5998),
              ),
            ),

            SizedBox(width: 3.w),

            // Apple Login
            Expanded(
              child: _buildSocialButton(
                onPressed: () {
                  // Handle Apple login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تسجيل الدخول بـ Apple قريباً'),
                    ),
                  );
                },
                icon: Icons.apple,
                label: 'Apple',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 3.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
