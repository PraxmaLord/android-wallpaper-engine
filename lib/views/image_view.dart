import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_v3/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {

  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: 
      Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.imgUrl, fit: BoxFit.cover,)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _save();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff1c1b1b).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        height: 62,
                          width: 230,
                      ),
                      Container(
                        width: 230,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [Color(0x7f000000), Color(0x7f000000)],
                            )
                        ),
                        child: Column(
                          children: [
                            Text("Download" , style: TextStyle(
                                fontSize: 18, color: Colors.white
                            ),),
                            SizedBox(height: 8,),
                            Text("Image will be saved in the Gallery", style: TextStyle(
                                fontSize: 12, color: Colors.white
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(25)
                          ),
                            width: 160,
                            height: 42,
                            child: Text("\nCancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[200],)
                            )),
                      ],
                    )),
                SizedBox(height: 50,)
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async{
    if(Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(responseType: ResponseType.bytes)
    );
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async{
    if(Platform.isIOS) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    }
    else{
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
  }
}
