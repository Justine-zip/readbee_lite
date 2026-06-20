# ReadBee Lite

ReadBee Lite is a Flutter-based reading assessment application designed to help teachers evaluate students' reading performance through digital reading materials, miscue analysis, comprehension assessment, and automated score calculation.

The app aims to eliminate common reading struggles, helping students gain confidence and fluency across multiple languages. With curated reading materials, quizzes, and guided exercises, readbee_lite supports educators in monitoring performance while fostering independent learning.

## Features

### Student Management

* Manage student records
* Organize students by section
* Track reading assessment history

### Reading Assessment

* Digital reading material selection
* Real-time reading evaluation
* Miscue recording and tracking
* Automatic reading accuracy computation

### Comprehension Assessment

* Record comprehension scores
* Calculate final reading performance metrics
* Generate assessment summaries

### Data Management

* Secure user authentication
* Cloud database storage
* Synchronization across devices

---

## Screenshots

# Dark Mode

| Dashboard      | Reading Assessment | Results        |
| -------------- | ------------------ | -------------- |
| ![Dashboard](assets/screenshot/mobile_home_dark.jpg) | ![Material](assets/screenshot/mobile_reading_material_dark.jpg)     | ![ReadingScore](assets/screenshot/mobile_reading_score_dark.jpg) |

---

## Tech Stack

### Frontend

* Flutter
* Dart

### State Management

* Riverpod

### Backend

* Supabase

### Database

* PostgreSQL (Supabase)

### Authentication

* Supabase Auth

### Storage

* Supabase Storage

### Testing

* Flutter Test
* Mocktail

### CI/CD

* GitHub Actions

---

## Architecture

The project follows a feature-based architecture using Riverpod for state management.

```text
lib/
├── components/
├── constants/
├── models/
├── pages/
├── providers/
├── repositories/
├── services/
├── utils/
├── widgets/
└── main.dart
```

### Data Flow

```text
UI
 ↓
Riverpod Providers
 ↓
Repositories
 ↓
Supabase Services
 ↓
PostgreSQL Database
```

---

## Getting Started

### Prerequisites

Before running the project, make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Supabase Account

Check Flutter installation:

```bash
flutter doctor
```

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/readbee_lite.git
```

Navigate to the project:

```bash
cd readbee_lite
```

Install dependencies:

```bash
flutter pub get
```

---

## Environment Configuration

Create a `.env` file in the root directory:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

---

## Supabase Setup

### Create a Supabase Project

1. Create a project in Supabase.
2. Obtain:

   * Project URL
   * Anon Key

### Configure Authentication

Enable the authentication providers you plan to use.

Examples:

* Email & Password
* Google Sign-In

### Database

Create the required tables for:

* Users
* Students
* Sections
* Reading Materials
* Evaluations
* Miscues
* Scores

### Storage

Create storage buckets for:

* Profile images
* Reading materials
* Generated reports

---

## Running the Application

### Development

```bash
flutter run
```

### Release

Android:

```bash
flutter build apk --release
```

App Bundle:

```bash
flutter build appbundle --release
```

iOS:

```bash
flutter build ios --release
```

---

## Testing

Run all tests:

```bash
flutter test
```

Run a specific test:

```bash
flutter test test/path/to/test_file.dart
```

Generate coverage:

```bash
flutter test --coverage
```

### Testing Strategy

#### Unit Tests

* Utility functions
* Business logic
* Score calculations

#### Widget Tests

* Pages
* Components
* User interactions

#### Integration Tests

* Authentication flow
* Assessment workflow
* Data synchronization

---

## Continuous Integration

GitHub Actions automatically performs:

* Dependency installation
* Code analysis
* Unit and widget testing
* Build verification

Example workflow:

```text
Push / Pull Request
        ↓
Flutter Analyze
        ↓
Flutter Test
        ↓
Build APK
        ↓
Success
```

---

## Code Quality

Analyze code:

```bash
flutter analyze
```

Format code:

```bash
dart format .
```

Fix common issues:

```bash
dart fix --apply
```

---

## Project Structure

```text
lib/
├── components/
│   └── Reusable UI components
│
├── models/
│   └── Data models
│
├── viewmodels/
│   └── providers
│   └── notifiers
│
├── core/
│   └── utils
│   └── services
│   └── layouts
│   └── themes
│
├── views/
│   └── Application screens
│
└── main.dart
```

---

## Future Improvements

* PDF report generation
* Analytics dashboard
* Offline-first synchronization
* Teacher performance insights
* Student reading history visualization
* Export assessment results

---

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.

```bash
git checkout -b feature/new-feature
```

3. Commit your changes.

```bash
git commit -m "Add new feature"
```

4. Push to your branch.

```bash
git push origin feature/new-feature
```

5. Open a Pull Request.

---

## License

This project is licensed under the MIT License.

---

## Author

Developed with Flutter, Riverpod, and Supabase as part of a digital reading assessment platform.
