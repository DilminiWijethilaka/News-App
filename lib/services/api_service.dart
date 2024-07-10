import 'dart:convert';
import 'package:untitled/model/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/model/source_model.dart';

class ApiService {
  final String endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=008f7779e7744f978b3dbfbb01dc9096";

  Future<List<Article>> getArticle() async {
    try {
      Uri uri = Uri.parse(endPointUrl);
      http.Response res = await http.get(uri);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        List<dynamic> body = json['articles'];

        List<Article> articles = body.map((dynamic item) {
          try {
            var article = Article.fromJson(item);
            print('Article title: ${article.title}');
            print('Article urlToImage: ${article.urlToImage}');
            return article;
          } catch (e) {
            print('Error parsing article: $e');
            return Article(
              source: Source(id: 'Unknown ID', name: 'Unknown Source'),
              author: 'Unknown Author',
              title: 'No Title',
              description: 'No Description',
              url: '',
              urlToImage: '',
              publishedAt: '',
              content: '',
            );
          }
        }).toList();

        return articles;
      } else {
        throw Exception("Failed to load articles. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
