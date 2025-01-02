import 'package:flutter/material.dart';
import 'package:sqlsqlsql/provider/themeprovider.dart';
import 'package:sqlsqlsql/screens/app/language.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Appearence"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Choose App Theme",
                        ),
                        GestureDetector(
                          child: Icon(Icons.close_rounded),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ThemeMode.values.map((themeMode) {
                        return ListTile(
                          title: Text(
                            themeMode
                                    .toString()
                                    .split('.')
                                    .last[0]
                                    .toUpperCase() +
                                themeMode
                                    .toString()
                                    .split('.')
                                    .last
                                    .substring(1),
                          ),
                          leading: Radio<ThemeMode>(
                            value: themeMode,
                            groupValue: themeProvider.themeMode,
                            onChanged: (_) {
                              // if (value != null) {
                              //   themeProvider.setThemeMode(value);
                              //   Navigator.of(context).pop();
                              // }
                            },
                          ),
                          onTap: (){
                            themeProvider.setThemeMode(themeMode);
                            Navigator.of(context).pop();
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageScreen()));
            },
          ),
        ],
      ),
    );
  }
}
