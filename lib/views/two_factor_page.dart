import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';

class TwoFactorPage extends ConsumerStatefulWidget {
  final List<String> availableMethods;
  
  const TwoFactorPage({
    super.key,
    required this.availableMethods,
  });

  @override
  ConsumerState<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends ConsumerState<TwoFactorPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String _selectedMethod = '';

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.availableMethods.isNotEmpty 
        ? widget.availableMethods.first 
        : 'totp';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handle2FA() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authViewModelProvider.notifier).verify2FA(
            _codeController.text.trim(),
            _selectedMethod,
          );
    }
  }

  String _getMethodDisplayName(String method) {
    switch (method.toLowerCase()) {
      case 'totp':
      case 'authenticator':
        return 'Authenticator App (TOTP)';
      case 'otp':
      case 'emailotp':
      case 'email':
        return 'Email OTP';
      case 'recovery':
        return 'Recovery Code';
      default:
        return method.toUpperCase();
    }
  }

  String _getMethodDescription(String method) {
    switch (method.toLowerCase()) {
      case 'totp':
      case 'authenticator':
        return 'Enter the 6-digit code from your authenticator app';
      case 'otp':
      case 'emailotp':
      case 'email':
        return 'Enter the code sent to your email';
      case 'recovery':
        return 'Enter one of your recovery codes';
      default:
        return 'Enter your verification code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          // 2FA 성공 시 홈 화면으로 이동
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
        requires2FA: (methods) {},
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.security,
                  size: 80,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 32),
                Text(
                  'Two-Factor Authentication Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (widget.availableMethods.length > 1) ...[
                  Text(
                    'Choose authentication method:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...widget.availableMethods.map((method) => RadioListTile<String>(
                    title: Text(_getMethodDisplayName(method)),
                    value: method,
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  )),
                  const SizedBox(height: 24),
                ],
                Text(
                  _getMethodDescription(_selectedMethod),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    prefixIcon: const Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handle2FA(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your verification code';
                    }
                    if (value.trim().length < 4) {
                      return 'Code must be at least 4 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                authState.when(
                  initial: () => _buildVerifyButton(),
                  loading: () => _buildLoadingButton(),
                  authenticated: (user) => _buildVerifyButton(),
                  requires2FA: (methods) => _buildVerifyButton(),
                  error: (message) => _buildVerifyButton(),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: _handle2FA,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Verify',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Verifying...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}