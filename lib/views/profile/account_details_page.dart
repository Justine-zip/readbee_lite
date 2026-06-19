import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/providers/profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final dynamic profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController titleController;
  late final TextEditingController positionController;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? sex;

  bool saving = false;

  SupabaseClient get supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(
      text: widget.profile.fullName ?? '',
    );

    emailController = TextEditingController(text: widget.profile.email ?? '');

    phoneController = TextEditingController(text: widget.profile.phone ?? '');

    addressController = TextEditingController(
      text: widget.profile.address ?? '',
    );

    titleController = TextEditingController(text: widget.profile.title ?? '');

    positionController = TextEditingController(
      text: widget.profile.position ?? '',
    );

    sex = widget.profile.sex;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    titleController.dispose();
    positionController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      setState(() => saving = true);

      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      await supabase
          .from('profiles')
          .update({
            'full_name': fullNameController.text.trim(),
            'phone': phoneController.text.trim(),
            'address': addressController.text.trim(),
            'title': titleController.text.trim(),
            'position': positionController.text.trim(),
            'sex': sex,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      if (emailController.text.trim() != user.email) {
        await supabase.auth.updateUser(
          UserAttributes(email: emailController.text.trim()),
        );
      }

      if (passwordController.text.isNotEmpty) {
        await supabase.auth.updateUser(
          UserAttributes(password: passwordController.text.trim()),
        );
      }

      ref.invalidate(profileProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated successfully')),
      );

      Navigator.pop(context, true);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Account')),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 32 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Profile Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              TextFormField(
                                controller: fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                enabled: false,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                initialValue: sex,
                                decoration: const InputDecoration(
                                  labelText: 'Sex',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'M',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'F',
                                    child: Text('Female'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    sex = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: positionController,
                                decoration: const InputDecoration(
                                  labelText: 'Position',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: addressController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: saving ? null : save,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (saving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
