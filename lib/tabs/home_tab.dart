import 'package:e_commerce/widgets/product_card.dart';
import '../services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productRef.get(),
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
          CustomActionBar(
            hasBackArrow: false,
            title: 'Home',
            hasTitle: true,
            hasBackground: true,
            hasCart: true,
          ),
        ],
      ),
    );
  }
}
