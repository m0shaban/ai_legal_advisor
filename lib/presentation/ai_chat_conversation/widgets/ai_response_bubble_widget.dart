import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AiResponseBubbleWidget extends StatefulWidget {
  final String content;
  final String quickSummary;
  final String detailedExplanation;
  final String legalBasis;
  final DateTime timestamp;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const AiResponseBubbleWidget({
    super.key,
    required this.content,
    required this.quickSummary,
    required this.detailedExplanation,
    required this.legalBasis,
    required this.timestamp,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  _AiResponseBubbleWidgetState createState() => _AiResponseBubbleWidgetState();
}

class _AiResponseBubbleWidgetState extends State<AiResponseBubbleWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Response bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.getShadowColor(true),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.getBorderColor(true).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with favorite button
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: AppTheme.getAccentColor(true),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'المساعد القانوني الذكي',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onFavoriteToggle,
                          icon: CustomIconWidget(
                            iconName: widget.isFavorite
                                ? 'favorite'
                                : 'favorite_border',
                            color: widget.isFavorite
                                ? Colors.red
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                            size: 20,
                          ),
                          constraints:
                              BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),

                  // Quick Summary (Always visible)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'lightbulb',
                              color: AppTheme.getAccentColor(true),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'الملخص السريع',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.quickSummary,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand/Collapse button
                  InkWell(
                    onTap: _toggleExpansion,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.03),
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.getBorderColor(true)
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: Duration(milliseconds: 300),
                            child: CustomIconWidget(
                              iconName: 'keyboard_arrow_down',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expandable content
                  AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: _expandAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Detailed Explanation
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'article',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'الشرح التفصيلي',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Parse and display detailed explanation with bullet points
                          ...widget.detailedExplanation
                              .split('\n')
                              .where((line) => line.trim().isNotEmpty)
                              .map((line) {
                            if (line.trim().startsWith('•')) {
                              return _buildBulletPoint(
                                  line.trim().substring(1).trim());
                            } else if (line.trim().startsWith('**') &&
                                line.trim().endsWith('**')) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  line.trim().replaceAll('**', ''),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  line.trim(),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    height: 1.4,
                                  ),
                                ),
                              );
                            }
                          }),

                          SizedBox(height: 16),

                          // Legal Basis
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'gavel',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'الأساس القانوني',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.lightTheme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.legalBasis,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    height: 1.4,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer with timestamp
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(widget.timestamp),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.getAccentColor(true)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'AI',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.getAccentColor(true),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AI avatar
          Container(
            width: 32,
            height: 32,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: AppTheme.getAccentColor(true),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'psychology',
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
