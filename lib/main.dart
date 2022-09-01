import 'package:flutter/material.dart';
import 'package:booksparser/category_list.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case CategoriesList.routeName:
            return MaterialPageRoute(builder: (BuildContext context) {
              return const CategoriesList();
            });
        }
        return null;
      },
      home: const BookAppHomeScreen(),
    );
  }
}

class BookAppHomeScreen extends StatefulWidget {
  const BookAppHomeScreen({Key? key}) : super(key: key);

  @override
  State<BookAppHomeScreen> createState() => _BookAppHomeScreenState();
}

class _BookAppHomeScreenState extends State<BookAppHomeScreen> {

  void iniState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('По категориям'),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/category_list');
                },
              )
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
