import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:groceryuser/Controller/cart_controller.dart';

class FocusedMenuItemHolder extends StatelessWidget {
  final Widget child;
  final controller = CartController();
  final Function onPressed;
  final Function onAddToCartPressed;
  final Icon icon;
  FocusedMenuItemHolder({Key key, this.child, this.onPressed, this.icon, this.onAddToCartPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      child: child,
      menuItemExtent: 45,
      menuBoxDecoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      duration: Duration(milliseconds: 100),
      animateMenuItems: true,
      menuOffset: 10.0,
      bottomOffsetHeight: 80.0,
      blurBackgroundColor: Colors.black54,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            title: Text("Add To Cart"),
            trailingIcon: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),
            onPressed: onAddToCartPressed),
        FocusedMenuItem(
            title: Text("Favorite"), trailingIcon: icon, onPressed: onPressed),
      ],
    );
  }
}
