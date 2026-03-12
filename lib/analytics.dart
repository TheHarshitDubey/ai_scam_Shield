import 'dart:convert';

import 'package:ai_scam_shield/analyzePage.dart';
import 'package:ai_scam_shield/history.dart';
import 'package:ai_scam_shield/statCard.dart';
import 'package:ai_scam_shield/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _analysisState();
}

class _analysisState extends State<Analysis> {

  double total_scans=0;
  double scams_detected=0;
  double safe_message=0;
  double high_risk_rate=0;
 @override
  void initState() {
    super.initState();
    print("called");
    fetchStats();
  }
Future<void> fetchStats() async {

  final url = Uri.parse("https://backend-api-d3ku.onrender.com/stats/${UserService.userId}");

  final response = await http.get(url);

  // print("API RESPONSE:");
  // print(response.body);

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    // print("Decoded data: $data");

    setState(() {
      total_scans = (data["total_scans"] ?? 0).toDouble();
      scams_detected = (data["scams_detected"] ?? 0).toDouble();
      safe_message = (data["safe_messages"] ?? 0).toDouble();
      high_risk_rate = (data["high_risk_rate"] ?? 0).toDouble();
    });

    // print("Updated values:");
    // print(total_scans);
    // print(scams_detected);
    // print(safe_message);
    // print(high_risk_rate);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Analytics',style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              SizedBox(height: 10,),
              Text("Scam Insights",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),),
                  SizedBox(height: 6,),
                  Text( "Monitor scam detection activity",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),),
                  SizedBox(height: 24,),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                      icon: Icons.search,
                      color: Color(0xFF2563EB),
                      value: "$total_scans",
                      label: "Total Scans",
                    ),
          
                    StatCard(
                      icon: Icons.warning,
                      color: Colors.red,
                      value: "$scams_detected",
                      label: "Scams Detected",
                    ),
          
                    StatCard(
                      icon: Icons.check_circle,
                      color: Colors.green,
                      value: "$safe_message",
                      label: "Safe Messages",
                    ),
          
                    StatCard(
                      icon: Icons.shield,
                      color: Color(0xFFDC2626),
                      value: "${high_risk_rate}%",
                      label: "High Risk",
                    ),
                    ],
                    )
            ]),
        )
      ),
       bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
       
        ),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          TextButton(
           style: TextButton.styleFrom(
              
              foregroundColor:Colors.black 
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Analyzepage()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Icon(Icons.shield_outlined, size: 18.0), 
                Text("Analyze"),                
              ],
            ),
          ),
           
        TextButton(
            style: TextButton.styleFrom(
               
               foregroundColor:Colors.black 
             ),
             onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>const History()));
             },
             child: Column(
               mainAxisSize: MainAxisSize.min, 
               children: [
                 Icon(Icons.access_time, size: 18.0), 
                 Text("History"),                
               ],
             ),
           ),
            TextButton(
            style: TextButton.styleFrom(
               
               foregroundColor:Colors.black 
             ),
             onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>const Analysis()));
             },
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Icon(Icons.analytics_outlined, size: 18.0), 
                 Text("Analytics"),                
               ],
             ),
           ), ],),
      ),
    );
  }
}