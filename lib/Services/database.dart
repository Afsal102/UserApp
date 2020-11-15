import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Models/cart_model.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Models/user_model.dart';
import 'package:groceryuser/Models/wishlistmodel.dart';
import 'package:groceryuser/components/pincode.dart';
import 'package:groceryuser/components/snackbar.dart';
import 'package:groceryuser/main.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Database {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var logger = Logger();
  FirebaseDatabase database = FirebaseDatabase.instance;
  final _codeControler = TextEditingController();
  final CollectionReference reference =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference documentReferenceFavourites =
      FirebaseFirestore.instance.collection("Favourites");

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // var loginController = Get.put(LoginConroller());
//!signup with phone number
  Future createWithPhoneNumber(
      String phonenumber,
      String firstname,
      String lastname,
      pno,
      String countrycode,
      String countryname,
      LoginConroller conroller) async {
    conroller.showLoading.value = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: phonenumber.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) {
        _auth.signInWithCredential(phoneAuthCredential).then((value) {
          if (Get.isDialogOpen) Get.back();
          if (value.user != null) {
            conroller.showLoading.value = false;
            logger.i(value.user.phoneNumber);
            Get.offAll(Wrapper());
          } else
            logger.e('From VC user is null');
          conroller.showLoading.value = false;
        });
      },
      verificationFailed: (error) {
        logger.i(error.message.toString());
      },
      codeSent: (verificationId, forceResendingToken) {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            height: Get.context.size.height / 2 * 0.5,
            width: Get.context.size.width / 2,
            // clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
              children: [
                PinCode(
                  onCompleted: (value) async {
                    print('Completed from main');
                    print(_codeControler.text.toString());
                    final code = _codeControler.text.trim();
                    AuthCredential authCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: code);
                    await _auth
                        .signInWithCredential(authCredential)
                        .then((value) async {
                      if (value.user != null) {
                        logger.i(value.user.phoneNumber);
                        conroller.showLoading.value = false;
                        UserModel userModel = new UserModel(
                            id: value.user.uid,
                            firstName: firstname,
                            lastName: lastname,
                            countryCode: countrycode,
                            phoneNumber: pno,
                            registeredDate: DateFormat.yMd() //!Date ZFormnat
                                .format(DateTime.now())
                                .toString(),
                            registeredTime: DateFormat.jms() //!tme formnat
                                .format(DateTime.now())
                                .toString(),
                            registeredWithPhone: true,
                            countryName: countryname);
                        //!adding to user table
                        if (await Database()
                            .addUserToDatabase(value.user, userModel)) {
                          conroller.showLoading.value = false;
                          logger.i('User Creadted and added to database');

                          Get.offAll(Wrapper());
                        } else {
                          logger.e('Failed To upload to database');
                          conroller.showLoading.value = false;
                        }
                      } else {
                        logger.e('User cannot be logged in ');
                        conroller.showLoading.value = false;
                      }
                    }).catchError((onError) {
                      conroller.showLoading.value = false;
                      logger.e(onError.toString());
                    });
                  },
                  controller: _codeControler,
                ),
              ],
            ),
          ),
          isDismissible: false,
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationId = verificationId;
        conroller.showLoading.value = false;
        print(verificationId);
        print('Time Out');
      },
    );
  }
  //!login with phone number

  Future loginWithPhoneNumber(String phoenumber, LoginConroller conroller,
      double width, double height) async {
    conroller.loginShowLoading.value = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoenumber.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) {
        _auth.signInWithCredential(phoneAuthCredential).then((value) {
          if (Get.isDialogOpen) Get.back();
          if (value.user != null) {
            logger.i(value.user.phoneNumber);
            conroller.loginShowLoading.value = false;
            Get.off(Wrapper());
          } else
            logger.e('From VC user is null');
        });
      },
      verificationFailed: (error) {
        conroller.loginShowLoading.value = false;
        SnackBars().showSnackBar(
            'Some Error Occured ${error.message.toString()}', null);
        logger.i(error.message.toString());
      },
      codeSent: (verificationId, forceResendingToken) {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            height: height,
            width: width,
            // clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
              children: [
                PinCode(
                  onCompleted: (value) async {
                    print('Completed from main');
                    print(_codeControler.text.toString());
                    final code = _codeControler.text.trim();
                    AuthCredential authCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: code);
                    await _auth
                        .signInWithCredential(authCredential)
                        .then((value) {
                      if (value.user != null) {
                        logger.i(value.user.phoneNumber);
                        conroller.loginShowLoading.value = false;
                        Get.offAll(Wrapper());
                      } else {
                        logger.e('User cannot be logged in ');
                        conroller.loginShowLoading.value = false;
                      }
                    }).catchError((onError) {
                      logger.e(onError.toString());
                      SnackBars().showSnackBar('Invalid Credential', null);
                    });
                  },
                  controller: _codeControler,
                ),
              ],
            ),
          ),
          isDismissible: false,
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationId = verificationId;
        print(verificationId);
        conroller.loginShowLoading.value = false;
        Get.back();

        print('Time Out');
      },
    );
  }
  //!List of jsoin to product models

  List<ProductModel> _listfromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return ProductModel(
        prodName: doc.data()['prodName'] ?? '',
        prodId: doc.data()['prodId'] ?? '',
        prodPrice: doc.data()['prodPrice'] ?? '',
        availableQty: doc.data()['availableQty'] ?? '',
        weight: doc.data()['weight'] ?? '',
        imageLink: doc.data()['imageLink'] ?? '',
        uploadDate: doc.data()['uploadDate'] ?? '',
      );
    }).toList();
  }
  //!json to wishlist from snapshot

  List<WishListModel> _wishListFromSnap(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return WishListModel(
        wishId: doc.data()['wishId'] ?? '',
        prodId: doc.data()['prodId'] ?? '',
        addedTime: doc.data()['addedTime'] ?? '',
        userId: doc.data()['userId'] ?? '',
        addeddate: doc.data()['addeddate'] ?? '',
      );
    }).toList();
  }

