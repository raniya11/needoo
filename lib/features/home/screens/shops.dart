import 'package:flutter/material.dart';
import 'package:food_delivery_app/Apptext.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/widgets/slidingbanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopsPage extends StatefulWidget {
  final ResponseModel? response;
  final String? title;
  final String?keyWord;
  const ShopsPage({Key? key, this.response, this.title,this.keyWord}) : super(key: key);

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  List<Merchants>? groceryMerchants;
  var locationCity;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      locationCity = _pref.getString('location');
    });
  }

  @override
  void initState() {
    super.initState();
    filterGroceryMerchants();
    getData();
  }

  void filterGroceryMerchants() {
    groceryMerchants = widget.response?.merchants
        ?.where((merchant) => merchant.categories?.contains("${widget.keyWord}") ?? false)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.response!.customerId);
    print(widget.response!.merchants);
    print(locationCity);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: size.height * 0.08,
        title: Align(
          alignment: Alignment(-0.4, 0),
          child: AppText(
            text: "${widget.title}",
            fw: FontWeight.w500,
            size: 18,
          ),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  cursorColor: Colors.grey.shade700,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey.shade700,
                    ),
                    hintText: "search item",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            SizedBox(height: size.height * 0.015),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.17,
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
            SizedBox(height: size.height*0.02,),
            groceryMerchants != null && groceryMerchants!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: groceryMerchants!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10),
                          child: Card(
                            elevation: 4,
                            child: Container(
                              height: size.height * 0.24,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: size.height * 0.164,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/img/Chicken_Nuggets.jpg"),
                                          fit: BoxFit.cover),
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          topLeft: Radius.circular(12)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 10, right: 10),
                                    child: AppText(
                                      text: groceryMerchants![index].name ?? "",
                                      size: 18,
                                      fw: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: "${locationCity ?? ""}",
                                          size: 12,
                                          fw: FontWeight.w400,
                                        ),
                                        AppText(
                                          text:
                                              "${groceryMerchants![index].distance!.toStringAsFixed(2)} Km",
                                          size: 12,
                                          fw: FontWeight.w400,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        'No  merchants found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
