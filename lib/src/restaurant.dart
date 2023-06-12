//app root
export '/composition_root.dart';
export '/firebase_options.dart';
export '/main.dart';
export '/my_app.dart';
export 'config/animations/fade_animation.dart';
//extensions
export 'config/extensions/disalow_indicator_extension.dart';
export 'config/extensions/ignore_pointer_extension.dart';
export 'config/extensions/navigator_extension.dart';
export 'config/extensions/trimmed_converted_string_contains_extension.dart';
export 'config/extensions/will_pop_scope_extension.dart';
//fake data
export 'config/logger.dart';
export 'config/routes/routes.dart';
export 'config/theme/theme.dart';
export 'config/typedefs.dart';
//config
export 'config/utils/app_colors.dart';
export 'config/utils/app_constants.dart';
export 'config/utils/app_page_storage_key.dart';
export 'config/utils/app_routes.dart';
export 'config/utils/app_strings.dart';
export 'config/utils/my_theme_data.dart';
export 'models/auto_complete/auto_complete.dart';
export 'models/auto_complete/place_details.dart';
export 'models/cart.dart';
export 'models/category/category.dart';
export 'models/exceptions.dart';
//form fields
export 'models/form_fields/email.dart';
export 'models/form_fields/optional_password.dart';
export 'models/form_fields/optional_password_confirmation.dart';
export 'models/form_fields/password.dart';
export 'models/form_fields/password_confirmation.dart';
export 'models/form_fields/username.dart';
//models
export 'models/menu/menu.dart';
export 'models/menu/menu_model.dart';
export 'models/menu/menu_tab_category.dart';
export 'models/restaurant/restaurant.dart';
export 'models/restaurant/restaurant_details.dart';
export 'models/restaurant/restaurants_page.dart';
export 'models/user/user.dart';
export 'services/client/appwrite_client.dart';
//network
export 'services/network/api/location_api.dart';
export 'services/network/api/restaurant_api.dart';
export 'services/network/api/search_api.dart';
export 'services/network/api/url_builder.dart';
export 'services/network/api/user_api.dart';
export 'services/network/connectivity_service.dart';
//repositories
export 'services/repositories/local_storage/base_local_storage_repository.dart';
export 'services/repositories/local_storage/local_storage_repository.dart';
export 'services/repositories/restaurant/base_restaurant_repository.dart';
export 'services/repositories/restaurant/restaurant_repository.dart';
export 'services/repositories/user/base_user_repository.dart';
//api services/networking
export 'services/repositories/user/user_repository.dart';

///local storage ['SharedPreferences']
export 'services/storage/local_storage.dart';
//cart view
export 'views/pages/cart/cart_view.dart';
//cart components
export 'views/pages/cart/components/cart_items_list_view.dart';
//services
export 'views/pages/cart/services/cart_service.dart';
//state
export 'views/pages/cart/state/cart_bloc.dart';
export 'views/pages/cart/state/cart_state.dart';
//login components
export 'views/pages/login/components/show_password_controller/show_password_cubit.dart';
//login view
export 'views/pages/login/login_view.dart';
//state
export 'views/pages/login/state/login_cubit.dart';
export 'views/pages/main_page/components/categories_slider.dart';
//header
export 'views/pages/main_page/components/header/header_view.dart';
export 'views/pages/main_page/components/location/google_map_view.dart';
export 'views/pages/main_page/components/location/helper/location_helper.dart';
//location
export 'views/pages/main_page/components/location/search_location_with_autocomplete.dart';
export 'views/pages/main_page/components/main_page_body.dart';
export 'views/pages/main_page/components/menu/components/discount_card.dart';
export 'views/pages/main_page/components/menu/components/menu_item_card.dart';
export 'views/pages/main_page/components/menu/components/menu_section_header.dart';
//menu
export 'views/pages/main_page/components/menu/menu_view.dart';
export 'views/pages/main_page/components/restaurant/restaurants_filtered_view.dart';
//restaurant
export 'views/pages/main_page/components/restaurant/restaurants_list_view.dart';
export 'views/pages/main_page/components/search/search_bar.dart';
//search
export 'views/pages/main_page/components/search/search_view.dart';
//view
export 'views/pages/main_page/main_page.dart';
export 'views/pages/main_page/navigation_state/navigation_bloc.dart';
//navigation state
export 'views/pages/main_page/navigation_state/navigation_cubit.dart';
export 'views/pages/main_page/navigation_state/navigation_state.dart';
//services
export 'views/pages/main_page/services/location_service.dart';
export 'views/pages/main_page/services/main_page_service.dart';
export 'views/pages/main_page/services/restaurant_service.dart';
export 'views/pages/main_page/state/address_result.dart';
export 'views/pages/main_page/state/location_bloc.dart';
export 'views/pages/main_page/state/location_result.dart';
//main page state
export 'views/pages/main_page/state/main_bloc.dart';
export 'views/pages/main_page/state/search_bloc.dart';
export 'views/pages/main_page/state/search_result.dart';
//register view
export 'views/pages/register/register_view.dart';
//restaurant view
export 'views/pages/restaurants/restaurant_view.dart';
//splash view
export 'views/widgets/app_input_text.dart';
export 'views/widgets/cached_image.dart';
export 'views/widgets/custom_button_in_show_dialog.dart';
export 'views/widgets/custom_circular_indicator.dart';
export 'views/widgets/custom_icon.dart';
export 'views/widgets/custom_scaffold.dart';
export 'views/widgets/discount_price.dart';
export 'views/widgets/dot_separator.dart';
export 'views/widgets/expanded_elevated_button.dart';
export 'views/widgets/k_text.dart';
export 'views/widgets/separator_builder.dart';
export 'views/widgets/shimmer_loading.dart';
export 'views/widgets/show_custom_dialog.dart';
