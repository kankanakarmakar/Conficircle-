// lib/screens/circle/create_group_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool _isPublic = true;
  String _selectedCategory = 'Career';
  final List<String> _categories = [
    'Career', 'Self', 'Finance', 'Communication', 'Wellbeing', 'Leadership',
    'Entrepreneurship', 'Academic', 'Relationships',
  ];
  final List<String> _selectedTags = [];
  final _tagCtrl = TextEditingController();

  static const List<String> _suggestedTags = [
    'career', 'jobs', 'confidence', 'wellbeing', 'finance',
    'networking', 'campus', 'interviews', 'startup', 'growth',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final t = tag.trim().toLowerCase().replaceAll('#', '');
    if (t.isNotEmpty && !_selectedTags.contains(t) && _selectedTags.length < 5) {
      setState(() {
        _selectedTags.add(t);
        _tagCtrl.clear();
      });
    }
  }

  void _removeTag(String tag) => setState(() => _selectedTags.remove(tag));

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // In production: create group via API
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Circle "${_nameCtrl.text}" created! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create a Circle', style: AppTypography.labelLarge),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Create',
              style: AppTypography.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Circle Name', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameCtrl,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'e.g. Campus Entrepreneurs',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('✨', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter a circle name'
                        : v.trim().length < 3
                            ? 'Name must be at least 3 characters'
                            : null,
                  ),
                ],
              ),
            ),

            // Description
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descCtrl,
                    style: AppTypography.bodyLarge,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'What is this circle about? Who is it for?',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please add a description'
                        : null,
                  ),
                ],
              ),
            ),

            // Type toggle
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Circle Type', style: AppTypography.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    _isPublic
                        ? 'Anyone can find and join this circle'
                        : 'Only invited members can join',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _TypeToggle(
                        emoji: '🌐',
                        label: 'Public',
                        sublabel: 'Open to all',
                        isActive: _isPublic,
                        onTap: () => setState(() => _isPublic = true),
                      ),
                      const SizedBox(width: 12),
                      _TypeToggle(
                        emoji: '🔒',
                        label: 'Private',
                        sublabel: 'Invite only',
                        isActive: !_isPublic,
                        onTap: () => setState(() => _isPublic = false),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    style: AppTypography.bodyLarge,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                    decoration: const InputDecoration(),
                  ),
                ],
              ),
            ),

            // Tags
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Tags', style: AppTypography.labelLarge),
                      const Spacer(),
                      Text('${_selectedTags.length}/5',
                          style: AppTypography.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_selectedTags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedTags
                          .map((t) => InputChip(
                                label: Text('#$t'),
                                onDeleted: () => _removeTag(t),
                                backgroundColor: AppColors.blue.withOpacity(0.1),
                                labelStyle: AppTypography.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blue,
                                ),
                                deleteIconColor: AppColors.blue,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagCtrl,
                          style: AppTypography.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: 'Add a tag...',
                            prefixText: '# ',
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.blue),
                        onPressed: () => _addTag(_tagCtrl.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Suggestions:', style: AppTypography.bodySmall),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _suggestedTags
                        .where((t) => !_selectedTags.contains(t))
                        .take(6)
                        .map((t) => GestureDetector(
                              onTap: () => _addTag(t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.softGrey,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppColors.lightGrey),
                                ),
                                child: Text(
                                  '#$t',
                                  style: AppTypography.bodySmall
                                      .copyWith(color: AppColors.blue),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // Submit
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  'Create Circle 🚀',
                  style: AppTypography.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String emoji, label, sublabel;
  final bool isActive;
  final VoidCallback onTap;

  const _TypeToggle({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.softGrey,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? AppColors.blue : AppColors.lightGrey,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.white : AppColors.blue,
                ),
              ),
              Text(
                sublabel,
                style: AppTypography.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color:
                      isActive ? Colors.white70 : AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
