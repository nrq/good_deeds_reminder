import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  final AuthService _auth = AuthService();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.signInWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
      // Firebase auth stream will switch to HomeScreen automatically
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Sign-in failed');
    } catch (e) {
      _showError('Sign-in failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _auth.registerWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
      // After registration, auth state changes to logged in
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Registration failed');
    } catch (e) {
      _showError('Registration failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      await _auth.signInWithGoogle();
    } catch (e) {
      _showError('Google sign-in failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = 16.0;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome back',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to keep track of good deeds and reminders',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter email';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter password';
                          if (v.length < 6) return 'Password min 6 chars';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _loading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _signIn,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Sign in'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _register,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Create account'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _signInWithGoogle,
                                    icon: Image.asset(
                                      'assets/google_logo.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    label: const Text('Sign in with Google'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black87,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          // Simple guest sign-in
                          try {
                            await FirebaseAuth.instance.signInAnonymously();
                          } catch (e) {
                            _showError('Anonymous sign-in failed');
                          }
                        },
                        child: const Text('Continue as guest'),
                      ),
                      const SizedBox(height: 12),
                      // Footer with site and version
                      Column(
                        children: const [
                          SizedBox(height: 8),
                          Text('NurulQuran.com', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('v1.03', style: TextStyle(color: Colors.black38, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}