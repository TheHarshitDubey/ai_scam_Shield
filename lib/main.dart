import 'package:ai_scam_shield/analyzePage.dart';
import 'package:ai_scam_shield/user_service.dart';

import 'package:flutter/material.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  await UserService.initUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        // scaffoldBackgroundColor: const Color(0xFFFFE4E1)
        
    
      ),
      home:  Analyzepage(),
    );
  }
}

