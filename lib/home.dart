import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';
import 'package:http/http.dart';
import 'view.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<String> navBar = [
    "Top News",
    "Uttarakhand",
    "Technology",
    "Climate",
    "Health",
    "Finance",
    "Politics"
  ];
  List<newsModel> models = [];
  getIndiaNews() async {
    String api =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=eb9b4c86ea77420bb6fea349145f4b45";
    Uri url = Uri.parse(api);
    Response response = await get(url);
    Map trash = jsonDecode(response.body);
    List info = trash["articles"];
    print(info.length);

    try {
      for (var element in info) {
        newsModel newsmodel = newsModel();
        newsmodel = newsModel.fromMap(element);
        models.add(newsmodel);
        if (models.length >= 50) {
          break;
        }
      }
    } catch (e) {
      print(e);
    }
    ;
    //print(models);
    print(models[0].newsHead);
    setState(() {
      isLoading = false;
    });
    print(models.length);
  }

  List<newsModel> headlines = [];
  gettingdata(String heading) async {
    String api =
        "https://newsapi.org/v2/everything?q=AI&from=2023-07-08&to=2023-07-08&sortBy=popularity&apiKey=eb9b4c86ea77420bb6fea349145f4b45";
    Uri url = Uri.parse(api);
    Response response = await get(url);
    Map trash = jsonDecode(response.body);
    List info = trash["articles"];

    try {
      for (var element in info) {
        newsModel newsmodel = newsModel();
        newsmodel = newsModel.fromMap(element);
        headlines.add(newsmodel);
        if (headlines.length >= 12) {
          break;
        }
      }
    } catch (e) {
      print(e);
    }
    //print(models);
    print(headlines[0].newsHead);
    setState(() {
      isLoading = false;
    });
    print(headlines.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata() async {
      await getIndiaNews();
      await gettingdata("hi");
    }

    getdata();
    super.initState();
  }

  TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("News"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    search(searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      search(searchController.text)));
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search Health"),
                    ),
                  )
                ],
              )),
          Container(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: navBar.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => search(navBar[index])));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          navBar[index],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ));
                },
              )),
          isLoading
              ? CircularProgressIndicator()
              : CarouselSlider(
                  options: CarouselOptions(
                      height: 150.0, autoPlay: true, enlargeCenterPage: true),
                  items: headlines.map((instance) {
                    return Builder(
                      builder: (BuildContext context) {
                        try {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Viewurl(instance.newsUrl)));
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Card(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              instance.newsImg,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            width: 380,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Text(
                                              instance.newsHead,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )));
                        } catch (e) {
                          print(e);
                          return Container();
                        }
                      },
                    );
                  }).toList(),
                ),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: models.length >= 50 ? 45 : models.length,
                itemBuilder: (context, index) {
                  try {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Viewurl("${models[index].newsUrl}")));
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                          child: Card(
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        // "https://images.hindustantimes.com/img/2022/07/13/550x309/WhatsApp_Image_2021-09-18_at_09.42.18_1631944439782_1657670932236_1657670932236.jpeg",
                                        models[index].newsImg == null
                                            ? "data:image/png;base64,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"
                                            : models[index].newsImg,
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      left: 5,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 5, 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                models[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))))
                                ],
                              )),
                        ));
                  } catch (e) {
                    print(e);
                  }
                }),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => search("World")));
              },
              child: Text(
                "Show More",
                style: TextStyle(color: Colors.black),
              ))
        ])),
      ),
      backgroundColor: Colors.white,
    );
  }

  List colors = [
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.grey,
    Colors.blue
  ];
  List images = [];
}
