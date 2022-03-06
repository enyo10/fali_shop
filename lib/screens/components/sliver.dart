import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fali_shop/auth/sign_up.dart';
import 'package:fali_shop/data_base/api.dart';
import 'package:fali_shop/models/category.dart';
import 'package:fali_shop/models/user.dart';
import 'package:fali_shop/screens/components/add_category.dart';
import 'package:fali_shop/screens/components/navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'article_category_tile.dart';
import 'package:fali_shop/providers/data_provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key key,
  }) : super(key: key);

  @override
  State createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  // SliverAppBar is declared in Scaffold.body, in slivers of a
  // CustomScrollView.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: MyBody(pinned: _pinned, snap: _snap, floating: _floating),
      drawer: NavigateDrawer(),
      bottomNavigationBar: Visibility(
        visible: false,
        child: BottomAppBar(
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Text('pinned'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        this._pinned = val;
                      });
                    },
                    value: this._pinned,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('snap'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        this._snap = val;
                        //Snapping only applies when the app bar is floating.
                        this._floating = this._floating || val;
                      });
                    },
                    value: this._snap,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('floating'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        this._floating = val;
                        if (this._snap == true) {
                          if (this._floating != true) {
                            this._snap = false;
                          }
                        }
                      });
                    },
                    value: this._floating,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: provider.isUserAdmin,
        child: FloatingActionButton(
          child: IconButton(
            /*icon: Icon(Icons.add_circle_outline),*/
            icon: Icon(Icons.add),
            iconSize: 40,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (AddArticleCategory()),
                ),
              );

              setState(() {});
            },
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  const MyBody({
    Key key,
    @required bool pinned,
    @required bool snap,
    @required bool floating,
  })  : _pinned = pinned,
        _snap = snap,
        _floating = floating,
        super(key: key);

  final bool _pinned;
  final bool _snap;
  final bool _floating;

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  bool isLogin() => FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<DataProvider>(context);
    AppUser user = userProvider.user;

    return FutureBuilder(
      future: Api("falishop").getCategoryCollection(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.menu, size: 40),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              pinned: this.widget._pinned,
              snap: this.widget._snap,
              floating: this.widget._floating,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                  title: const Text(" Fali Shop"),
                  background: Image.asset(
                    "assets/icons/fali_shop_1.png",
                    width: 50,
                    height: 50,
                    /*fit: BoxFit.cover*/
                  )
                  //FlutterLogo(),
                  ),
              actions: [
                user != null
                    ? IconButton(
                        iconSize: 40,
                        icon: Icon(
                          Icons.logout,
                          // color: Colors.white,
                        ),
                        onPressed: () async {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          await auth.signOut();

                          userProvider.setUser(null);
                          setState(() {});
                        },
                      )
                    : IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.login),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        }),
              ],
            ),
            if (snapshot.hasData)
              if (snapshot.data.docs.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      height: 2000,
                      child: Text(" No Data"),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var mapList = snapshot.data.docs
                            .map((e) => e.data() as Map<dynamic, dynamic>).toList();
                    if(mapList.isNotEmpty){
                      mapList.sort((a, b)=>a['name'].compareTo(b['name']));

                    }

                    var articleCategory =
                        ArticleCategory.fromMap(mapList[index], mapList[index]['id']);

                    return ArticleCategoryTile(
                        articleCategory: articleCategory);
                  }, childCount: snapshot.data.docs.length),
                )
            else
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    height: 200,
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: CircularProgressIndicator()),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
