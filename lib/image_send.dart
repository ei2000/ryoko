import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Example',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  // ★★★ サーバーから返された画像のURLを保存するための変数を追加
  String? _uploadedImageUrl;

  // ★★★ IPアドレスやドメインなど、ご自身の環境に合わせてください
  final String _uploadUrl = 'http://192.168.1.10:3000/upload';

  // ギャラリーから画像を選択
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadedImageUrl = null; // ★★★ 新しい画像を選んだら、サーバー画像のURLはリセット
      } else {
        print('No image selected.');
      }
    });
  }

  // 選択した画像をサーバーにアップロード
  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像が選択されていません。')),
      );
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        filename: _image!.path.split('/').last,
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // ★★★ レスポンスから返されたURL文字列を取得
        final imageUrl = await response.stream.bytesToString();

        // ★★★ 取得したURLをstateに保存して画面を更新
        setState(() {
          _uploadedImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像のアップロードに成功しました！')),
        );
        print('Image uploaded successfully! URL: $imageUrl');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像のアップロードに失敗しました。Status: ${response.statusCode}')),
        );
        print('Image upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('画像アップロード'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ★★★ 表示ロジックの変更
            if (_uploadedImageUrl != null)
            // サーバーからURLが返ってきたら、そのURLの画像を表示
              Image.network(_uploadedImageUrl!, height: 200)
            else if (_image != null)
            // まだアップロードしてないが、画像を選択済みの場合はローカルファイルを表示
              Image.file(_image!, height: 200)
            else
            // 何も選択されていない場合
              Text('画像が選択されていません。'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('ギャラリーから画像を選択'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('画像をサーバーに送信'),
            ),
          ],
        ),
      ),
    );
  }
}