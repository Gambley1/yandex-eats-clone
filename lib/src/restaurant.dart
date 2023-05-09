//custom widgets
export 'views/widgets/app_input_text.dart';
export 'views/widgets/discount_price.dart';
export 'views/widgets/shimmer_loading.dart';
export 'views/widgets/cached_image.dart';
export 'views/widgets/custom_button_in_show_dialog.dart';
export 'views/widgets/custom_icon.dart';
export 'views/widgets/custom_circular_indicator.dart';
export 'views/widgets/k_text.dart';
export 'views/widgets/expanded_elevated_button.dart';
export 'views/widgets/custom_scaffold.dart';
export 'views/widgets/show_custom_dialog.dart';
export 'views/widgets/dot_separator.dart';
export 'views/widgets/separator_builder.dart';

//cart components
export 'views/pages/cart/components/cart_items_list_view.dart';
//services
export 'views/pages/cart/services/cart_service.dart';
//state
export 'views/pages/cart/state/cart_bloc.dart';
export 'views/pages/cart/state/cart_state.dart';
//cart view
export 'views/pages/cart/cart_view.dart';

//login components
export 'views/pages/login/components/show_password_controller/show_password_cubit.dart';
export 'views/pages/login/components/login_fillers/forgot_password_view.dart';
export 'views/pages/login/components/login_fillers/login_footer.dart';
export 'views/pages/login/components/login_fillers/login_form.dart';
export 'views/pages/login/components/login_fillers/login_image.dart';
export 'views/pages/login/components/login_fillers/login_with_google_and_facebook.dart';
//state
export 'views/pages/login/state/login_cubit.dart';
//login view
export 'views/pages/login/login_view.dart';

//view
export 'views/pages/main_page/main_page.dart';
//search
export 'views/pages/main_page/components/search/search_view.dart';
export 'views/pages/main_page/components/search/search_bar.dart';
//header
export 'views/pages/main_page/components/header/header_view.dart';
//menu
export 'views/pages/main_page/components/menu/menu_view.dart';
export 'views/pages/main_page/components/menu/components/discount_card.dart';
export 'views/pages/main_page/components/menu/components/menu_section_header.dart';
export 'views/pages/main_page/components/menu/components/menu_item_card.dart';
//services
export 'views/pages/main_page/services/location_service.dart';
export 'views/pages/main_page/services/main_page_service.dart';
export 'views/pages/main_page/services/restaurant_service.dart';
//location
export 'views/pages/main_page/components/location/search_location_with_autocomplete.dart';
export 'views/pages/main_page/components/location/google_map_view.dart';
export 'views/pages/main_page/components/location/helper/location_helper.dart';
//restaurant
export 'views/pages/main_page/components/restaurant/google_restaurants_list_view.dart';
export 'views/pages/main_page/components/restaurant/restaurants_filtered_view.dart';
export 'views/pages/main_page/components/categories_slider.dart';
export 'views/pages/main_page/components/main_page_body.dart';
//main page state
export 'views/pages/main_page/state/main_bloc.dart';
export 'views/pages/main_page/state/search_result.dart';
export 'views/pages/main_page/state/search_bloc.dart';
export 'views/pages/main_page/state/location_result.dart';
export 'views/pages/main_page/state/location_bloc.dart';
export 'views/pages/main_page/state/address_result.dart';
//navigation state
export 'views/pages/main_page/navigation_state/navigation_cubit.dart';
export 'views/pages/main_page/navigation_state/navigation_state.dart';
export 'views/pages/main_page/navigation_state/navigation_bloc.dart';

//orders view
export 'views/pages/orders/orders_view.dart';

//register view
export 'views/pages/register/register_view.dart';

//restaurant view
export 'views/pages/restaurants/restaurant_view.dart';
//components
export 'views/pages/restaurants/components/info_view.dart';

//splash view
export 'views/pages/splash/splash_view.dart';

//config
export 'config/utils/app_colors.dart';
export 'config/utils/app_page_storage_key.dart';
export 'config/utils/my_theme_data.dart';
export 'config/utils/app_constants.dart';
export 'config/utils/app_strings.dart';
export 'config/utils/app_routes.dart';
export 'config/theme/theme.dart';
export 'config/routes/routes.dart';
export 'config/animations/fade_animation.dart';

//fake data
export 'data/logger.dart';
export 'data/restaurant_fake_data.dart';

//extensions
export 'config/extensions/disalow_indicator_extension.dart';
export 'config/extensions/trimmed_converted_string_contains_extension.dart';
export 'config/extensions/will_pop_scope_extension.dart';
export 'config/extensions/ignore_pointer_extension.dart';
export 'config/extensions/navigator_extension.dart';

//form fields
export 'models/form_fields/email.dart';
export 'models/form_fields/optional_password_confirmation.dart';
export 'models/form_fields/optional_password.dart';
export 'models/form_fields/password.dart';
export 'models/form_fields/password_confirmation.dart';

//models
export 'models/menu/menu.dart';
export 'models/menu/menu_tab_category.dart';
export 'models/categorie/category.dart';
export 'models/exceptions.dart';
export 'models/menu_model.dart';
export 'models/cart.dart';
export 'models/restaurant/restaurant.dart';
export 'models/restaurant/google_restaurant.dart';
export 'models/restaurant/google_restaurant_details.dart';
export 'models/restaurant/restaurants_page.dart';
export 'models/user/user.dart';
export 'models/auto_complete/place_details.dart';
export 'models/auto_complete/auto_complete.dart';
export 'models/google_menu_model.dart';

//api services/networking
export 'services/repositories/user/user_repository.dart';
export 'services/repositories/user/base_user_repository.dart';
export 'services/repositories/local_storage/local_storage_repository.dart';
export 'services/repositories/local_storage/base_local_storage_repository.dart';
export 'services/repositories/restaurant/restaurant_repository.dart';
export 'services/repositories/restaurant/base_restaurant_repository.dart';
export 'services/mapper/mapper.dart';
export 'services/network/api/user_api.dart';
export 'services/network/api/location_api.dart';
export 'services/network/api/search_api.dart';
export 'services/network/api/restaurant_api.dart';
export 'services/network/api/exceptions.dart';
export 'services/network/api/url_builder.dart';
export 'services/network/connectivity_service.dart';

///local storage [SharedPreferences]
export 'services/storage/local_storage.dart';

//app root
export '/composition_root.dart';
export '/firebase_options.dart';
export '/main.dart';
export '/my_app.dart';
export 'config/typedefs.dart';
