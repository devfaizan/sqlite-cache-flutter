import 'package:flutter/material.dart';
import 'package:sqlsqlsql/home.dart';
import 'package:sqlsqlsql/provider/petprovider.dart';
import 'package:sqlsqlsql/provider/userformprovider.dart';
import 'package:sqlsqlsql/screens/user/userform.dart';
import 'package:provider/provider.dart';
import 'package:sqlsqlsql/provider/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserFormProvider()),
        ChangeNotifierProvider(create: (context) => PetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
    _isLoggedIn = _checkSession(userFormProvider);
    super.initState();
  }

  Future<bool> _checkSession(UserFormProvider userFormProvider) async {
    try {
      final user = await userFormProvider.loadSession();
      return user.id != null;
    } catch (e) {
      debugPrint('Error loading session: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.themeMode,
      home: FutureBuilder(
        future: _isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const UserFormScreen();
          }
        },
      ),
    );
  }
}
