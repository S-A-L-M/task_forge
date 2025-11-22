import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  List<Task> get projects => _tasks.where((t) => t.isProject).toList();
  List<Task> get simpleTasks => _tasks.where((t) => !t.isProject).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _api.getTasks();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTask(Task task) async {
    try {
      final newTask = await _api.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(String id, Task task) async {
    try {
      final updated = await _api.updateTask(id, task);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _api.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      // También eliminar hijos
      _tasks.removeWhere((t) => t.parentId == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<Task>> search(String query) async {
    try {
      return await _api.searchTasks(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  List<Task> getChildren(String parentId) {
    return _tasks.where((t) => t.parentId == parentId).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}