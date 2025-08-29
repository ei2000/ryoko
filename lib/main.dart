import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // 詳細画面で地図を使う場合はコメントを外す

// --- アプリの実行部分 ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '旅行アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 最初に表示する画面を SpotListScreen に設定
      home: const SpotListScreen(),
    );
  }
}


// --- アプリ全体で使うデータ部分 ---

// TravelSpotクラスの定義
class TravelSpot {
  final String name;
  final String imageUrl;
  final double latitude;
  final double longitude;

  const TravelSpot({
    required this.name,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });
}

// 表示したい観光スポットのデータリスト
const List<TravelSpot> travelSpots = [
  TravelSpot(
    name: '金閣寺（鹿苑寺）',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/84/Kinkaku-ji_in_Kyoto_02.jpg',
    latitude: 35.03939,
    longitude: 135.72924,
  ),
  TravelSpot(
    name: '清水寺',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Kiyomizu-dera_in_Kyoto_Japan_April_2007.jpg/1280px-Kiyomizu-dera_in_Kyoto_Japan_April_2007.jpg',
    latitude: 34.99485,
    longitude: 135.78505,
  ),
  TravelSpot(
    name: '東京タワー',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Tokyo_Tower_2012_Oct.JPG/1024px-Tokyo_Tower_2012_Oct.JPG',
    latitude: 35.65858,
    longitude: 139.74543,
  ),
];


// --- 画面その１：観光スポットの一覧画面 ---

class SpotListScreen extends StatelessWidget {
  const SpotListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('観光スポット一覧'),
      ),
      body: ListView.builder(
        itemCount: travelSpots.length,
        itemBuilder: (context, index) {
          final spot = travelSpots[index];
          return ListTile(
            title: Text(spot.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpotDetailScreen(spot: spot),
                ),
              );
            },
          );
        }, // ← ここに itemBuilder の閉じ括弧 `}` が抜けていました
      ), // ← ここに ListView.builder の閉じ括弧 `)` が抜けていました
    );
  }
}


// --- 画面その２：観光スポットの詳細画面（写真・地図） ---

class SpotDetailScreen extends StatelessWidget {
  final TravelSpot spot;

  const SpotDetailScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot.name),
      ),
      body: Column(
        children: [
          // 1. 写真の表示
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              spot.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // 今後のステップ：ここに地図などを追加
        ],
      ),
    );
  }
}