import 'package:flutter/material.dart';
import 'package:gamebeaten/themes.dart';
import 'package:provider/provider.dart';
import 'data/models/game.dart';
import 'features/add_game/add_game_screen.dart';
import 'features/game_details/game_details_screen.dart';
import 'features/game_list/game_list_screen.dart';
import 'providers/game_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final gameProvider = GameProvider();
  await gameProvider.initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => gameProvider),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Game Beaten',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode, // Define o tema com base no estado
      initialRoute: '/',
      routes: {
        '/': (context) => const GameListScreen(),
        '/add-game': (context) => const AddGameScreen(),
        '/game-details': (context) => GameDetailsScreen(
          game: ModalRoute.of(context)!.settings.arguments as Game,
        ),
      },
    );
  }
}