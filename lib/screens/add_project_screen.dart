import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../theme/app_spacing.dart';

class AddProjectScreen extends StatefulWidget {
  final Project? project;
  
  const AddProjectScreen({super.key, this.project});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _platformController = TextEditingController();
  final _githubController = TextEditingController();
  final _highlightsController = TextEditingController();
  
  String? _selectedStatus;
  bool _isFormValid = false;

  final List<String> _statusOptions = ['Completed', 'In Progress'];

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _populateFields();
    }
    _addListeners();
  }

  void _populateFields() {
    final project = widget.project!;
    _titleController.text = project.title;
    _categoryController.text = project.category;
    _descriptionController.text = project.description;
    _techStackController.text = project.techStack;
    _platformController.text = project.platform;
    _githubController.text = project.githubLink;
    _highlightsController.text = project.highlights;
    _selectedStatus = project.status;
    _validateForm();
  }

  void _addListeners() {
    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty &&
          _descriptionController.text.length >= 10 &&
          _selectedStatus != null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _platformController.dispose();
    _githubController.dispose();
    _highlightsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final projectProvider = context.read<ProjectProvider>();
      
      final project = Project(
        id: widget.project?.id ?? projectProvider.projectCount + 1,
        title: _titleController.text,
        category: _categoryController.text.isEmpty ? 'General' : _categoryController.text,
        description: _descriptionController.text,
        techStack: _techStackController.text.isEmpty ? 'Not specified' : _techStackController.text,
        platform: _platformController.text.isEmpty ? 'Not specified' : _platformController.text,
        status: _selectedStatus!,
        githubLink: _githubController.text.isEmpty ? '#' : _githubController.text,
        highlights: _highlightsController.text.isEmpty ? 'No highlights' : _highlightsController.text,
      );

      if (widget.project != null) {
        await projectProvider.updateProject(project);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.title}" updated successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        await projectProvider.addProject(project);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.title}" added successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      widget.project != null ? 'Edit Project' : 'Add New Project',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: _titleController,
                          label: 'Project Title',
                          hint: 'Enter project title',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title cannot be empty';
                            }
                            return null;
                          },
                          required: true,
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _categoryController,
                          label: 'Category',
                          hint: 'e.g., Web Development, Mobile App',
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Describe your project (minimum 10 characters)',
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description cannot be empty';
                            }
                            if (value.length < 10) {
                              return 'Description must be at least 10 characters';
                            }
                            return null;
                          },
                          required: true,
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _techStackController,
                          label: 'Tech Stack',
                          hint: 'e.g., Flutter, Dart, Firebase',
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _platformController,
                          label: 'Platform',
                          hint: 'e.g., Mobile, Web, Desktop',
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildDropdownField(),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _githubController,
                          label: 'GitHub Link',
                          hint: 'https://github.com/username/project',
                        ),
                        
                        SizedBox(height: AppSpacing.md),
                        
                        _buildTextFormField(
                          controller: _highlightsController,
                          label: 'Key Highlights',
                          hint: 'Key features or achievements',
                          maxLines: 2,
                        ),
                        
                        SizedBox(height: AppSpacing.xl),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isFormValid ? _submitForm : null,
                            child: Text(
                              widget.project != null ? 'Update Project' : 'Add Project',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool required = false,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: GoogleFonts.poppins(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Status',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              ' *',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          validator: (value) {
            if (value == null) {
              return 'Please select a status';
            }
            return null;
          },
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
            _validateForm();
          },
          style: GoogleFonts.poppins(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
          ),
          dropdownColor: theme.colorScheme.surface,
          decoration: InputDecoration(
            hintText: 'Select project status',
            hintStyle: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
