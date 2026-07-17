import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oran_ride/services/firebase_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleModelController = TextEditingController();

  bool _isLogin = true;
  String _role = 'rider';
  String _vehicleType = 'car';
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    final authService = Provider.of<FirebaseService>(context, listen: false);

    try {
      if (_isLogin) {
        await authService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await authService.registerUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          role: _role,
          vehicleType: _role == 'driver' ? _vehicleType : '',
          vehicleModel: _role == 'driver' ? _vehicleModelController.text.trim() : '',
        );
      }
      
      if (mounted) {
        final currentRole = authService.currentUser?.role ?? _role;
        if (currentRole == 'driver') {
          Navigator.pushReplacementNamed(context, '/driver_home');
        } else {
          Navigator.pushReplacementNamed(context, '/rider_home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012C22), // Algerian Green Deep theme
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/car.png',
                      height: 60,
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isLogin ? 'Oran Ride Login' : 'Create Oran Ride Account',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF012C22)),
                    ),
                    const SizedBox(height: 20),
                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                        validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number (Algeria)', prefixIcon: Icon(Icons.phone), hintText: '+213 6XX XX XX XX'),
                        validator: (v) => v!.isEmpty ? 'Please enter phone' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _role,
                        decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.people)),
                        items: const [
                          DropdownMenuItem(value: 'rider', child: Text('Rider (Passenger)')),
                          DropdownMenuItem(value: 'driver', child: Text('Captain (Driver)')),
                        ],
                        onChanged: (val) => setState(() => _role = val!),
                      ),
                      const SizedBox(height: 12),
                      if (_role == 'driver') ...[
                        DropdownButtonFormField<String>(
                          value: _vehicleType,
                          decoration: const InputDecoration(labelText: 'Vehicle Category', prefixIcon: Icon(Icons.directions_car)),
                          items: const [
                            DropdownMenuItem(value: 'car', child: Text('Regular Car')),
                            DropdownMenuItem(value: 'motorcycle', child: Text('Motorcycle (Vite)')),
                            DropdownMenuItem(value: 'premium', child: Text('Premium Luxury')),
                          ],
                          onChanged: (val) => setState(() => _vehicleType = val!),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _vehicleModelController,
                          decoration: const InputDecoration(labelText: 'Vehicle Model & Plate', prefixIcon: Icon(Icons.badge), hintText: 'Dacia Logan / 31-XXX-XXX'),
                          validator: (v) => v!.isEmpty ? 'Required for Captains' : null,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@') ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                      obscureText: true,
                      validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _submit,
                            child: Text(_isLogin ? 'Login' : 'Sign Up'),
                          ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? "New user? Create an account" : "Have an account? Log in"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
