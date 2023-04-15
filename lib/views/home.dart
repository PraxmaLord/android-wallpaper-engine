import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/views/category.dart';
import 'package:wallpaper/views/image_view.dart';
import 'package:wallpaper/views/search.dart';
import 'package:wallpaper/widgets/widget.dart';
import '../model/categories_model.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchControl = new TextEditingController();

  getTrendingWall() async {

    var response = await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=82/'), headers: {
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
    getTrendingWall();
    categories = getCategory();
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
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Search(
                              searchQuery: searchControl.text,
                        )
                        ));
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

              const SizedBox(height: 20),
              Container(
                height: 80,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)
                    {
                      return CategoryTile(
                      title: categories[index].categoriesName,
                      imgUrl: categories[index].imgUrl,
                );
                }
                ),
              ),
              const SizedBox(height: 10),
              wallpapersList(wallpapers,context)
            ],
          ),
        ),
      ),
    );
  }
}


class CategoryTile extends StatelessWidget {

  final String imgUrl, title;
  CategoryTile({required this.title,required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Categories(
              categoryName: title.toLowerCase(),)
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        child: Stack(children: [
          ClipRRect(
        borderRadius: BorderRadius.circular(12),
              child: Image.network(imgUrl, height: 60, width: 100,
              fit: BoxFit.cover,),
      ),
              Container(
                height: 60, width: 100,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(title, style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),),
              ),
        ],),
      ),
    );
  }
}


