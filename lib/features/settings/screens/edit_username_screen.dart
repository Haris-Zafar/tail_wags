import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_button.dart';

class EditUsernameScreen extends ConsumerStatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  ConsumerState<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends ConsumerState<EditUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userDoc = ref.read(currentUserDocProvider).value;
    final initialName = (userDoc?.username.isNotEmpty ?? false)
        ? userDoc!.username
        : 'Mack_tor';
    _usernameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserDocProvider).value;
      if (user != null) {
        final firestoreService = ref.read(firestoreServiceProvider);
        await firestoreService.updateUsername(user.uid, _usernameController.text.trim());
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update username. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDoc = ref.watch(currentUserDocProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Detail'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Avatar with Camera Overlay Icon
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundImage: AssetImage(
                            userDoc?.photoAsset ?? 'assets/images/person.png',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Username Field
                  AppTextField(
                    label: 'Username',
                    controller: _usernameController,
                    hint: 'Mack_tor',
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Username cannot be empty' : null,
                  ),

                  const SizedBox(height: 36),

                  // Save Changes Button
                  LoadingButton(
                    label: 'Save Changes',
                    isLoading: _isLoading,
                    onPressed: _handleSaveChanges,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
