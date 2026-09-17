// lib/screens/onboarding/step1_profile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class Step1Profile extends StatefulWidget {
  final VoidCallback onNext;
  const Step1Profile({super.key, required this.onNext});

  @override
  State<Step1Profile> createState() => _Step1ProfileState();
}

class _Step1ProfileState extends State<Step1Profile> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _collegeCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  String? _selectedYear;

  final List<String> _years = [
    'First Year', 'Second Year', 'Third Year',
    'Fourth Year', 'Fifth Year', 'Postgraduate', 'Research',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _collegeCtrl.dispose();
    _courseCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<UserProvider>().updateProfile(
        name: _nameCtrl.text.trim(),
        college: _collegeCtrl.text.trim(),
        course: _courseCtrl.text.trim(),
        yearOfStudy: _selectedYear,
      );
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Tell us a bit\nabout yourself', style: AppTypography.headingLarge),
            const SizedBox(height: 6),
            Text('This helps us personalize your experience.', style: AppTypography.bodyMedium),
            const SizedBox(height: 32),

            _buildLabel('Your Name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Anaya',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.blue),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 20),

            _buildLabel('College / University'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _collegeCtrl,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Delhi University',
                prefixIcon: Icon(Icons.school_outlined, color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Course / Program'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _courseCtrl,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. B.Com, B.Tech, Psychology...',
                prefixIcon: Icon(Icons.book_outlined, color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Year of Study'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.softGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              style: AppTypography.bodyLarge,
              hint: Text('Select year', style: AppTypography.bodyMedium.copyWith(color: Colors.grey.shade400)),
              items: _years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
              onChanged: (v) => setState(() => _selectedYear = v),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTypography.labelLarge);
  }
}
