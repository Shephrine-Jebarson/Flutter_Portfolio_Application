import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart';
import 'providers/theme_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await InjectionContainer.init();
  
  runApp(const CombinedPortfolioApp());
}

class CombinedPortfolioApp extends StatelessWidget {
  const CombinedPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.getProjectProvider()..loadProjects(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Shephrine Jebarson - Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
