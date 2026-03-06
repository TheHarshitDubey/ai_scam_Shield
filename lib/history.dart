import 'dart:convert';
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
    final url = Uri.parse("http://192.168.1.15:8080/history");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

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
        title: const Text("History"),
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
    );
  }
}