// lib/screens/resources/contribute_resource_screen.dart
import 'package:flutter/material.dart';
import '../../models/resource.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ContributeResourceScreen extends StatefulWidget {
  const ContributeResourceScreen({super.key});

  @override
  State<ContributeResourceScreen> createState() =>
      _ContributeResourceScreenState();
}

class _ContributeResourceScreenState extends State<ContributeResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  ResourceType _selectedType = ResourceType.article;
  String _selectedCategory = 'Career';
  final List<String> _selectedTags = [];

  final List<String> _categories = [
    'Career', 'Self', 'Finance', 'Communication', 'Wellbeing', 'Productivity',
    'Social', 'Confidence', 'Leadership', 'Academic', 'Relationships',
  ];

  final List<String> _suggestedTags = [
    'career', 'jobs', 'confidence', 'wellbeing', 'finance',
    'networking', 'campus', 'interviews', 'startup', 'growth',
    'study', 'time-management', 'leadership', 'communication',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _urlCtrl.dispose();
    _durationCtrl.dispose();
    _authorCtrl.dispose();
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
      // Create a new resource (in production, this would be sent to an API)
      final newResource = Resource(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        type: _selectedType,
        category: _selectedCategory,
        url: _urlCtrl.text.trim().isEmpty ? null : _urlCtrl.text.trim(),
        duration: _durationCtrl.text.trim().isEmpty ? null : _durationCtrl.text.trim(),
        author: _authorCtrl.text.trim().isEmpty ? null : _authorCtrl.text.trim(),
        tags: _selectedTags,
        popularity: 0,
        isSaved: false,
      );

      // For now, just show a success message and go back
      Navigator.pop(context, newResource);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Resource contributed successfully! 🎉'),
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
        title: Text('Contribute Resource', style: AppTypography.labelLarge),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Share',
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
            // Title field
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _titleCtrl,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Enter a clear, descriptive title',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('📝', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter a title'
                        : v.trim().length < 3
                            ? 'Title must be at least 3 characters'
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
                    controller: _descriptionCtrl,
                    style: AppTypography.bodyLarge,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Describe what this resource is about and how it helps',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please add a description'
                        : null,
                  ),
                ],
              ),
            ),

            // Type and Category
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resource Type', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ResourceType.values.map((type) => _TypeChip(
                      label: typeLabel(type),
                      emoji: typeEmoji(type),
                      isActive: _selectedType == type,
                      onTap: () => setState(() => _selectedType = type),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
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

            // URL/Duration/Author
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedType == ResourceType.video ||
                      _selectedType == ResourceType.presentation) ...[
                    Text('URL Link', style: AppTypography.labelLarge),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _urlCtrl,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Paste the link to your video/presentation',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('🔗', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text('Duration (optional)', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _durationCtrl,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'e.g. 5 min read, 10 min video, 3 pages',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('⏱️', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Author (optional)', style: AppTypography.labelLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _authorCtrl,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Your name or organization',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('👤', style: TextStyle(fontSize: 20)),
                      ),
                    ),
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
                  'Share Resource 🚀',
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

  String typeLabel(ResourceType type) {
    switch (type) {
      case ResourceType.article: return 'Article';
      case ResourceType.video: return 'Video';
      case ResourceType.template: return 'Template';
      case ResourceType.framework: return 'Framework';
      case ResourceType.guide: return 'Guide';
      case ResourceType.presentation: return 'Presentation';
    }
  }

  String typeEmoji(ResourceType type) {
    switch (type) {
      case ResourceType.article: return '📄';
      case ResourceType.video: return '🎬';
      case ResourceType.template: return '📋';
      case ResourceType.framework: return '🔧';
      case ResourceType.guide: return '📖';
      case ResourceType.presentation: return '📊';
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isActive;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.emoji,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.blue : AppColors.lightGrey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(label,
                style: AppTypography.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.white : AppColors.blue,
                )),
          ],
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