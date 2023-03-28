import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/tabs_config.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const App()
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: Tabs.values.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: Tabs.values
                  .map((tab) => Tab(icon: tab.getIcon()))
                  .toList()
            ),
          ),
          body: TabBarView(
              children: Tabs.values.map((tab) => tab.getPage()).toList(),
  ),
        ));
  }
}
