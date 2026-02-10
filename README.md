# Combined Portfolio App - Flutter Day-5

This is a combined Flutter application that integrates the portfolio from Day-2 and the project list functionality from Day-4.

## Features

### Portfolio Section (from Day-2)
- **Profile Header**: Displays name, role, bio, education, and CGPA with animated entrance
- **Skills Section**: Shows technical and soft skills in an organized grid
- **Projects Overview**: Preview of key projects with navigation to detailed project list
- **Achievements Section**: Displays accomplishments and awards
- **Contact Information**: Contact form and personal details
- **Project Counter**: Interactive rating system with increment and reset functionality

### Project Management (from Day-4)
- **Project List**: Comprehensive list of all projects with detailed information
- **Project Details**: Individual project pages with full descriptions
- **Add Projects**: Functionality to add new projects to the portfolio
- **Animated Transitions**: Smooth page transitions and entrance animations

## Navigation Flow

1. **Home Screen**: Landing page with profile overview and "View Portfolio" button
2. **Portfolio Screen**: Complete portfolio display with "View All Projects" button in the projects section
3. **Project List Screen**: Detailed project management interface
4. **Project Detail Screen**: Individual project information pages

## Key Integration Points

- The portfolio's "My Projects" section now includes a "View All Projects" button that navigates to the project list
- The project list maintains all original functionality while being accessible from the portfolio
- Consistent design theme and color scheme across both sections
- Smooth navigation transitions between screens

## Technical Details

- **Framework**: Flutter 3.10.7+
- **Dependencies**: 
  - google_fonts: Professional typography
  - animated_text_kit: Text animations
  - flutter_animate: Entrance animations
- **Architecture**: Organized with separate folders for profile and project functionality
- **Theme**: Dark theme with cyan accent colors (#00d4ff)

## File Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── project.dart                   # Project model
│   └── sample_data.dart              # Sample project data
├── profile/                          # Portfolio-related files
│   ├── profile.dart                  # Profile data model
│   └── widgets/                      # Profile widgets
│       ├── achievements_section.dart
│       ├── contact_info.dart
│       ├── profile_header.dart
│       ├── project_counter.dart
│       └── skills_section.dart
├── screens/                          # Main screens
│   ├── home_screen.dart             # Landing page
│   ├── portfolio_screen.dart        # Combined portfolio display
│   ├── project_list_screen.dart     # Project management
│   ├── project_detail_screen.dart   # Individual project details
│   └── add_project_screen.dart      # Add new projects
└── widgets/                         # Shared widgets
    ├── portfolio_projects_section.dart # Projects section with navigation
    ├── project_card.dart            # Project display cards
    └── empty_state.dart             # Empty state display
```

## How to Run

1. Navigate to the Flutter Day-5 folder
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Features Demonstration

- Start on the home screen with profile overview
- Click "View Portfolio" to see the complete portfolio
- In the portfolio, scroll to the "My Projects" section
- Click "View All Projects" to access the detailed project list
- Add, view, and manage projects through the project list interface
- Use the back button to return to the portfolio from the project list