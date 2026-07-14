import 'package:flutter/material.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/banner_widget.dart';
import 'widgets/categories_widget.dart';
import 'widgets/restaurant_card.dart';
import 'widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        title: const Text(
          "البرق",
          style: TextStyle(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
  currentIndex: 0,
  onTap: (index) {},
),

     body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [

      SearchBarWidget(),
      SizedBox(height: 20),

BannerWidget(),

SizedBox(height: 25),
SizedBox(height: 20),

CategoriesWidget(),
SizedBox(height: 30),

Text(
  "أشهر المطاعم",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

SizedBox(height: 15),

RestaurantCard(
  name: "برجر هاوس",
  image: "assets/images/burger.jpg",
  delivery: "1000 د.ع",
  time: "20-30 دقيقة",
  rating: 4.8,
),

RestaurantCard(
  name: "بيتزا روما",
  image: "assets/images/pizza.jpg",
  delivery: "مجاني",
  time: "25 دقيقة",
  rating: 4.7,
),


SizedBox(height: 25),

      SizedBox(height: 25),

      Center(
        child: Text(
          "الصفحة الرئيسية",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    ],
  ),
),
    );
  }
}