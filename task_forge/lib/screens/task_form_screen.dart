import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final bool isProject;

  const TaskFormScreen({
    super.key,
    this.task,
    required this.isProject,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;
  late DateTime _selectedDate;
  String _selectedPriority = 'medium';
  String? _selectedParentId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _notesController = TextEditingController(text: widget.task?.notes ?? '');
    _tagsController = TextEditingController(
      text: widget.task?.tags.join(', ') ?? '',
    );
    _selectedDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    _selectedPriority = widget.task?.priority ?? 'medium';
    _selectedParentId = widget.task?.parentId;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Editar ${widget.isProject ? "Proyecto" : "Tarea"}'
              : 'Crear ${widget.isProject ? "Proyecto" : "Tarea"}',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El título es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha de vencimiento'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              leading: const Icon(Icons.calendar_today),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Baja')),
                DropdownMenuItem(value: 'medium', child: Text('Media')),
                DropdownMenuItem(value: 'high', child: Text('Alta')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Etiquetas (separadas por coma)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
                hintText: 'trabajo, urgente, personal',
              ),
            ),
            const SizedBox(height: 16),
            if (!widget.isProject) _buildParentSelector(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas adicionales',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: Text(isEditing ? 'Actualizar' : 'Crear'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentSelector() {
    final provider = context.watch<TaskProvider>();
    final projects = provider.projects;

    return DropdownButtonFormField<String?>(
      initialValue: _selectedParentId,
      decoration: const InputDecoration(
        labelText: 'Proyecto padre (opcional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.folder),
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Sin proyecto padre'),
        ),
        ...projects.map((project) {
          return DropdownMenuItem<String?>(
            value: project.id,
            child: Text(project.title),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _selectedParentId = value;
        });
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TaskProvider>();
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final task = Task(
      id: widget.task?.id,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      dueDate: _selectedDate,
      priority: _selectedPriority,
      tags: tags,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      parentId: _selectedParentId,
      isProject: widget.isProject,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    bool success;
    if (widget.task != null) {
      success = await provider.updateTask(widget.task!.id!, task);
    } else {
      success = await provider.createTask(task);
    }

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.task != null ? 'Actualizado' : 'Creado con éxito'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Error al guardar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}