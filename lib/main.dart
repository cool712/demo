import 'package:file_piker_demo/file_picker_demo.dart';
import 'package:file_piker_demo/file_piker_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilePickerDemo()),
                    );
                  },
                  child: Text("官方示例"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilePikerExample(),
                      ),
                    );
                  },
                  child: Text("自己的"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
