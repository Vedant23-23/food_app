import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_shop_app/components/colors.dart';
import 'package:flutter_e_commerce_shop_app/screens/account/account_page.dart';
import 'package:flutter_e_commerce_shop_app/screens/cart/cart_history.dart';
import 'package:flutter_e_commerce_shop_app/screens/home/home_page_body.dart';
import 'package:flutter_e_commerce_shop_app/screens/order/order_screen.dart';
import 'package:flutter_e_commerce_shop_app/screens/wishlist/wish_list_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex=0;
  List pages=[
    HomePageBody(),
    WishListScreen(),
    OrderScreen(),
    CartHistory(),
    AccountPage(),
  ];

  void onTap(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf9f9fa),
        body:pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: onTap,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
          label: "home"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),
              label: "fav"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.archive),
              label: "history"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
              label: "cart"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
              label: "profile"

          )
        ],
      ),

    );

  }
}
