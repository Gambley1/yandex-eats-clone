enum AppRoutes {
  restaurants('/restaurants'),
  auth('/auth'),
  cart('/cart'),
  profile('/profile'),
  orders('/orders'),
  order('/order'),
  notifications('/notifications'),
  searchLocation('/search_location'),
  search('/search'),
  googleMap('/google_map'),
  updateEmail('/update_email'),
  menu('/menu');

  const AppRoutes(this.route);

  final String route;
}
