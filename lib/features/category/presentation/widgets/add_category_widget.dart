import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/core/data/icons.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/category/presentation/bloc/categories/categories_bloc.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({super.key});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  late String _selectedIcon = categoryIconsMap.keys.first;

  @override
  Widget build(BuildContext context) {
    return _buildCategoryBloc();
  }

  Widget _buildCategoryBloc() {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is ErrorCategoriesState) {
          return Center(child: Text('There is somethind wrong!'));
        }
        if (state is LoadedCategoriesState) {
          return Container(
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: EdgeInsets.all(10),
            child: _buildAddCategoryForm(categories: state.categories),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAddCategoryForm({required List<Category> categories}) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(height: 20),

                  _buildNameTextField(context),
                  const SizedBox(height: 10),

                  _buildDropDownButton(context),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 20),

              _buildSubmitButton(context, categories),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, List<Category> categories) {
    return ElevatedButton(
      onPressed: () => _saveForm(context, categories: categories),
      child: Text('Save', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildDropDownButton(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        value: _selectedIcon,
        items:
            categoryIconsMap.entries.map((icon) {
              return DropdownMenuItem<String>(
                value: icon.key,
                child: Icon(
                  icon.value,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              );
            }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              _selectedIcon = value;
            });
          }
        },
        decoration: InputDecoration(
          label: Text(
            "Select Icon",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildNameTextField(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(
            'Category Name',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().length < 3) {
            return 'Enter a valid name';
          }
          return null;
        },
        onSaved: (value) {
          _enteredName = value!;
        },
      ),
    );
  }

  void _saveForm(BuildContext context, {required List<Category> categories}) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final Category category = Category(
        name: _enteredName,
        icon: categoryIconsMap[_selectedIcon]!,
        id: '',
      );

      if (categories.any((element) => element.name == category.name)) {
        _showErrorDialog(context, 'Category name already exists!');
        return;
      } else if (categories.any((element) => element.icon == category.icon)) {
        _showErrorDialog(context, 'Category icon already exists!');
        return;
      }

      context.read<CategoriesBloc>().add(AddCategoryEvent(category: category));
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category added successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 5),
                const Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
    );
  }
}