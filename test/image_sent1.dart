import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  String? _imageUrlFromServer;

  // 画像をギャラリーから選択する関数
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrlFromServer = null; // 新しい画像を選んだら、前の表示は消す
      });
    }
  }

  // バックエンドに画像をアップロードする関数
  Future<void> _uploadImage() async {
    if (_image == null) return;

    // ★★★ 自分のPCのIPアドレスなどに変更してください ★★★
    final uri = Uri.parse('http://192.168.1.10:3000/upload');
    final request = http.MultipartRequest('POST', uri);

    final fileStream = http.ByteStream(_image!.openRead());
    final length = await _image!.length();
    final multipartFile = http.MultipartFile(
      'image', // バックエンドで受け取るキー
      fileStream,
      length,
      filename: basename(_image!.path),
    );

    request.files.add(multipartFile);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('アップロード成功: $responseBody');
        setState(() {
          // バックエンドから返された画像のURLをセット
          _imageUrlFromServer = responseBody;
        });
      } else {
        print('アップロード失敗: ${response.statusCode}');
      }
    } catch (e) {
      print('エラーが発生: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('画像アップロード サンプル')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // サーバーから取得した画像があれば表示
              if (_imageUrlFromServer != null)
                Image.network(_imageUrlFromServer!, height: 200)
              // 端末から選択した画像があれば表示
              else if (_image != null)
                Image.file(_image!, height: 200)
              else
                Text('画像が選択されていません'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('画像を選択'),
              ),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('アップロード'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}