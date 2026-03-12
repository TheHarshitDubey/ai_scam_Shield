import 'dart:convert';
import 'package:ai_scam_shield/analytics.dart';
import 'package:ai_scam_shield/analyzePage.dart';
import 'package:ai_scam_shield/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'scan_model.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  List<ScanModel> scans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final url = Uri.parse("https://backend-api-d3ku.onrender.com/history/${UserService.userId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body,);

        setState(() {
          scans = data.map((e) => ScanModel.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
      ),
      body:
      
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, index) {
                final scan = scans[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      scan.isScam ? Icons.warning : Icons.check_circle,
                      color: scan.isScam ? Colors.red : Colors.green,
                    ),
                    title: Text(
                      "Confidence ${(scan.confidence * 100).toStringAsFixed(1)}%",
                    ),
                    subtitle: Text(scan.reply),
                  ),
                );
              },
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
              
              foregroundColor:Colors.black,
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
               
               foregroundColor:Colors.black,
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
               
               foregroundColor:Colors.black,
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