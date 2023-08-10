import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';
import 'package:http/http.dart';
import 'view.dart';

class search extends StatefulWidget {
  String query;
  search(this.query);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
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
  gettingdata(String heading) async {
    String api;
    if (heading == "Top News") {
      api =
          "https://newsapi.org/v2/top-headlines?country=US&apiKey=eb9b4c86ea77420bb6fea349145f4b45";
    } else {
      api =
          "https://newsapi.org/v2/everything?q=$heading&from=2023-07-08&to=2023-07-08&sortBy=popularity&apiKey=eb9b4c86ea77420bb6fea349145f4b45";
    }
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
        if (models.length >= 25) {
          break;
        }
      }
    } catch (e) {}
    //print(models);
    print(models[0].newsHead);
    setState(() {
      isLoading = false;
    });
    print(models.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata() async {
      await gettingdata(widget.query);
    }

    getdata();
    if (navBar.contains(widget.query)) {
      navBar.remove(widget.query);
    }
    print("init state called");
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
                        Navigator.pushReplacement(
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
                        Navigator.pushReplacement(
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
          Container(
            child: isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      try {
                        return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Viewurl("${models[index].newsUrl}")));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 5),
                              child: Card(
                                  elevation: 1.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            // "https://images.hindustantimes.com/img/2022/07/13/550x309/WhatsApp_Image_2021-09-18_at_09.42.18_1631944439782_1657670932236_1657670932236.jpeg",
                                            models[index].newsImg,
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          left: 5,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 5, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black12
                                                            .withOpacity(0),
                                                        Colors.black
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
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
                        return Container();
                      }
                    }),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => search(widget.query)));
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
