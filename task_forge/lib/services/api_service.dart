import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // URL base del backend Flask
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  // ==================== GET ALL TASKS ====================
  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  // ==================== GET TASK BY ID ====================
  Future<Task> getTaskById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tarea no encontrada');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al obtener tarea: $e');
    }
  }

  // ==================== CREATE TASK ====================
  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al crear tarea: $e');
    }
  }

  // ==================== UPDATE TASK ====================
  Future<Task> updateTask(String id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tarea no encontrada');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  // ==================== DELETE TASK ====================
  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Tarea no encontrada');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  // ==================== SEARCH TASKS ====================
  Future<List<Task>> searchTasks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw Exception('Búsqueda inválida');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la búsqueda: $e');
    }
  }
}