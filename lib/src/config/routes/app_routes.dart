enum AppRoutes {
  restaurants('/restaurants'),
  login('/login'),
  signUp('/sign_up'),
  cart('/cart'),
  profile('/profile'),
  orders('/orders'),
  orderDetails('/order_details'),
  notifications('/notifications'),
  searchLocation('/search_location'),
  search('/search'),
  googleMap('/google_map'),
  menu('/menu');

  const AppRoutes(this.route);

  final String route;
}
