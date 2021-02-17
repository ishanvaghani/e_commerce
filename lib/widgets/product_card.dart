import 'package:e_commerce/screens/product_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductCard extends StatelessWidget {
  final document;

  ProductCard({this.document});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productId: document.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 350,
        margin: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: [
            Container(
              height: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  document.data()['images'][0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      document.data()['name'],
                      style: Constants.regularHeading,
                    ),
                    Text(
                      "\$${document.data()['price']}",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
