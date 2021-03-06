
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paged_datatable_example/post.dart';

import 'main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting("en");

  PostsRepository.generate(100);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        // PagedDataTableLocalization.delegate
      ],
      supportedLocales: const [
        Locale("es"), Locale("en")
      ],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          )
        )
      ),
      home: const MainView(),
      
    );
  }
}