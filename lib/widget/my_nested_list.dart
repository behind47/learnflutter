import 'package:flutter/material.dart';

class MyNestedList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyNestedListState();
  }
}

class MyNestedListState extends State<MyNestedList> {
  @override
  Widget build(BuildContext context) {
    Widget current = CustomScrollView(
      slivers: [
        KeyedSubtree(
            child: Container(
          child: Text('123'),
        ))
        // Container(
        //   height: 200,
        //   child: CustomScrollView(
        //     slivers: [
        // SliverList(
        //           delegate: SliverChildBuilderDelegate((context, int) {
        //         return Container(
        //           child: Text('345'),
        //         );
        //       }, childCount: 30))
        //     ],
        //   ),
        // ),
      ],
    );

    final List<String> _tabs = ['Tab 1', 'Tab 2'];
    Widget list2 = DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text('Books'),
                  pinned: true,
                  expandedHeight: 150.0,
                  bottom: TabBar(
                    tabs: _tabs.map((name) => Tab(text: name)).toList(),
                  ),
                ),
              )
            ],
            body: TabBarView(
                children: _tabs
                    .map(
                      (name) => SafeArea(
                          child: Builder(
                              builder: (context) => CustomScrollView(
                                    slivers: [
                                      SliverOverlapInjector(
                                          handle: NestedScrollView
                                              .sliverOverlapAbsorberHandleFor(
                                                  context)),
                                      SliverPadding(
                                        padding: const EdgeInsets.all(8.0),
                                        sliver: SliverFixedExtentList(
                                          itemExtent: 48.0,
                                          delegate: SliverChildBuilderDelegate(
                                              (BuildContext context,
                                                      int index) =>
                                                  ListTile(
                                                      title:
                                                          Text('Item $index')),
                                              childCount: 30),
                                        ),
                                      )
                                    ],
                                  ))),
                    )
                    .toList()),
          ),
        ));
    return list2;
  }
}
