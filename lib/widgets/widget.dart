import 'package:flutter/material.dart';
import '../model/wallpaper_model.dart';
import '../views/image_view.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      children: <TextSpan>[
        TextSpan(text: 'Wall',
        style: TextStyle(color: Colors.white,)),
        TextSpan(text: 'Shelf',
            style: TextStyle(color: Colors.red,)),
      ],
    ),
  );
}

Widget wallpapersList(List<WallpaperModel> wallpapers, context){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
    childAspectRatio: 0.6,
    mainAxisSpacing: 10,
    crossAxisSpacing: 7,
    children: wallpapers.map((wallpaper){
      return GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView(
                  imgUrl: wallpaper.src.portrait,
                )
            ));
          },
          child: Hero(
            tag: wallpaper.src.portrait,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                  child: Image.network(wallpaper.src.portrait, fit: BoxFit.cover,)),
            ),
          ),
        ),
      );
  }).toList(),
  ),
  );
}