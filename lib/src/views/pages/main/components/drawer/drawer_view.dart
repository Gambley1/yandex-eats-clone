import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: context.screenWidth * 0.7,
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
          ...drawerOptions.map(
            (option) => ListTile(
              horizontalTitleGap: 0,
              onTap: getFunction(context, option),
              leading: CustomIcon(
                icon: getIcon(option),
                type: IconType.simpleIcon,
              ),
              title: KText(text: option),
            ),
          ),
        ],
      ).disalowIndicator(),
    );
  }
}
