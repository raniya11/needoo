import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:food_delivery_app/Apptext.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/services/location_provider.dart';
import 'package:food_delivery_app/core/widgets/category_container.dart';
import 'package:food_delivery_app/core/widgets/slidingbanner.dart';
import 'package:food_delivery_app/features/home/screens/search_page.dart';
import 'package:food_delivery_app/features/home/screens/shops.dart';
import 'package:food_delivery_app/features/home/services/merchant_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  var locationCity;
  var subLocality;
  Position? position;
  ResponseModel? response;
  bool isLoading = true;

  @override
  void initState() {
    Provider.of<LocationProvider>(context, listen: false).determinePosition();

    Future.delayed(Duration(seconds: 2), () {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    var latitude;
    var longitude;
    try {
      final phoneNumber = '9785641253';
      setState(() {
        latitude = position!.latitude;
        longitude = position!.longitude;
      });

      final fetchedResponse =
          await ProductService.fetchProducts(phoneNumber, latitude, longitude);

      setState(() {
        response = fetchedResponse;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child:
              // isLoading
              //     ? _buildShimmerEffect(size):

              SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) {
                  if (locationProvider.currentLocationName != null) {
                    locationCity =
                        locationProvider.currentLocationName!.locality;
                    subLocality =
                        locationProvider.currentLocationName!.subLocality;

                    position = locationProvider.currentPostion;
                  } else {
                    locationCity = "Select Location";
                    subLocality = "";
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchLocationPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "${locationCity}",
                                fw: FontWeight.w500,
                              ),
                              AppText(
                                text: "${subLocality}",
                                color: Colors.black38,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: AppText(
                    text: "You will get on your doorstep!",
                    size: 18,
                    fw: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: InkWell(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopsPage(
                                response: response,
                                title: "Groceries",
                                keyWord: "Grocery",
                              )));

                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: size.height * 0.09,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.92, 0),
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width * 0.13,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image(
                                  image: AssetImage("assets/img/groceries.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment(-0.45, -0.4),
                                child: AppText(
                                  text: "Groceries",
                                  size: 16,
                                  fw: FontWeight.w600,
                                )),
                            Align(
                                alignment: Alignment(-0.18, 0.3),
                                child: AppText(
                                  text: "Groceries and Vegetables",
                                  size: 14,
                                  fw: FontWeight.w400,
                                  color: Colors.black38,
                                )),
                            Align(
                              alignment: Alignment(0.98, 0),
                              child: Container(
                                  height: size.height * 0.04,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShopsPage(
                                  response: response,
                                  title: "Fish & Meat",
                                  keyWord: "Fish",
                                ))),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: size.height * 0.09,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.92, 0),
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width * 0.13,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image(
                                  image: AssetImage("assets/img/fish.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment(-0.35, -0.4),
                                child: AppText(
                                  text: "Fish and Meat",
                                  size: 16,
                                  fw: FontWeight.w600,
                                )),
                            Align(
                                alignment: Alignment(-0.12, 0.3),
                                child: AppText(
                                  text: "Fresh fish, chicken, meat...",
                                  size: 14,
                                  fw: FontWeight.w400,
                                  color: Colors.black38,
                                )),
                            Align(
                              alignment: Alignment(0.98, 0),
                              child: Container(
                                  height: size.height * 0.04,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShopsPage(
                                  response: response,
                                  title: "Bakes & Food",
                                ))),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: size.height * 0.09,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.92, 0),
                              child: Container(
                                height: size.height * 0.06,
                                width: size.width * 0.13,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image(
                                  image: AssetImage("assets/img/burger.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment(-0.36, -0.4),
                                child: AppText(
                                  text: "Bakes & Food",
                                  size: 16,
                                  fw: FontWeight.w600,
                                )),
                            Align(
                                alignment: Alignment(-0.12, 0.3),
                                child: AppText(
                                  text: "Get delicious bakes & food",
                                  size: 14,
                                  fw: FontWeight.w400,
                                  color: Colors.black38,
                                )),
                            Align(
                              alignment: Alignment(0.98, 0),
                              child: Container(
                                  height: size.height * 0.04,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.19,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: [
                          sliding_banner(),
                          sliding_banner(),
                          sliding_banner(),
                          sliding_banner(),
                          sliding_banner(),
                          sliding_banner(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              width: size.width * 0.02,
                              height: size.height * 0.01,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.green
                                    : Colors.green.shade200,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: AppText(
                    text: "Shop by categories",
                    size: 18,
                    fw: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Category_container(),
                      Category_container(),
                      Category_container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(Size size) {
    return Column(
      children: [
        // Shimmer effect for location widget
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 15),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.green,
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.4, // Adjust the width as needed
                      height: size.height * 0.02,
                      color: Colors.white, // Same as your background color
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      width: size.width * 0.2, // Adjust the width as needed
                      height: size.height * 0.01,
                      color: Colors.white, // Same as your background color
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        // Other shimmer effects for remaining widgets...
      ],
    );
  }
}
