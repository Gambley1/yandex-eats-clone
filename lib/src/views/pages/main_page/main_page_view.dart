import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/restaurant.dart';

final _globalBucket = PageStorageBucket();

class MainPageView extends StatelessWidget {
  const MainPageView({
    super.key,
  });

  _bottomNavigationBar(BuildContext context) {
    final cubit = context.read<NavigationCubit>();
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: kPrimaryColor,
        backgroundColor: Colors.white,
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.getFont(
            'Quicksand',
            textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
      child: NavigationBar(
        animationDuration: const Duration(
          microseconds: 500,
        ),
        selectedIndex: cubit.state.currentIndex,
        onDestinationSelected: (value) {
          cubit.navigation(value);
          if (cubit.state.currentIndex == 3) {
            Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: const CartView(),
                  type: PageTransitionType.fade,
                ),
                (route) => true);
          }
        },
        height: 60,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.house,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: Icon(
              FontAwesomeIcons.house,
              size: 21,
              color: Colors.black,
            ),
            label: 'Main',
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.burger,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: Icon(
              FontAwesomeIcons.burger,
              size: 21,
              color: Colors.black,
            ),
            label: 'Restaurants',
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.listUl,
              size: 20,
              color: Colors.grey,
            ),
            selectedIcon: Icon(
              FontAwesomeIcons.listUl,
              size: 21,
              color: Colors.black,
            ),
            label: 'Order List',
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.basketShopping,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: Icon(
              FontAwesomeIcons.basketShopping,
              size: 21,
              color: Colors.black,
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  _buildLoading() => const CustomCircularIndicator(
        color: Colors.black,
      );

  _buildFailureResponse(BuildContext context) {
    void tryAgain() {
      context.read<MainPageBloc>().add(LoadMainPageEvent());
    }

    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const KText(
            text: 'Error occured.',
            size: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 12,
          ),
          OutlinedButton(
            onPressed: () {
              tryAgain();
            },
            child: const KText(text: 'Try again'),
          ),
        ],
      ),
    );
  }

  _buildMainPage(
    BuildContext context,
  ) {
    void tryAgain() {
      context.read<MainPageBloc>().add(LoadMainPageEvent());
    }

    final cubit = context.read<NavigationCubit>();

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _releaseFocus(context),
          child: Scaffold(
              extendBody: true,
              bottomNavigationBar: _bottomNavigationBar(context),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    switch (cubit.state.currentIndex) {
                      case 0:
                        return BlocConsumer<MainPageBloc, MainPageState>(
                          listenWhen: (previous, current) =>
                              previous.mainPageRequest !=
                              current.mainPageRequest,
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state.mainPageRequest ==
                                MainPageRequest.mainPageLoading) {
                              _buildLoading();
                            } else if (state.mainPageRequest ==
                                MainPageRequest.filterRequestSuccess) {
                              return RestaurantsFilteredView(
                                filteredRestaurants: state.filteredRestaurants,
                              );
                            } else if (state.mainPageRequest ==
                                MainPageRequest.mainPageFailure) {
                              _buildFailureResponse(context);
                            } else if (state.mainPageRequest ==
                                MainPageRequest.requestSuccess) {
                              return MainPageBody(
                                restaurants: state.restaurants,
                              );
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const KText(
                                    text: 'Something went wrong.',
                                    size: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      tryAgain();
                                    },
                                    child: const KText(text: 'Try again'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      case 1:
                        return const RestaurantView();
                      case 2:
                        return const OrdersView();
                    }
                    return Container();
                  },
                ),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      key: const PageStorageKey<String>('main_page_key'),
      bucket: _globalBucket,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: MyThemeData.globalThemeData,
        child: Builder(
          builder: (context) => _buildMainPage(context),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}
