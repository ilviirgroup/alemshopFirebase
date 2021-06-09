import 'dart:convert';

import 'package:alemshop/screens/subcategory/components/subcategory_grid_view.dart';
import 'package:alemshop/models/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../service.dart';

class SubCategory extends StatefulWidget {
  final int catId;
  final String genderFilter;
  SubCategory({this.catId, this.genderFilter = 'none'});

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  List<SubCategories> parseData(var response) {
    final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    return parsed
        .map<SubCategories>((json) => SubCategories.fromMap(json))
        .toList();
  }

  Future<List<SubCategories>> fetchData() async {
    http.Response res = await http
        .get(Uri.parse("http://alemshop.com.tm:8000/subcategory-list/"));
    if (res.statusCode == 200) {
      return parseData(res);
    } else
      throw Exception("Unable to fetch subcategories from server");
  }

  int subId;
  String categoryUrl;

  @override
  void initState() {
    super.initState();
  }

  void changeSub(int id) {
    setState(() {
      subId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final subCategoryProvider = Provider.of<Categories>(context);
    categoryUrl = 'http://alemshop.com.tm:8000/category-list/${widget.catId}';

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final subCategories = snapshot.data;
        List<GestureDetector> subCategoryList = [];
        for (var item in subCategories) {
          final category = item.category;
          final name = item.name;
          final id = item.id;

          if (category == categoryUrl) {
            if (subId == null) {
              subId = id;
            }
            final subCategoryitem = subcategoryButton(name: name, id: id);
            subCategoryList.add(subCategoryitem);
          }
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    itemCount: subCategoryList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => subCategoryList[i],
                  )),
            ),
            Expanded(
                child: SubCategoryGridView(
              subId: subId,
              gender: widget.genderFilter,
            ))
          ],
        );
      },
    );
  }

  Widget subcategoryButton({String name, int id}) {
    return GestureDetector(
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25),
          child: Text(
            name,
            style: TextStyle(color: Colors.blue, fontSize: 16.0),
          )),
      onTap: () {
        changeSub(id);
      },
    );
  }
}
