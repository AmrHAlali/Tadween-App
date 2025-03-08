import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadween_app/features/category/domain/entities/category.dart';
import 'package:tadween_app/features/task/data/models/task_model.dart';
import 'package:tadween_app/features/task/presentation/bloc/tasks/tasks_bloc.dart';

class AddOrUpdateWidget extends StatefulWidget {
  final String addOrUpdate;
  final TaskModel? taskModel;
  final List<Category> categories;

  const AddOrUpdateWidget({
    required this.addOrUpdate,
    this.taskModel,
    super.key,
    required this.categories,
  });

  @override
  State<AddOrUpdateWidget> createState() => _AddOrUpdateWidgetState();
}

class _AddOrUpdateWidgetState extends State<AddOrUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        padding: EdgeInsets.all(10),
        child: _buildForm(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredDescription = '';
  late Category _selectedCategory =
      widget.taskModel == null
          ? widget.categories.first
          : widget.categories.firstWhere(
            (category) => category.id == widget.taskModel!.categoryId,
          );
  late TimeOfDay startTime = widget.taskModel?.startTime ?? TimeOfDay.now();
  late TimeOfDay endTime = widget.taskModel?.endTime ?? TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.taskModel == null
            ? widget.categories.first
            : widget.categories.firstWhere(
              (category) => category.id == widget.taskModel!.categoryId,
            );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildTitleTextFeild(context),

          const SizedBox(height: 10),

          _buildDropDownButton(context),
          const SizedBox(height: 20),

          _buildSelectTimeWidget(context, startTime, _selectStartTime, 'Select Start Time'),
          const SizedBox(height: 10),

          _buildSelectTimeWidget(context, endTime, _selectEndTime, 'Select End Time'),
          const SizedBox(height: 20),

          _buildNoteTextFeild(context),
          const SizedBox(height: 20),

          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        if(!(endTime.isAfter(startTime))){
          _showErrorDialog(context, 'Start time must be before end time!');
          return;
        }
        _saveForm(context);
      },
      child: Text(
        widget.addOrUpdate == 'add' ? 'Add Item' : 'Update Item',
        style: TextStyle(color: Colors.white),
      ),
    );
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

  Widget _buildNoteTextFeild(BuildContext context) {
    return TextFormField(
      initialValue: widget.taskModel?.description,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.note, color: Theme.of(context).iconTheme.color),
        hintText: "Enter your text here...",
        label: Text(
          'Note',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().length < 4) {
          return 'Enter a valid note';
        }
        return null;
      },
      onSaved: (value) {
        _enteredDescription = value!;
      },
    );
  }

  Widget _buildSelectTimeWidget(
    BuildContext context,
    TimeOfDay time,
    Future<void> Function(BuildContext) selectTime,
    String text,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => selectTime(context),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        SizedBox(width: 10),
        Text(time.format(context), style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildDropDownButton(BuildContext context) {
    return DropdownButtonFormField<Category>(
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      value: _selectedCategory,
      items:
          widget.categories.map((category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: (Category? value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
      decoration: InputDecoration(
        label: Text(
          "Select Category",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTitleTextFeild(BuildContext context) {
    return TextFormField(
      initialValue: widget.taskModel?.title,
      maxLength: 50,
      decoration: InputDecoration(
        label: Text(
          'Title',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().length < 4) {
          return 'Enter a valid title';
        }
        return null;
      },
      onSaved: (value) {
        _enteredTitle = value!;
      },
    );
  }

  void _saveForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final newTask = TaskModel.forUpdate(
        title: _enteredTitle,
        categoryId: _selectedCategory.id,
        startTime: startTime,
        endTime: endTime,
        description: _enteredDescription,
        id: widget.taskModel?.id ?? '',
        date: widget.taskModel?.date ?? DateTime.now(),
      );

      if (widget.addOrUpdate == 'add') {
        context.read<TasksBloc>().add(AddTaskEvent(taskModel: newTask));
      } else {
        context.read<TasksBloc>().add(DeleteTaskEvent(taskId: newTask.id));
        context.read<TasksBloc>().add(AddTaskEvent(taskModel: newTask));
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.addOrUpdate == 'add'
                ? 'Item added successfully!'
                : 'Item updated successfully!',
          ),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }
}
