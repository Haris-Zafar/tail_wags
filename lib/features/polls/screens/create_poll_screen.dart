import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_button.dart';
import '../models/poll_model.dart';
import '../providers/polls_provider.dart';

class CreatePollScreen extends ConsumerStatefulWidget {
  const CreatePollScreen({super.key});

  @override
  ConsumerState<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends ConsumerState<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePoll() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserDocProvider).value;
      final pollService = ref.read(pollServiceProvider);

      final newPoll = PollModel(
        id: '',
        question: _questionController.text.trim(),
        optionA: _option1Controller.text.trim(),
        optionB: _option2Controller.text.trim(),
        imageAsset: 'assets/images/event.png',
        createdBy: user?.uid ?? '',
      );

      await pollService.createPoll(newPoll);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poll created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create poll. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  AppTextField(
                    label: 'Question',
                    controller: _questionController,
                    hint: 'Made in Melanin! Black History Month Social',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Question is required' : null,
                  ),

                  const SizedBox(height: 16),

                  // Options Heading
                  Text('Options', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _option1Controller,
                    style: AppTextStyles.body.copyWith(color: textPrimary),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Option 1 is required' : null,
                    decoration: InputDecoration(
                      hintText: 'Option 1',
                      hintStyle: AppTextStyles.body.copyWith(color: textSecondary),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _option2Controller,
                    style: AppTextStyles.body.copyWith(color: textPrimary),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Option 2 is required' : null,
                    decoration: InputDecoration(
                      hintText: 'Option 2',
                      hintStyle: AppTextStyles.body.copyWith(color: textSecondary),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Image
                  Text('Upload Image', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: textPrimary)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selected bundled asset image (assets/images/event.png)')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_outlined, size: 32, color: AppColors.textSecondary),
                          const SizedBox(height: 8),
                          Text('Upload', style: AppTextStyles.body.copyWith(color: textSecondary)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Vote Button
                  LoadingButton(
                    label: 'Vote',
                    isLoading: _isLoading,
                    onPressed: _handleCreatePoll,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
