import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class newsModel {  
  dynamic newsDesc;
  dynamic newsHead;
  dynamic newsImg;
  dynamic newsUrl;
  newsModel(
      {this.newsDesc = "Some News",
      this.newsHead = "Breaking News",
      this.newsImg = "url",
      this.newsUrl = "url"});

  factory newsModel.fromMap(element) {
    return newsModel(
        newsDesc: element["description"],
        newsHead: element["title"],
        newsImg: element["urlToImage"],
        newsUrl: element["url"]);
  }
}










