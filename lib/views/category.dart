import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';

class Categories extends StatefulWidget {

  final String categoryName;
  Categories({required this.categoryName});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {


  TextEditingController searchControl = new TextEditingController();
  List<WallpaperModel> wallpapers = [];

  getSearchwall(String query) async {

    var response = await http.get(Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=82'), headers: {
      "Authorization" : apiKey});

    //print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData["photos"].forEach((i) {
      //print(i)
      //WallpaperModel wallpapermodel = new WallpaperModel(src: i["src"], photographer: i["photographer"],
      //photographer_id: i["photographer_id"], photographer_url: i["photographer_url"], );
      WallpaperModel wallpapermodel = new WallpaperModel.fromMap(i);
      wallpapers.add(wallpapermodel);
    });

    setState(() {

    });
  }

  @override
  void initState() {
    getSearchwall(widget.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: brandName(),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x2affffff),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchControl,
                            decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getSearchwall(searchControl.text);
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  wallpapersList(wallpapers,context)
                ],
              )
          ),
        )
    );
  }
}
