import 'dart:async';
import 'package:diabetes/Usables/Utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class HomeVC extends StatefulWidget {

  @override
  _HomeVCState createState() => new _HomeVCState(-1);
}

class _HomeVCState extends State<HomeVC>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String titleText = "My Sessions";
  List<String> titles = [
    "Home",
    "Feeds",
    "Add",
    "Devices",
    "Profile"
  ];

  final int _routeTo;

  _HomeVCState(this._routeTo);

  @override
  void initState() {
    super.initState();

    tabController = new TabController(vsync: this, length: 5);
    tabController?.addListener(_handleTitle);

    if (_routeTo != -1) {
      if (_routeTo == 4) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => retailer.ConnectRetailerScreen()));
      } else {
        routeToPage(_routeTo);
      }
    }
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  void _handleTitle() {
    setState(() {
      titleText = titles[tabController!.index];
    });
  }


  void routeToPage(int pageTo) {
    tabController?.animateTo(pageTo);
    //Navigator.of(context).pop();

    setState(() {
      switch (pageTo) {
        case 0:
          setTitleText("My Home");
          break;
        case 1:
          setTitleText("Feeds");
          break;
        case 2:
          setTitleText("Add");
          break;
        case 3:
          setTitleText("Devices");
          break;
        case 4:
          setTitleText("Profile");
          break;
        default:
      }
    });
  }

  void setTitleText(String text) {
    setState(() {
      this.titleText = text;
    });
  }


  void routeToConnectRetailer() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => retailer.ConnectRetailerScreen()));
  }

  void routeToChangePassword() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    final connectToRetailer = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightGreenAccent.shade100,
        child: MaterialButton(
          minWidth: 100.0,
          height: 42.0,
          onPressed: () => routeToConnectRetailer(),
          color: const Color(0xff00c9d2),
          child: Text(
            'Connect To Retailer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
    );

    final hamburgerMenu = Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "User: ${Utility().getUserData().name.isEmpty ? "User" : Utility().getUserData().name}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
                fontStyle: FontStyle.italic,
              ),
            ),
            accountEmail: Text("Active since: ${Utility().getUserData().creationDate}",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0)),
            currentAccountPicture: GestureDetector(
              //onTap: () => routeToChangePassword(),
              child: CircleAvatar(
                  backgroundImage: AssetImage("assets/avatar2.png")),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/blue_bar.jpg"))),
          ),
          ListTile(
              title: Text(
                "Version Number: 0.21",
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: Icon(Icons.done)),
          ListTile(
              title: Text(
                "Log out",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                ),
              ),
              trailing: Icon(Icons.offline_bolt),
              onTap: () => print('')),
          Divider(),
          ListTile(
            title: Text(
              "Close",
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
              ),
            ),
            trailing: Icon(Icons.cancel),
            onTap: () => Navigator.of(context).pop(),
          ),
          connectToRetailer
        ],
      ),
    );

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: new AppBar(
              elevation: 0.0,
              centerTitle: true,
              iconTheme: new IconThemeData(color: Colors.grey),
              title: Text(titleText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0)),
              backgroundColor: Colors.white,
            ),
            drawer: hamburgerMenu,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: const Color(0xff00c9d2),
              onTap: routeToPage,
              currentIndex: tabController!.index,
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home_rounded),
                    label: titles[0],
                    activeIcon: const Icon(Icons.home_rounded, color: Colors.blue)),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.feed),
                    label: titles[0],
                    activeIcon: const Icon(Icons.feed, color: Colors.blue)),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.add),
                    label: titles[2],
                    activeIcon: const Icon(Icons.add, color: Colors.blue)),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.devices),
                    label: titles[3],
                    activeIcon: const Icon(Icons.devices, color: Colors.blue)),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person_2_rounded),
                    label: titles[4],
                    activeIcon: const Icon(Icons.person_2_rounded, color: Colors.blue)),
              ],
            ),
            body: TabBarView(
              controller: tabController,
              children: <Widget>[

              ],
            )));
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          fontStyle: FontStyle.normal,
        ),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}