//!SignOut+
  Future signOut() async {
    logger.i('LoggngOut');
    await _auth.signOut();
    Get.off(Wrapper());
  }

  //!addin user data to database
  Future<bool> addUserToDatabase(User user, UserModel userModel) async {
    bool data = false;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toMap())
        .then((value) {
      logger.i('Added User To Database');
      data = true;
    }).catchError((onError) {
      logger.e(onError.toString());
      data = false;
    });
    return data;
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //!user query for phone number
  Future<bool> searchIfUserExists(String phonenumber) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where('phoneNumber', isEqualTo: phonenumber)
        .where('registeredWithPhone', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty)
      return true;
    else
      return false;
  }

  //!wishList Query
  Future<QuerySnapshot> getWishList(String prodId, String userId) async {
    return await FirebaseFirestore.instance
        .collection('Favourites')
        .where('userId', isEqualTo: userId)
        .where('prodId', isEqualTo: prodId)
        .get();
  }

  //!Delte from wish List
  Future deleteFromWishList(String wishId) async {
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(wishId)
        .delete()
        .whenComplete(() {
      Get.snackbar('Removed', 'Removed From Wish List',
          backgroundColor: Colors.blueGrey[900], colorText: Colors.white);
    });
  }

  //!All products Stream
  Stream<List<ProductModel>> get productsStream {
    return reference.snapshots().map(_listfromSnap);
  }

  //!Favourites Stream
  Stream<List<WishListModel>> get favouritesStream {
    return documentReferenceFavourites.snapshots().map(_wishListFromSnap);
  }
  //!Adding to wish list

  Future<bool> addFavourites(ProductModel productModel, String userId) async {
    bool data = false;
    DatabaseReference dbref = database.reference();
    //!Used realtime database to gennerate psuh id
    String pushKey = dbref.push().key;
    WishListModel wishListModel = new WishListModel(
        wishId: pushKey,
        userId: userId,
        prodId: productModel.prodId,
        addedTime: DateFormat.jms().format(DateTime.now()).toString(),
        addeddate: DateFormat.yMd().format(DateTime.now()).toString());

    await firebaseFirestore
        .collection('Favourites')
        .doc(pushKey)
        .set(wishListModel.toMap())
        .then((value) {
      data = true;
      productModel.wishId.value = pushKey;
      logger.i('Success');
    }).catchError((onError) {
      data = false;
      logger.i(onError.toString());
    });
    return data;
  }

  // Stream  get af{
  //   return firebaseFirestore.collection('Fucked').doc('afsal').collection('afzal').snapshots().map(_wishListFromSnap)
  // }

  //!Add To Cart
  Future addtoCart(ProductModel productModel) async {
    DatabaseReference dbref = database.reference();
    //!Used realtime database to gennerate psuh id
    String pushKey = dbref.push().key;
    CartModel model = new CartModel(
        id: pushKey,
        prodId: productModel.prodId,
        userId: Get.find<LoginConroller>().user.uid,
        date: DateFormat.yMd().format(DateTime.now()).toString(),
        time: DateFormat.yMd().format(DateTime.now()).toString(),
        prodQuantity: 1);
    await querycart(productModel).then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          await updatecart(element.id, model);
        });
      } else {
        FirebaseFirestore.instance
            .collection('Cart')
            .doc(pushKey)
            .set(model.toMap())
            .then((value) {
          Get.snackbar('', 'Added Item To Cart');
        });
      }
    });
  }

//!query Cart to find al items with giver
  Future<QuerySnapshot> querycart(ProductModel productModel) async {
    return FirebaseFirestore.instance
        .collection('Cart')
        .where('userId', isEqualTo: Get.find<LoginConroller>().user.uid)
        .where('prodId', isEqualTo: productModel.prodId)
        .get();
  }
  //!query specific cart itme

  Future updatecart(String docid, CartModel model) async {
    await FirebaseFirestore.instance.collection('Cart').doc(docid).update({
      'prodQuantity': model.prodQuantity,
      'date': DateFormat.yMd().format(DateTime.now()).toString(),
      'time': DateFormat.jms().format(DateTime.now()).toString()
    });
  }

  //!cart Stream
  Stream<List<CartModel>> get cartstream {
    return FirebaseFirestore.instance
        .collection('Cart')
        .snapshots()
        .map(_cartMapToModel);
  }

  //!conver map to models
  List<CartModel> _cartMapToModel(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return CartModel(
        id: e.data()['id'] ?? '',
        date: e.data()['date'] ?? '',
        prodId: e.data()['prodId'] ?? '',
        prodQuantity: e.data()['prodQuantity'] ?? 1,
        time: e.data()['time'] ?? '',
        userId: e.data()['userId'] ?? '',
      );
    }).toList();
  }
}
