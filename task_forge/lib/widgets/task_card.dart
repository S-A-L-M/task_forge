import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/task_form_screen.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool showChildren;

  const TaskCard({
    super.key,
    required this.task,
    this.showChildren = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final children = showChildren ? provider.getChildren(task.id ?? '') : [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              task.isProject ? Icons.folder : Icons.task,
              color: task.isProject ? Colors.amber : Colors.blue,
              size: 32,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null) ...[
                  const SizedBox(height: 4),
                  Text(task.description!),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(task.dueDate),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    PriorityBadge(priority: task.priority),
                  ],
                ),
                if (task.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: task.tags.map((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 10)),
                        padding: const EdgeInsets.all(2),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskFormScreen(
                        task: task,
                        isProject: task.isProject,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, provider);
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(
                    task: task,
                    isProject: task.isProject,
                  ),
                ),
              );
            },
          ),
          if (children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    'Subtareas (${children.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ...children.map((child) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              child.isProject ? Icons.folder : Icons.subdirectory_arrow_right,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(child.title)),
                            PriorityBadge(priority: child.priority),
                          ],
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          task.isProject
              ? '¿Eliminar el proyecto "${task.title}"? Esto también eliminará sus subtareas.'
              : '¿Eliminar la tarea "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteTask(task.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Eliminado' : 'Error al eliminar'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}