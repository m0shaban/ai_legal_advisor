import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/payment_method_card.dart';
import './widgets/order_summary_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  late SubscriptionPlan _selectedPlan;
  String? _selectedPaymentMethod;
  bool _isProcessing = false;

  // Payment form controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Available payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'credit_card',
      'name': 'بطاقة ائتمان',
      'icon': Icons.credit_card,
      'description': 'Visa, Mastercard, American Express',
    },
    {
      'id': 'debit_card',
      'name': 'بطاقة خصم',
      'icon': Icons.payment,
      'description': 'البطاقات البنكية المحلية',
    },
    {
      'id': 'vodafone_cash',
      'name': 'فودافون كاش',
      'icon': Icons.phone_android,
      'description': 'الدفع عبر محفظة فودافون',
    },
    {
      'id': 'fawry',
      'name': 'فوري',
      'icon': Icons.store,
      'description': 'الدفع من خلال نقاط فوري',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _selectedPaymentMethod = _paymentMethods.first['id'];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _selectedPlan = arguments['plan'] as SubscriptionPlan;
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_validatePaymentForm()) return;

    setState(() => _isProcessing = true);

    try {
      // Create payment method object
      final paymentMethod = PaymentMethod(
        type: _selectedPaymentMethod!,
        name: _paymentMethods.firstWhere((m) => m['id'] == _selectedPaymentMethod)['name'],
        cardNumber: _selectedPaymentMethod == 'credit_card' || _selectedPaymentMethod == 'debit_card'
            ? _cardNumberController.text.replaceAll(' ', '').substring(_cardNumberController.text.length - 4)
            : null,
        expiryDate: _selectedPaymentMethod == 'credit_card' || _selectedPaymentMethod == 'debit_card'
            ? _expiryController.text
            : null,
        holderName: _selectedPaymentMethod == 'credit_card' || _selectedPaymentMethod == 'debit_card'
            ? _cardHolderController.text
            : null,
      );

      // Process subscription
      final result = await _subscriptionService.subscribe(_selectedPlan.id, paymentMethod);

      if (mounted) {
        if (result.success) {
          // Show success dialog
          _showSuccessDialog();
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء معالجة الدفع: ${e.toString()}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  bool _validatePaymentForm() {
    if (_selectedPaymentMethod == 'credit_card' || _selectedPaymentMethod == 'debit_card') {
      if (_cardNumberController.text.replaceAll(' ', '').length < 16) {
        _showErrorMessage('رقم البطاقة غير صحيح');
        return false;
      }
      if (_expiryController.text.length < 5) {
        _showErrorMessage('تاريخ انتهاء البطاقة غير صحيح');
        return false;
      }
      if (_cvvController.text.length < 3) {
        _showErrorMessage('رمز الأمان غير صحيح');
        return false;
      }
      if (_cardHolderController.text.isEmpty) {
        _showErrorMessage('اسم حامل البطاقة مطلوب');
        return false;
      }
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppTheme.getSuccessColor(true),
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'تم تفعيل الاشتراك بنجاح!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'مرحباً بك في النسخة المميزة من المستشار القانوني الذكي',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close payment screen
              Navigator.of(context).pop(); // Close subscription screen
              Navigator.pushReplacementNamed(context, AppRoutes.chatHomeScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getAccentColor(true),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ابدأ الاستخدام',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'إتمام الدفع',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Order Summary
              OrderSummaryCard(plan: _selectedPlan),

              SizedBox(height: 3.h),

              // Payment Methods
              _buildPaymentMethodsSection(),

              SizedBox(height: 3.h),

              // Payment Form
              _buildPaymentForm(),

              SizedBox(height: 4.h),

              // Process Payment Button
              _buildProcessPaymentButton(),

              SizedBox(height: 2.h),

              // Security Info
              _buildSecurityInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'طريقة الدفع',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 3.w),            ..._paymentMethods.map((method) {
              return PaymentMethodCard(
                id: method['id'],
                name: method['name'],
                icon: method['icon'],
                description: method['description'],
                isSelected: _selectedPaymentMethod == method['id'],
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = method['id'];
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    if (_selectedPaymentMethod == 'credit_card' || _selectedPaymentMethod == 'debit_card') {
      return _buildCardForm();
    } else if (_selectedPaymentMethod == 'vodafone_cash') {
      return _buildVodafoneCashForm();
    } else if (_selectedPaymentMethod == 'fawry') {
      return _buildFawryForm();
    }
    return SizedBox.shrink();
  }

  Widget _buildCardForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بيانات البطاقة',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 3.w),

            // Card Number
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: 'رقم البطاقة',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(
                  Icons.credit_card,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberInputFormatter(),
              ],
            ),

            SizedBox(height: 3.w),

            Row(
              children: [
                // Expiry Date
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'تاريخ الانتهاء',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryDateInputFormatter(),
                    ],
                  ),
                ),

                SizedBox(width: 3.w),

                // CVV
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'رمز الأمان',
                      hintText: '123',
                      prefixIcon: Icon(
                        Icons.security,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.w),

            // Card Holder Name
            TextFormField(
              controller: _cardHolderController,
              textCapitalization: TextCapitalization.words,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: 'اسم حامل البطاقة',
                hintText: 'AHMED MOHAMED ALI',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVodafoneCashForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Icon(
              Icons.phone_android,
              color: AppTheme.lightTheme.primaryColor,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'سيتم تحويلك إلى تطبيق فودافون كاش لإتمام الدفع',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFawryForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Icon(
              Icons.store,
              color: AppTheme.lightTheme.primaryColor,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'سيتم إنشاء رمز دفع فوري يمكنك استخدامه في أي نقطة فوري',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessPaymentButton() {
    return ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: AppTheme.getAccentColor(true),
        foregroundColor: Colors.black,
      ),
      child: _isProcessing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'جاري المعالجة...',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              'إتمام الدفع - ${_selectedPlan.price.toStringAsFixed(2)} ${_selectedPlan.currency}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: AppTheme.getSuccessColor(true),
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'جميع المعاملات محمية بتشفير SSL وآمنة 100%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getSuccessColor(true),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Input formatters
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
