import 'package:flutter/material.dart';
import 'package:wan_android/page/login_page.dart';

class MePage extends StatefulWidget {
  @override
  MePageState createState() {
    return new MePageState();
  }
}

class MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      children: _getListRows(),
    );
  }

  Widget _getAvatarWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250.0,
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 40.0,
                child: Image.asset('assets/pikachu.png'),
              ),
            ),
            Text(
              'Pikachu',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getListRows() {
    List<Widget> widgets = <Widget>[];

    widgets.add(_getAvatarWidget());

    widgets.add(ListTile(
      leading: Icon(
        Icons.favorite,
        color: Colors.red,
      ),
      title: Text(
        '收藏',
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    ));

    widgets.add(_getDivider());

    widgets.add(ListTile(
      leading: Icon(
        Icons.playlist_add_check,
        color: Colors.green,
      ),
      title: Text("TODO"),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('GO TODO')));
      },
    ));

    widgets.add(_getDivider());

    widgets.add(ListTile(
      leading: Icon(
        Icons.info,
      ),
      title: Text("关于"),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('GO About')));
      },
    ));

    widgets.add(_getDivider());

    return widgets;
  }
}

Widget _getDivider() {
  return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black12, width: 0.5))));
}
