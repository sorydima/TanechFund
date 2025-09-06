import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _walletController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Демо данные
    _emailController.text = 'demo@rechain.com';
    _passwordController.text = 'password';
    _walletController.text = '0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Логотип и заголовок
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Логотип
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.rocket_launch,
                          size: 40,
                          color: AppTheme.primaryColor,
                        ),
                      ).animate().scale(duration: 600.ms).then().shake(duration: 400.ms),
                      
                      const SizedBox(height: 24),
                      
                      // Название
                      Text(
                        'REChain®️ VC Lab',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Войдите в экосистему блокчейн-разработки',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ),
              
              // Форма входа
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      
                      // Табы для разных способов входа
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: const [
                            Tab(text: 'Email'),
                            Tab(text: 'Социальные'),
                            Tab(text: 'Кошелек'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Содержимое табов
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildEmailTab(),
                            _buildSocialTab(),
                            _buildWalletTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Таб входа по email
  Widget _buildEmailTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email поле
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Введите ваш email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите email';
                }
                if (!value.contains('@')) {
                  return 'Введите корректный email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Пароль поле
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Пароль',
                hintText: 'Введите ваш пароль',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пароль';
                }
                if (value.length < 6) {
                  return 'Пароль должен содержать минимум 6 символов';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Запомнить меня и забыли пароль
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Запомнить меня'),
                const Spacer(),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: const Text('Забыли пароль?'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Кнопка входа
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Демо данные
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Демо: demo@rechain.com / password',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Таб входа через социальные сети
  Widget _buildSocialTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Войдите через социальные сети',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Google
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                height: 24,
              ),
              label: const Text('Войти через Google'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // GitHub
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _signInWithGitHub,
              icon: const Icon(Icons.code, color: Colors.black),
              label: const Text('Войти через GitHub'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Или
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'или',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Переключение на email
          TextButton(
            onPressed: () {
              _tabController.animateTo(0);
            },
            child: const Text('Войти по email'),
          ),
        ],
      ),
    );
  }

  // Таб входа через кошелек
  Widget _buildWalletTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Подключите ваш Web3 кошелек',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Поддерживаемые кошельки: MetaMask, WalletConnect, Coinbase Wallet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Поле адреса кошелька
          TextFormField(
            controller: _walletController,
            decoration: InputDecoration(
              labelText: 'Адрес кошелька',
              hintText: '0x...',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите адрес кошелька';
              }
              if (!value.startsWith('0x') || value.length < 42) {
                return 'Введите корректный адрес кошелька';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Кнопка подключения
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _connectWallet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Подключить кошелек',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Демо данные
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.purple[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Демо: 0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6',
                    style: TextStyle(
                      color: Colors.purple[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Методы входа
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (mounted) {
        _showErrorSnackBar(authProvider.error ?? 'Ошибка входа');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Произошла ошибка: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithGoogle();
      
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (mounted) {
        _showErrorSnackBar(authProvider.error ?? 'Ошибка входа через Google');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Произошла ошибка: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGitHub() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithGitHub();
      
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (mounted) {
        _showErrorSnackBar(authProvider.error ?? 'Ошибка входа через GitHub');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Произошла ошибка: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _connectWallet() async {
    if (_walletController.text.isEmpty) {
      _showErrorSnackBar('Введите адрес кошелька');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.connectWallet(_walletController.text.trim());
      
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (mounted) {
        _showErrorSnackBar(authProvider.error ?? 'Ошибка подключения кошелька');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Произошла ошибка: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Диалог забыли пароль
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сброс пароля'),
        content: const Text(
          'Введите ваш email для сброса пароля. Мы отправим инструкции на указанный адрес.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetPassword();
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  // Сброс пароля
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Введите email для сброса пароля');
      return;
    }
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resetPassword(_emailController.text.trim());
      
      if (success && mounted) {
        _showSuccessSnackBar('Инструкции по сбросу пароля отправлены на ваш email');
      } else if (mounted) {
        _showErrorSnackBar(authProvider.error ?? 'Ошибка сброса пароля');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Произошла ошибка: $e');
      }
    }
  }

  // Уведомления
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
