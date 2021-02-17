import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.userRef
                .doc(_firebaseServices.getUserId())
                .collection('Saved')
                .get(),
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
                    return FutureBuilder(
                      future:
                          _firebaseServices.productRef.doc(document.id).get(),
                      builder: (context, productSnap) {
                        if (productSnap.connectionState ==
                            ConnectionState.done) {
                          return ProductCard(
                            document: productSnap.data,
                          );
                        }
                        return SizedBox.shrink();
                      },
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
            title: 'Saved',
            hasTitle: true,
            hasBackground: true,
            hasCart: true,
          ),
        ],
      ),
    );
  }
}
