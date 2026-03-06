import 'package:ai_scam_shield/history.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Analyzepage extends StatefulWidget {
  const Analyzepage({super.key});

  @override
  State<Analyzepage> createState() => _AnalyzepageState();
}

class _AnalyzepageState extends State<Analyzepage> {
  final TextEditingController _Message = TextEditingController();
  bool isLoading = false;
  bool? is_Scam;
  double? confidence;
  String? reply;
  String? response;

  Future<void> pickImageAndExtractText() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final inputImage = InputImage.fromFile(File(image.path));

    final textRecognizer = TextRecognizer();

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    setState(() {
      _Message.text = recognizedText.text;
    });
  }

  Future<void> analyzeMessage() async {
    if (_Message.text.isEmpty) return;

    setState(() {
      isLoading = true;
      is_Scam = null;
    });

    final url = Uri.parse("http://192.168.1.15:8080/chat");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": _Message.text}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          is_Scam = data["is_scam"];
          confidence = data["confidence"];
          reply = data["reply"];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generateReply() async {
    final url = Uri.parse("http://192.168.1.15:8080/generate-reply");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": _Message.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Suggested Reply"),
            content: Text(data["generated_reply"]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: Icon(
          Icons.shield_outlined,
          size: 22,
          color: Colors.blue,
          weight: 500,
        ),
        title: Text(
          "AI Scam Shield",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(
                    8), // CRITICAL: Adds space so shadow doesn't hit the edge and cut off
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.6), // Light shadow color
                      blurRadius: 10, // Makes it blurry/soft
                      spreadRadius: 2, // How far the shadow reaches
                      offset: Offset(0, 4), // Shifts shadow down slightly
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 40,
                  child: Icon(
                    Icons.shield_outlined,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Protect Yorself From Digital Fraud",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "AI powered scam detection",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Icon(
                          Icons.messenger_outline_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Message Analysis',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: TextField(
                        controller: _Message,
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          label: Text('Paste Suspicious Message here...'),
                          alignLabelWithHint: true,
                          // border: OutlineInputBorder(
        
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 199, 193, 193)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.fromLTRB(14, 12, 0, 8)),
                                onPressed: () {
                                  analyzeMessage();
                                },
                                child: Text(
                                  'Execute',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.fromLTRB(0, 12, 14, 8)),
                          onPressed: pickImageAndExtractText,
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    if (isLoading) const CircularProgressIndicator(),
              // SizedBox(
              //   height: 15,
              // ),
              if (is_Scam != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                     
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          
                          is_Scam! ? "🚨 Scam" : "✅ Safe Message",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: is_Scam! ? Colors.red : Colors.green),
                        ),
                      ),SizedBox(height:8),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(5),
  value: confidence,
  minHeight: 8,
  color: is_Scam! ? Color(0xFFDC2626) : Color(0xFF16A34A),
  backgroundColor: Color(0xFFE2E8F0),
),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Confidence : ${(confidence ?? 0) * 100}%",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        reply ?? "",
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),SizedBox(height: 5,),
              if (is_Scam == true)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: generateReply,
                  child: const Text("Generate Safe Reply",style: TextStyle(color: Colors.black),),
                ),
                  ],
                ),
              ),
             
            
            ],
          ),
          ),
        ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          TextButton(
           style: TextButton.styleFrom(
              
              overlayColor: Colors.blue.withOpacity(0.2), 
            ),
            onPressed: () {
            
            },
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum space
              children: [
                Icon(Icons.shield_outlined, size: 18.0), // Your icon
               //  SizedBox(height: 2.0),       // Optional space between icon and text
                Text("Analyze"),                 // Your text
              ],
            ),
          ),
           
        TextButton(
            style: TextButton.styleFrom(
               
               overlayColor: Colors.blue.withOpacity(0.2), 
             ),
             onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>const History()));
             },
             child: Column(
               mainAxisSize: MainAxisSize.min, // Use minimum space
               children: [
                 Icon(Icons.access_time, size: 18.0), // Your icon
                //  SizedBox(height: 2.0),       // Optional space between icon and text
                 Text("History"),                 // Your text
               ],
             ),
           ),
            TextButton(
            style: TextButton.styleFrom(
               
               overlayColor: Colors.blue.withOpacity(0.2), 
             ),
             onPressed: () {
             
             },
             child: Column(
               mainAxisSize: MainAxisSize.min, // Use minimum space
               children: [
                 Icon(Icons.analytics_outlined, size: 18.0), // Your icon
                //  SizedBox(height: 2.0),       // Optional space between icon and text
                 Text("Analytics"),                 // Your text
               ],
             ),
           ), ],),
      ),
    );
  }
}
