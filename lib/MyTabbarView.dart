import 'package:flutter/material.dart';

/// 这个例子是一个 NestedScrollView，它的header是一个TabBar，包含SliverAppBar，它的body是tabBarView
/// 它使用一对 (SliverOverlapAbsorber, SliverOverlapInjector) 来使 inner列表正确对齐
/// 它使用SafeArea来防止任何水平方向上的扰动
/// PageStorageKey被用来记录每个 tab 的 list 的 scroll position
class MyTabBarView extends StatelessWidget {
  final List tabs = ['car', 'transit', 'bike'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          // 在outer的scrollview出现的slivers
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverOverlapAbsorber(
              /**
               * This widget 接受 SliverAppBar的部分重叠行为，并将其指向它的子孙SliverOverlapInjector.
               * 如果它消失了，可能会导致inner的scrollview终结，即使在inner的scrollview认为他没有滚动的时候。
               * 如果headerSliverBuilder构建的widgets没有覆盖下一个sliver，则This Widget是不必要的。
               */
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'),
                /**
                 * 一个pinned的 SliverAppBar在NestedScrollView中就像在另一个scroll view中一样
                 * app bar在用户滚动时会伸缩，但是在scroll view的顶部始终保持可见
                 */
                // pinned: true,
                /**
                 * 
                 */
                floating: true,
                snap: true,
                expandedHeight: 150.0,
                /**
                 * forceElevated 让SliverAppBar显示一个阴影。
                 * innerBoxIsScrolled参数是true，则inner scrollview可以滚到它的零点外，也就是滚到SliverAppBar下面去
                 * 没有这个属性，则偶尔会有阴影显示异常，因为SliverAppBar实际上不知道inner scrollview的精确位置。
                 */
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: tabs.map((e) => Text(e)).toList(),
                ),
              ),
            )
          ],
          body: TabBarView(
            children: tabs
                .map(
                  (e) => SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      /**
                       * Builder需要一个inside the NestedScrollView的BuildContext，
                       * 以便 sliverOverlapAbsorberHandleFor() 能找到NestedScrollView
                       */
                      builder: (context) => CustomScrollView(
                        /**
                         * controller 和 primary 成员需要被 unset，以便 NestedScrollView 可以控制这个 inner scroll view
                         * 如果 controller 被 set 了，那么scroll view将与 NestedScrollView断开联系
                         * PageStorageKey 对于ScrollView应该是唯一的，当tab view不再屏幕上的时候，它让列表记住它的 scroll position
                         */
                        key: PageStorageKey<String>(e),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            // 这是上面的 SliverOverlapAbsorber 的反面
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(8.0),
                            /**
                             * 在这个例子中，inner scroll view有固定高度的列表项，因此使用SliverFixedExtentList
                             * 然而，一个scroll view可以在这里使用任何sliver widget，比如SliverList或者SliverGrid
                             */
                            sliver: SliverFixedExtentList(
                              // 这个例子中的items的高度固定为48pixels，符合Material Design 为 ListTile widgets 设定的规格
                              itemExtent: 48.0,
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => ListTile(
                                        title: Text('Item $index'),
                                      ),
                                  /**
                                   * SliverChildBuilderDelegate的子元素数量决定了 inner列表 有多少子元素
                                   * 这个例子中，每个tab有一个30个列表项的列表
                                   */
                                  childCount: 30),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class MyTabBarView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
        body: const TabBarView(children: [
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike)
        ]),
      ),
    );
  }
}
