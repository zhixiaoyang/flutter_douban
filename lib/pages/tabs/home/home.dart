import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  SolidController _controller;
  TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _controller = SolidController();
    _tabController = TabController(length: 2,vsync: this);
  }

  @override
  void dispose() { 
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solid bottom sheet example"),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        "Flutter rules?",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: SolidBottomSheet(
        controller: _controller,
        headerBar: Container(
          decoration: BoxDecoration(
            borderRadius:BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25)
            ),
            color: Theme.of(context).primaryColor,
          ),
          height: 60,
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: '影评'),
              Tab(text: '小组讨论'),
            ],
            onTap: (index){
              _controller.show();
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          height: 30,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Text('影评'),
              Text('小组讨论'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stars),
        onPressed: () {
          _controller.isOpened ? _controller.hide() : _controller.show();
        }
      ),
    );
  }
}