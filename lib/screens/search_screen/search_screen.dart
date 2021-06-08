import 'package:alemshop/screens/search_screen/components/search_list_view.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  String searchTx;
  @override
  void initState() {
    super.initState();
    searchController.text = searchTx;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchTx = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  contentPadding: EdgeInsets.only(left: 15, top: 15.0),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.blue,
                  )),
            ),
          ),
        ),
        Expanded(
            child: SearchListView(
          name: searchTx,
        ))
      ],
    ));
  }
}
