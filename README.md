<div align="center">

# 🔥 Task Forge

### *Hierarchical Task & Project Management*

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Python](https://img.shields.io/badge/Python-Flask-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://flask.palletsprojects.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**A beautiful mobile app for managing tasks and projects with tree-based architecture.**

[Features](#-features) • [Installation](#-installation) • [Architecture](#-architecture) • [API](#-api-documentation) • [Screenshots](#-screenshots)

---

</div>

## Overview

**Task Forge** is a cross-platform mobile application built with **Flutter** that enables users to organize their work through hierarchical task management. Create projects, add tasks, nest subtasks infinitely, and keep everything organized with tags, priorities, and deadlines.

<div align="center">

### Built for Scalability, Designed for Simplicity

</div>

---

## Features

<table>
<tr>
<td width="50%">

### **User Interface**
- Modern, clean design with smooth animations
- Swipe actions for quick editing
- Skeleton loading states
- Empty state illustrations
- Responsive layout

</td>
<td width="50%">

### **Functionality**
- Full CRUD operations
- Tree-based task hierarchy
- Priority levels (High, Medium, Low)
- Custom tags & labels
- Due date tracking
- Real-time search

</td>
</tr>
</table>

---

## Architecture

### **Project Structure**

```
task_forge/
│
├── 📱 Frontend (Flutter)
│   ├── config/          → Configuration & theme
│   ├── models/          → Data models
│   ├── services/        → API integration
│   ├── screens/         → App screens
│   └── widgets/         → Reusable components
│
└── 🔧 Backend (Flask)
    ├── models/          → Database models
    ├── routes/          → API endpoints
    └── utils/           → Helper functions
```

<details>
<summary><b>📂 Detailed Folder Structure (Click to expand)</b></summary>

```
lib/
├── main.dart                           # App entry point
│
├── config/                             # Configuration
│   ├── theme.dart                      # App theme & styling
│   ├── constants.dart                  # Constants & API config
│   └── routes.dart                     # Navigation routes
│
├── models/                             # Data Models
│   ├── project.dart                    # Project model
│   └── task.dart                       # Task model (tree structure)
│
├── services/                           # Services
│   └── api_service.dart               # HTTP client (Dio)
│
├── screens/                            # Screens
│   ├── home_screen.dart               # Projects list
│   ├── project_form_screen.dart       # Create/Edit project
│   ├── project_detail_screen.dart     # Task tree view
│   ├── task_form_screen.dart          # Create/Edit task
│   └── search_screen.dart             # Search functionality
│
└── widgets/                            # Reusable Widgets
    ├── custom_button.dart             # Custom buttons
    ├── loading_widget.dart            # Loading states
    ├── empty_state.dart               # Empty state widgets
    ├── priority_badge.dart            # Priority indicators
    ├── project_card.dart              # Project card component
    └── task_item.dart                 # Task item (tree node)
```

</details>

---

## Installation

### **Prerequisites**

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `>= 3.0.0`
- [Dart SDK](https://dart.dev/get-dart) `>= 3.0.0`
- [Python](https://www.python.org/downloads/) `>= 3.8`
- [Git](https://git-scm.com/)

---

### **1️⃣ Clone the Repository**

```bash
git clone https://github.com/yourusername/task-forge.git
cd task-forge
```

---

### **2️⃣ Frontend Setup (Flutter)**

```bash
# Install dependencies
flutter pub get

# Verify Flutter installation
flutter doctor

# Run on emulator/device
flutter run
```

<details>
<summary><b>⚙️ Configuration Options</b></summary>

Edit `lib/config/constants.dart` to match your environment:

```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:5000/api';

// iOS Simulator
static const String baseUrl = 'http://localhost:5000/api';

// Physical Device (replace with your local IP)
static const String baseUrl = 'http://192.168.1.X:5000/api';
```

</details>

---

### **3️⃣ Backend Setup (Flask)**

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the server
python app.py
```

<details>
<summary><b>📝 Environment Variables</b></summary>

Create a `.env` file in the backend directory:

```env
FLASK_APP=app.py
FLASK_ENV=development
DATABASE_URL=sqlite:///taskforge.db
SECRET_KEY=your-secret-key-here
```

</details>

---

## Dependencies

<table>
<tr>
<td width="50%">

### **Flutter Dependencies**

```yaml
# State Management
provider: ^6.1.1

# HTTP Client
dio: ^5.4.0

# UI & Animations
google_fonts: ^6.1.0
flutter_animate: ^4.5.0
shimmer: ^3.0.0
flutter_slidable: ^3.0.1

# Icons
iconsax: ^0.0.8

# Utils
intl: ^0.19.0
uuid: ^4.3.3
```

</td>
<td width="50%">

### **Python Dependencies**

```txt
Flask==3.0.0
Flask-CORS==4.0.0
Flask-SQLAlchemy==3.1.1
python-dotenv==1.0.0
```

</td>
</tr>
</table>

---

## API Documentation

### **Base URL**

```
http://localhost:5000/api
```

---

### **Projects Endpoints**

<details>
<summary><b>GET</b> <code>/projects</code> - List all projects</summary>

**Response:**
```json
[
  {
    "id": "1",
    "title": "University Project",
    "description": "Final Flutter assignment",
    "due_date": "2025-11-22T23:59:59Z",
    "priority": "high",
    "tags": ["university", "important"],
    "notes": "Present on Saturday",
    "task_count": 5,
    "created_at": "2025-11-19T10:30:00Z"
  }
]
```

</details>

<details>
<summary><b>POST</b> <code>/projects</code> - Create project</summary>

**Request Body:**
```json
{
  "title": "University Project",
  "description": "Final Flutter assignment",
  "due_date": "2025-11-22T23:59:59Z",
  "priority": "high",
  "tags": ["university", "important"],
  "notes": "Present on Saturday"
}
```

**Response:** `201 Created`

</details>

<details>
<summary><b>PUT</b> <code>/projects/:id</code> - Update project</summary>

**Request Body:** Same as POST

**Response:** `200 OK`

</details>

<details>
<summary><b>DELETE</b> <code>/projects/:id</code> - Delete project</summary>

**Response:** `204 No Content`

</details>

---

### **Tasks Endpoints**

<details>
<summary><b>GET</b> <code>/projects/:id/tasks</code> - Get project tasks (tree structure)</summary>

**Response:**
```json
[
  {
    "id": "1",
    "project_id": "1",
    "parent_id": null,
    "title": "Main Task",
    "priority": "high",
    "children": [
      {
        "id": "2",
        "parent_id": "1",
        "title": "Subtask 1",
        "children": []
      }
    ]
  }
]
```

</details>

<details>
<summary><b>POST</b> <code>/tasks</code> - Create task</summary>

**Request Body:**
```json
{
  "project_id": "1",
  "parent_id": null,
  "title": "New Task",
  "description": "Task description",
  "due_date": "2025-11-25T12:00:00Z",
  "priority": "medium",
  "tags": ["feature", "backend"],
  "notes": "Additional notes"
}
```

</details>

<details>
<summary><b>GET</b> <code>/tasks/search?q=query</code> - Search tasks</summary>

**Query Parameters:**
- `q`: Search query string

**Response:** Array of matching tasks

</details>

---

## Design System

### **Color Palette**

```dart
Primary:   #2196F3  // Blue
Secondary: #FF9800  // Orange
Success:   #4CAF50  // Green
Warning:   #FFC107  // Yellow
Error:     #F44336  // Red
```

### **Priority Colors**

- 🔴 **High Priority:** `#F44336`
- 🟡 **Medium Priority:** `#FF9800`
- 🟢 **Low Priority:** `#4CAF50`

---

## User Guide

<details>
<summary><b>Creating a Project</b></summary>

1. Open the app
2. Tap the **+** button (FAB)
3. Fill in the form:
   - Title (required)
   - Description
   - Due date
   - Priority level
   - Tags
   - Notes
4. Tap **"Save"**

</details>

<details>
<summary><b>Adding Tasks</b></summary>

1. Tap on a project
2. Tap the **+** button
3. Fill in the task form
4. Task appears in the tree view

</details>

<details>
<summary><b>Creating Subtasks</b></summary>

1. In the task view, swipe left on a task
2. Tap **"Subtask"**
3. Fill in the form
4. Subtask appears nested under parent

</details>

<details>
<summary><b>Editing & Deleting</b></summary>

- **Edit:** Swipe left → Tap "Edit"
- **Delete:** Swipe left → Tap "Delete"

</details>

---

## Roadmap

- [ ] User authentication (JWT)
- [ ] Offline sync (SQLite)
- [ ] Push notifications
- [ ] Team collaboration
- [ ] Export to PDF
- [ ] Analytics dashboard
- [ ] Dark mode
- [ ] Task reminders
- [ ] File attachments
- [ ] Calendar integration

---

## Troubleshooting

<details>
<summary><b>Connection Error with Backend</b></summary>

**Issue:** App cannot connect to Flask backend

**Solutions:**
1. Verify Flask server is running
2. Check `constants.dart` URL configuration
3. For Android Emulator, use `10.0.2.2` instead of `localhost`
4. Ensure both devices are on the same network (physical device)

</details>

<details>
<summary><b>Build Errors</b></summary>

**Issue:** Build fails or widgets render incorrectly

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

</details>

---

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate coverage report
flutter test --coverage
```

---

## Screenshots

> *Screenshots coming soon...*

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Author

**S4IM**

- GitHub: [@S-A-L-M](https://github.com/S-A-L-M)
- Email: santiagolozman@gmail.com

---

## Acknowledgments

- Flutter team for the amazing framework
- Flutter community for excellent packages

---

## Support

Having issues? Here's how to get help:

- 📝 [Open an issue](https://github.com/yourusername/task-forge/issues)
- 💬 [Discussions](https://github.com/yourusername/task-forge/discussions)

---

<div align="center">

### Made with ❤️ and Flutter

**If you like this project, please give it a ⭐**

[⬆ Back to Top](#-task-forge)

</div>
