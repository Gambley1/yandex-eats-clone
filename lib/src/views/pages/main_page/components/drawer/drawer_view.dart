import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Colors.white,
      width: width * 0.7,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                const KText(
                  text: 'Papa',
                  size: 28,
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      scale: 1,
                      image: AssetImage(
                        'assets/images/PapaBurgerLogo.jpg',
                      ),
                    ),
                  ),
                ),
                const KText(
                  text: 'Burger',
                  size: 28,
                ),
              ],
            ),
          ),
          ...listHeaderNames.map(
            (name) => ListTile(
              horizontalTitleGap: 0,
              onTap: getFunction(context, name),
              leading: CustomIcon(
                icon: getIcon(name),
                type: IconType.simpleIcon,
              ),
              title: KText(text: name),
            ),
          ),
        ],
      ).disalowIndicator(),
    );
  }
}
