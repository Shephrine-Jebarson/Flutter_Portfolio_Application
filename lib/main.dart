import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_provider.dart';
import 'providers/theme_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'theme/app_theme.dart';

/// App entry point - Initializes providers and loads data
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final projectProvider = ProjectProvider();
  await projectProvider.loadProjects();
  runApp(CombinedPortfolioApp(projectProvider: projectProvider));
}

/// Root widget with provider setup
class CombinedPortfolioApp extends StatelessWidget {
  final ProjectProvider projectProvider;
  
  const CombinedPortfolioApp({super.key, required this.projectProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: projectProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const _AppView(),
    );
  }
}

/// MaterialApp wrapper that listens to theme changes only
class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when theme changes, not on every provider update
    final themeMode = context.select<ThemeProvider, ThemeMode>((p) => p.themeMode);
    
    return MaterialApp(
      title: 'Shephrine Jebarson - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
