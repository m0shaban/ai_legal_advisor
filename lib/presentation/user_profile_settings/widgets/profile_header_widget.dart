import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 16),
              Expanded(
                child: _buildUserInfo(),
              ),
              _buildEditButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: userData['avatar'] != null
            ? CustomImageWidget(
                imageUrl: userData['avatar'],
                width: 76,
                height: 76,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 40,
                ),
              ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userData['name'] ?? 'المستخدم',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Text(
          userData['email'] ?? 'user@example.com',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: userData['isPro'] == true
                ? AppTheme.getAccentColor(true).withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            userData['isPro'] == true ? 'عضو مميز' : 'عضو مجاني',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: userData['isPro'] == true
                  ? AppTheme.getAccentColor(true)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      onPressed: onEditPressed,
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'edit',
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
