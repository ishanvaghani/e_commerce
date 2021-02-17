import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_search.isEmpty)
            Center(
              child: Container(
                child: Text(
                  'Search Results',
                  style: Constants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder(
              future: _firebaseServices.productRef
                  .orderBy('search')
                  .startAt([_search]).endAt(['$_search\uf8ff']).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 108.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data.docs.map<Widget>((document) {
                      return ProductCard(
                        document: document,
                      );
                    }).toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    _search = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                ),
                style: Constants.regularDarkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
