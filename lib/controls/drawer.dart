import 'package:dvt/controls/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerControl extends StatelessWidget {
  final Color? backgroundColor;
  final Icon? weatherIcon;
  final String? address;
  final String? weatherDescription;

  DrawerControl({super.key, this.backgroundColor, required this.weatherIcon, required this.address, required this.weatherDescription});

  @override
  Widget build(BuildContext context) {
    List<DrawerItems> drawerItems = [
      DrawerItems(
        icon: Icon(
          FontAwesomeIcons.solidHeart,
          color: backgroundColor,
          size: 30,
        ),
        itemName: TextControl(
          color: backgroundColor,
          text: 'Favourites',
        ),
        route: '/favorites',
      ),
      DrawerItems(
        icon: Icon(
          Icons.map,
          color: backgroundColor,
          size: 30,
        ),
        itemName: TextControl(
          color: backgroundColor,
          text: 'Map',
        ),
        route: '/google_map',
      ),
    ];
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: TextControl(
                          text: 'Close',
                          color: backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      // Container(
                      //   height: 60,
                      //   width: 60,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       fit: BoxFit.cover,
                      //       image: AssetImage('assets/images/profile_image.jpg'),
                      //     ),
                      //   ),
                      // ),
                      weatherIcon ?? Container(),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextControl(
                              text: weatherDescription,
                              size: TextProps.lg,
                              color: backgroundColor,
                            ),
                            TextControl(
                              text: 'in $address.',
                              size: TextProps.normal,
                              color: backgroundColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: drawerItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, item.route);
                      },
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          leading: item.icon,
                          title: item.itemName,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItems {
  final Icon icon;
  final TextControl itemName;
  final String route;

  DrawerItems({
    required this.icon,
    required this.itemName,
    required this.route,
  });
}
