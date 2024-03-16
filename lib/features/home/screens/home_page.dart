import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:food_delivery_app/widget/Apptext.dart';
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
        latitude = 10.9916;
        longitude = 76.0103;
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
                if (response == null) // Show shimmer if response is null
                  _buildShimmerCategoryCards(size),
                if (response != null)
                  ...response!.shopCategories!.map((category) {
                    return buildCategoryCard(category, size);
                  }),





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





  Widget buildCategoryCard(String category, Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopsPage(
                  response: response,
                  title: category,
                  keyWord: category,
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
                    // Image or icon for the category
                  ),
                ),
                Align(
                    alignment: Alignment(-0.45, -0.4),
                    child: AppText(
                      text: category,
                      size: 16,
                      fw: FontWeight.w600,
                    )),
                Align(
                    alignment: Alignment(-0.18, 0.3),
                    child: AppText(
                      text: "Description for $category",
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
    );
  }

  Widget _buildShimmerCategoryCards(Size size) {
    List<Widget> shimmerCards = List.generate(
      3,
          (index) => Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 5,
            child: Container(
              height: size.height * 0.09,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.13,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Shimmer effect for the image or icon
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.015,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: size.width * 0.4,
                        height: size.height * 0.01,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Column(children: shimmerCards);
  }


}
