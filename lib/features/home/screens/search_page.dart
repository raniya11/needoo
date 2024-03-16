import 'package:flutter/material.dart';
import 'package:food_delivery_app/widget/Apptext.dart';
import 'package:food_delivery_app/core/model/location_data.dart';
import 'package:food_delivery_app/core/services/location_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  var locationCity;
  var subLocality;
  Position? position;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.08,
          title: AppText(
            text: "Search for your location",
            fw: FontWeight.w500,
            size: 18,
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10
                  ),
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    cursorColor: Colors.grey.shade700,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey.shade700,
                      ),

                      hintText: "Search your location",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height*0.01,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.my_location_rounded),
                  label: AppText(text: "Use current location",size: 16,),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,onPrimary: Colors.green,
                    elevation: 0
                  ),
                    onPressed: () async {
                      Provider.of<LocationProvider>(context, listen: false)
                          .determinePosition();

                      locationCity =
                          Provider.of<LocationProvider>(context, listen: false)
                              .currentLocationName!
                              .locality;
                      subLocality =
                          Provider.of<LocationProvider>(context, listen: false)
                              .currentLocationName!
                              .subLocality;
                      position =
                          Provider.of<LocationProvider>(context, listen: false)
                              .currentPostion;

                      Map<String, dynamic> data = {
                        "location": locationCity,
                        "sublocation": subLocality,
                        "lat": position!.latitude,
                        'long': position!.longitude
                      };
                      loationData.add(data);

                      SharedPreferences _pref =
                          await SharedPreferences.getInstance();

                      _pref.setString('location', locationCity);

                      print(data);

                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    },

                ),
              ),
              SizedBox(
                height: size.height*0.01,
              ),
              Divider(
                height: 1,
                thickness: 10,
                color: Colors.grey.shade200,
              ),
              SizedBox(height: size.height*0.02,),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: AppText(text: "Saved locations",color: Colors.black,),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: loationData.length,
                  itemBuilder: (context, index) {
                    final data = loationData[index];

                    return Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        return ListTile(
                          onTap: () {},
                          leading: Icon(Icons.location_on_outlined),
                          title: Text(data['location'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                          subtitle: Text(data['sublocation'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                        );
                      },
                    );
                  })
            ],
          ),
        ));
  }
}
