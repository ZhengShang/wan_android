import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MePage extends StatelessWidget {
  var listData = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    for (int i = 0; i < 20; i++) {
      listData.add(i);
    }
    return CupertinoPageScaffold(
      child: Center(
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Good $index'),
              trailing: Icon(Icons.favorite_border),
              onTap: () {
                _launchURL();
              },
            );
          },
          itemCount: listData.length,
        ),
      ),
    );
  }

  List<Widget> _sliderItems() {
    List<Widget> list = []
      ..add(Image.network(
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531798262708&di=53d278a8427f482c5b836fa0e057f4ea&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F342ac65c103853434cc02dda9f13b07eca80883a.jpg",
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        "https://upload-images.jianshu.io/upload_images/4263685-6a4a808ccb2b5289.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp",
        fit: BoxFit.cover,
      ))
      ..add(Image.network(
        "https://coubsecure-s.akamaihd.net/get/b58/p/coub/simple/cw_timeline_pic/06a601e34b8/85f1990f74e25488fc09c/big_1509818123_image.jpg",
        fit: BoxFit.fill,
      ));
    return list;
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url,
          forceWebView: true, statusBarBrightness: Brightness.dark);
    } else {
      throw 'Could not launch $url';
    }
  }
}
