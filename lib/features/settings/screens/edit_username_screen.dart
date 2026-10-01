import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/fullscreen_image_viewer.dart';
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
  bool _isUploadingPhoto = false;

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

  Future<void> _pickAndUploadPhoto() async {
    final user = ref.read(currentUserDocProvider).value;
    if (user == null) return;

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 90,
    );

    if (pickedFile == null) return;

    setState(() => _isUploadingPhoto = true);

    try {
      final cloudinaryService = ref.read(cloudinaryServiceProvider);
      final downloadUrl = await cloudinaryService.uploadProfilePicture(
        uid: user.uid,
        imageFile: pickedFile,
      );

      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.updateProfilePhoto(user.uid, downloadUrl);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
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
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final img = userDoc?.profileImageProvider ??
                                const AssetImage('assets/images/person.png');
                            FullscreenImageViewer.show(
                              context,
                              img,
                              heroTag: 'profile_avatar_edit',
                            );
                          },
                          child: Hero(
                            tag: 'profile_avatar_edit',
                            child: CircleAvatar(
                              radius: 56,
                              backgroundImage: userDoc?.profileImageProvider ??
                                  const AssetImage('assets/images/person.png'),
                            ),
                          ),
                        ),
                        if (_isUploadingPhoto)
                          Container(
                            width: 112,
                            height: 112,
                            decoration: const BoxDecoration(
                              color: Color(0x80000000),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAndUploadPhoto,
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
