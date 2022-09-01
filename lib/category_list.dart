import 'package:flutter/material.dart';
import 'package:booksparser/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesList extends StatefulWidget {
  static const routeName = '/category_list';
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

  late Future<CategoryList> categoryList;
  @override
  void initState() {
    super.initState();
    categoryList = getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('По категориями'),
      ),
      body: FutureBuilder<CategoryList>(
        future: getCategoryList(),
        builder: (BuildContext context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.waiting : return const Center(child: CircularProgressIndicator());
            case ConnectionState.done :    return ListView.builder(
                itemCount: snapshot.data?.eBOOKAPP?.length,
                  itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      title: Text('${snapshot.data?.eBOOKAPP?[index].categoryName}'),
                      subtitle: Text('Total books ${snapshot.data?.eBOOKAPP?[index].totalBooks}'),
                      isThreeLine: true,
                    ),
                  );
                  });
            case ConnectionState.none : return const Text('Нет подключения');
          }
          // if (snapshot.hasData){
          //   return ListView.builder(
          //       itemCount: snapshot.data?.eBOOKAPP?.length,
          //       itemBuilder: (context, index){
          //         return Card(
          //           child: ListTile(
          //             title: Text('${snapshot.data?.eBOOKAPP?[index].categoryName}'),
          //             subtitle: Text('${snapshot.data?.eBOOKAPP?[index].totalBooks}'),
          //             isThreeLine: true,
          //           ),
          //         );
          //       });
          // } else {
          //   return Center(child: Text('Данные не найдены'),);
          // }
          return const Text("data");
        },
      ),
    );
  }
}
//
// class CategoryList {
//   List<Category> categories;
//   CategoryList({required this.categories});
//
//   factory CategoryList.fromJson(Map<String, dynamic> json ){
//
//     var categoryListJson = json['EBOOK_APP'] as List;
//     List<Category> categoryList = categoryListJson.map((e) => Category.fromJson(e)).toList();
//
//     return CategoryList(categories: categoryList);
//   }
// }
//
// class Category {
//   final String name;
//   final int cid;
//   final int totalBooks;
//
//   Category({required this.name, required this.cid, required this.totalBooks});
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       name: json['name'] as String,
//       cid: json['cid'] as int,
//       totalBooks: json['total_books'] as int,
//     );
//   }
// }
//=========================================================================================

class CategoryList {
  List<EBOOKAPP>? eBOOKAPP;

  CategoryList({this.eBOOKAPP});

  CategoryList.fromJson(Map<String, dynamic> json) {
    if (json['EBOOK_APP'] != null) {
      eBOOKAPP = <EBOOKAPP>[];
      json['EBOOK_APP'].forEach((v) {
        eBOOKAPP!.add(EBOOKAPP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eBOOKAPP != null) {
      data['EBOOK_APP'] = eBOOKAPP!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EBOOKAPP {
  String? cid;
  String? categoryName;
  String? totalBooks;

  EBOOKAPP({this.cid, this.categoryName, this.totalBooks});

  EBOOKAPP.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    categoryName = json['category_name'];
    totalBooks = json['total_books'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cid'] = cid;
    data['category_name'] = categoryName;
    data['total_books'] = totalBooks;
    return data;
  }
}


Future<CategoryList> getCategoryList() async{
  final response = await http.get(Uri.parse(Urls.catList));

  if  (response.statusCode == 200){
    return CategoryList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error ${response.reasonPhrase}');
  }
}