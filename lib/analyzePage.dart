import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Analyzepage extends StatefulWidget {
  const Analyzepage({super.key});

  @override
  State<Analyzepage> createState() => _AnalyzepageState();
}

class _AnalyzepageState extends State<Analyzepage> {
  final TextEditingController _Message=TextEditingController();
  bool isLoading=false;
  bool? is_Scam;
  double? confidence;
  String? reply;

  Future<void> analyzeMessage() async{
    if(_Message.text.isEmpty) return;

    setState(() {
      isLoading=true;
      is_Scam=null;
    });

    final url = Uri.parse("http://127.0.0.1:8080/chat");


    try {
      final response =await http.post(
        url,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "message" :_Message.text
        }),
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);

        setState(() {
        is_Scam = data["is_scam"];
        confidence = data["confidence"];
        reply = data["reply"];
        isLoading = false;
      });}
    else {
      setState(() {
        isLoading = false;
      });
    } 
    }catch (e) {
    setState(() {
      isLoading = false;
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Scam Shield",style: TextStyle(fontSize:22,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(child: Column(
          children: [
            TextField(
              controller:_Message,
              maxLines: 5,
              decoration: InputDecoration(
                label: Text('Enter Message'),
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
            ),SizedBox(height: 8,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  
                ),
                onPressed: (){
                  analyzeMessage();
                }, child: Text('Execute',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
            ),
            SizedBox(height: 15,),
            if(isLoading)
             const CircularProgressIndicator(),
            SizedBox(height: 15,),
            if(is_Scam!=null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: is_Scam! ? const Color.fromARGB(255, 219, 132, 126) : Color.fromARGB(255, 109, 179, 107),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Text(is_Scam! ? "🚨 High Risk Scam" :"✅ Safe Message",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: is_Scam!?Colors.red :Colors.green),),
                    SizedBox(height: 15,),
                    Text("Confidence : ${(confidence ?? 0)*100}%",style: TextStyle(fontSize: 16),),
                    SizedBox(height: 15,),
                    Text(reply ?? "",
                      style: const TextStyle(fontSize: 14),)
                  ],
                ),
                
                

              )
          ],
        )
        

        ),
      ),
    );
  }
}