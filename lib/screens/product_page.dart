import 'package:e_commerce/constants.dart';
import 'package:e_commerce/services/firebase_services.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/image_swipe.dart';
import 'package:e_commerce/widgets/product_size.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize = '0';
  bool _isSaved = false;
  GlobalKey<ScaffoldState> _scaffolKey = GlobalKey();

  Future _addToCart() {
    return _firebaseServices.userRef
        .doc(_firebaseServices.getUserId())
        .collection('Cart')
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  Future _addToSave() {
    return _firebaseServices.userRef
        .doc(_firebaseServices.getUserId())
        .collection('Saved')
        .doc(widget.productId)
        .set({widget.productId: true});
  }

  Future _removeFromSave() {
    return _firebaseServices.userRef
        .doc(_firebaseServices.getUserId())
        .collection('Saved')
        .doc(widget.productId)
        .delete();
  }

  final SnackBar _snackBarCart = SnackBar(
    content: Text('Product Added to cart'),
  );

  final SnackBar _snackBarSaved = SnackBar(
    content: Text('Product Added to saved'),
  );

  final SnackBar _snackBarRemoved = SnackBar(
    content: Text('Product Removed from saved'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData = snapshot.data.data();
                List imageList = documentData['images'];
                List productSizes = documentData['size'];
                _selectedProductSize = productSizes[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        documentData['name'],
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\$${documentData['price']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        documentData['desc'],
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        'Select Size',
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (_isSaved) {
                                await _removeFromSave();
                                _scaffolKey.currentState.hideCurrentSnackBar();
                                _scaffolKey.currentState
                                    .showSnackBar(_snackBarRemoved);
                              } else {
                                await _addToSave();
                                _scaffolKey.currentState.hideCurrentSnackBar();
                                _scaffolKey.currentState
                                    .showSnackBar(_snackBarSaved);
                              }
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: StreamBuilder(
                                stream: _firebaseServices.userRef
                                    .doc(_firebaseServices.getUserId())
                                    .collection('Saved')
                                    .snapshots(),
                                builder: (context, productSnap) {
                                  List _documents = [];

                                  if (productSnap.connectionState ==
                                      ConnectionState.active) {
                                    _documents = productSnap.data.docs;
                                    for (var doc in _documents) {
                                      if (doc.id == widget.productId) {
                                        _isSaved = true;
                                        break;
                                      } else {
                                        _isSaved = false;
                                      }
                                    }
                                  }
                                  if (_isSaved)
                                    return Image.asset(
                                      'assets/images/tab_saved_two.png',
                                      height: 30.0,
                                    );
                                  else
                                    return Image.asset(
                                      'assets/images/tab_saved.png',
                                      height: 22.0,
                                    );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                _scaffolKey.currentState.hideCurrentSnackBar();
                                _scaffolKey.currentState
                                    .showSnackBar(_snackBarCart);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(left: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: true,
            hasCart: true,
          ),
        ],
      ),
    );
  }
}
