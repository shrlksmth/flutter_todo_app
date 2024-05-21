import 'package:flutter/material.dart';

import 'main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;

    return ScreenUtilInit(
       //designSize: Size(ScreenSize.width, ScreenSize.height),
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.dark(),
                textTheme: TextTheme(
                  titleMedium: TextStyle(fontSize: 18.sp),
                  titleSmall: TextStyle(fontSize: 18.sp),
                  titleLarge: TextStyle(fontSize: 18.sp),
                  bodyMedium: TextStyle(fontSize: 18.sp),
                  bodyLarge: TextStyle(fontSize: 18.sp),
                  bodySmall: TextStyle(fontSize: 18.sp),
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                useMaterial3: true),
            home: child);
      },
      child: MainScreen(),
    );
  }
}
