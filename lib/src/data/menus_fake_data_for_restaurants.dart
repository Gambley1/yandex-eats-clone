import 'dart:math';

import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Item, Menu;

@immutable
class FakeMenus {
  FakeMenus({int? numOfRatings}) : _numOfRatings = numOfRatings ?? 0;

  /// In this case, num of ratings is just a variable that uses as a unique,
  /// (almost) non changing value, so the menus are always the same for the specific
  /// unique variable, in our case for numOfRatings. Instead of num of ratings can
  /// be used any unique value of type int or double or even not unique, but only
  /// if you dont care not to have more randomized menus for restaurants.
  final int? _numOfRatings;

  late final Random _random = Random(_numOfRatings ?? 1);

  static final List<List<Menu>> _fakeMenu = [
    [
      const Menu(
        category: 'Burgers',
        items: [
          Item(
            name: 'Classic Burger',
            description: 'Beef patty with lettuce, tomato, and cheese',
            imageUrl: 'https://example.com/classic_burger.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Bacon Cheeseburger',
            description: 'Beef patty with crispy bacon and melted cheese',
            imageUrl: 'https://example.com/bacon_cheeseburger.jpg',
            price: 10.99,
            discount: 0,
          ),
          Item(
            name: 'Veggie Burger',
            description: 'Plant-based patty with lettuce, tomato, and avocado',
            imageUrl: 'https://example.com/veggie_burger.jpg',
            price: 9.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Pizzas',
        items: [
          Item(
            name: 'Pepperoni Pizza',
            description: 'Tomato sauce, mozzarella cheese, and pepperoni',
            imageUrl: 'https://example.com/pepperoni_pizza.jpg',
            price: 12.99,
            discount: 0,
          ),
          Item(
            name: 'Vegetarian Pizza',
            description:
                'Tomato sauce, mozzarella cheese, mushrooms, peppers, and onions',
            imageUrl: 'https://example.com/vegetarian_pizza.jpg',
            price: 11.99,
            discount: 0,
          ),
          Item(
            name: 'Hawaiian Pizza',
            description: 'Tomato sauce, mozzarella cheese, ham, and pineapple',
            imageUrl: 'https://example.com/hawaiian_pizza.jpg',
            price: 13.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Salads',
        items: [
          Item(
            name: 'Caesar Salad',
            description:
                'Romaine lettuce, croutons, parmesan cheese, and Caesar dressing',
            imageUrl: 'https://example.com/caesar_salad.jpg',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Greek Salad',
            description:
                'Mixed greens, feta cheese, olives, and Greek dressing',
            imageUrl: 'https://example.com/greek_salad.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Chicken Cobb Salad',
            description:
                'Mixed greens, grilled chicken, bacon, avocado, and ranch dressing',
            imageUrl: 'https://example.com/cobb_salad.jpg',
            price: 9.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Sandwiches',
        items: [
          Item(
            name: 'Turkey Club Sandwich',
            description: 'Turkey, bacon, lettuce, tomato, and mayo on toast',
            imageUrl: 'https://example.com/turkey_sandwich.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Grilled Cheese Sandwich',
            description: 'Melted cheddar cheese on sourdough bread',
            imageUrl: 'https://example.com/grilled_cheese.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'Philly Cheesesteak',
            description:
                'Thinly sliced beef with grilled onions, peppers, and provolone cheese on a hoagie roll',
            imageUrl: 'https://example.com/philly_cheesesteak.jpg',
            price: 10.99,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Desserts',
        items: [
          Item(
            name: 'Chocolate Cake',
            description: 'Moist chocolate cake with chocolate frosting',
            imageUrl: 'https://example.com/chocolate_cake.jpg',
            price: 5.99,
            discount: 0,
          ),
          Item(
            name: 'Cheesecake',
            description: 'Creamy cheesecake with graham cracker crust',
            imageUrl: 'https://example.com/cheesecake.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'Ice Cream Sundae',
            description:
                'Vanilla ice cream with chocolate syrup, whipped cream, and a cherry on top',
            imageUrl: 'https://example.com/ice_cream_sundae.jpg',
            price: 4.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Drinks',
        items: [
          Item(
            name: 'Coke',
            description: '',
            imageUrl: '',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Iced Tea',
            description: '',
            imageUrl: '',
            price: 2.49,
            discount: 0,
          ),
          Item(
            name: 'Margarita',
            description: 'Tequila, lime juice, and triple sec',
            imageUrl: 'https://example.com/margarita.jpg',
            price: 8.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Burgers',
        items: [
          Item(
            name: 'Classic Burger',
            description:
                'Beef patty with lettuce, tomato, and onion on a sesame seed bun',
            imageUrl: 'https://example.com/classic_burger.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Bacon Cheeseburger',
            description:
                'Beef patty with bacon, cheddar cheese, lettuce, tomato, and onion on a sesame seed bun',
            imageUrl: 'https://example.com/bacon_cheeseburger.jpg',
            price: 11.99,
            discount: 0,
          ),
          Item(
            name: 'Veggie Burger',
            description:
                'Plant-based patty with lettuce, tomato, and onion on a sesame seed bun',
            imageUrl: 'https://example.com/veggie_burger.jpg',
            price: 10.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Pasta',
        items: [
          Item(
            name: 'Spaghetti and Meatballs',
            description: 'Spaghetti with homemade meatballs in tomato sauce',
            imageUrl: 'https://example.com/spaghetti_and_meatballs.jpg',
            price: 12.99,
            discount: 0,
          ),
          Item(
            name: 'Fettuccine Alfredo',
            description: 'Fettuccine with creamy parmesan sauce',
            imageUrl: 'https://example.com/fettuccine_alfredo.jpg',
            price: 10.99,
            discount: 0,
          ),
          Item(
            name: 'Penne Arrabiata',
            description: 'Penne with spicy tomato sauce and parmesan cheese',
            imageUrl: 'https://example.com/penne_arrabiata.jpg',
            price: 9.99,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Sandwiches',
        items: [
          Item(
            name: 'BLT',
            description: 'Bacon, lettuce, and tomato on toasted bread',
            imageUrl: 'https://example.com/blt.jpg',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Turkey Club',
            description:
                'Turkey, bacon, lettuce, tomato, and mayonnaise on toasted bread',
            imageUrl: 'https://example.com/turkey_club.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Reuben',
            description:
                'Corned beef, sauerkraut, swiss cheese, and thousand island dressing on rye bread',
            imageUrl: 'https://example.com/reuben.jpg',
            price: 11.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Salads',
        items: [
          Item(
            name: 'Caesar Salad',
            description:
                'Romaine lettuce, croutons, parmesan cheese, and caesar dressing',
            imageUrl: 'https://example.com/caesar_salad.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Cobb Salad',
            description:
                'Lettuce, bacon, avocado, tomato, chicken, and blue cheese dressing',
            imageUrl: 'https://example.com/cobb_salad.jpg',
            price: 10.99,
            discount: 0,
          ),
          Item(
            name: 'Greek Salad',
            description:
                'Lettuce, tomato, cucumber, red onion, feta cheese, and Greek dressing',
            imageUrl: 'https://example.com/greek_salad.jpg',
            price: 9.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Desserts',
        items: [
          Item(
            name: 'Chocolate Cake',
            description: 'Rich chocolate cake with chocolate frosting',
            imageUrl: 'https://example.com/chocolate_cake.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'Apple Pie',
            description: 'Warm apple pie with cinnamon and a flaky crust',
            imageUrl: 'https://example.com/apple_pie.jpg',
            price: 5.99,
            discount: 0,
          ),
          Item(
            name: 'New York Cheesecake',
            description: 'Creamy cheesecake with graham cracker crust',
            imageUrl: 'https://example.com/cheesecake.jpg',
            price: 7.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Drinks',
        items: [
          Item(
            name: 'Coke',
            description: '',
            imageUrl: '',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Diet Coke',
            description: '',
            imageUrl: '',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Sprite',
            description: '',
            imageUrl: '',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Iced Tea',
            description: '',
            imageUrl: '',
            price: 2.49,
            discount: 0,
          ),
          Item(
            name: 'Lemonade',
            description: '',
            imageUrl: '',
            price: 2.49,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Appetizers',
        items: [
          Item(
            name: 'Chicken Wings',
            description: 'Crispy chicken wings with your choice of sauce',
            imageUrl:
                'https://images.unsplash.com/photo-1589960626621-945f16dd7c67',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Mozzarella Sticks',
            description: 'Fried mozzarella sticks with marinara sauce',
            imageUrl:
                'https://images.unsplash.com/photo-1541549125018-3c5577bf3e66',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Loaded Nachos',
            description:
                'Tortilla chips topped with cheese, ground beef, beans, and jalapenos',
            imageUrl:
                'https://images.unsplash.com/photo-1589456139821-ec41c8b8d5c5',
            price: 10.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Entrees',
        items: [
          Item(
            name: 'Grilled Salmon',
            description:
                'Fresh salmon fillet grilled to perfection with lemon butter sauce',
            imageUrl:
                'https://images.unsplash.com/photo-1622757412229-0d1b11c1f354',
            price: 24.99,
            discount: 0,
          ),
          Item(
            name: 'Filet Mignon',
            description:
                '8 oz filet mignon with red wine reduction and roasted vegetables',
            imageUrl:
                'https://images.unsplash.com/photo-1629913348775-f5a5ca89f5ed',
            price: 27.99,
            discount: 0,
          ),
          Item(
            name: 'New York Strip',
            description:
                '10 oz New York strip steak with herb butter and French fries',
            imageUrl:
                'https://images.unsplash.com/photo-1629328031126-b22d96503715',
            price: 22.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Salads',
        items: [
          Item(
            name: 'Caesar Salad',
            description:
                'Romaine lettuce, croutons, Parmesan cheese, and Caesar dressing',
            imageUrl:
                'https://images.unsplash.com/photo-1551532524-7f1b0d0f7fb1',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Greek Salad',
            description:
                'Mixed greens, feta cheese, Kalamata olives, red onion, and Greek dressing',
            imageUrl:
                'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Cobb Salad',
            description:
                'Mixed greens, grilled chicken, avocado, bacon, egg, tomato',
            imageUrl:
                'https://images.unsplash.com/photo-1611470479127-74a82ac9c7dd',
            price: 11.99,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Breakfast',
        items: [
          Item(
            name: 'Pancakes',
            description: 'Fluffy pancakes with butter and syrup',
            imageUrl: 'https://example.com/pancakes.jpg',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Eggs Benedict',
            description:
                'English muffin topped with ham, poached eggs, and hollandaise sauce',
            imageUrl: 'https://example.com/eggs_benedict.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Breakfast Burrito',
            description:
                'Scrambled eggs, sausage, cheese, and salsa wrapped in a tortilla',
            imageUrl: 'https://example.com/breakfast_burrito.jpg',
            price: 8.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Desserts',
        items: [
          Item(
            name: 'Chocolate Cake',
            description: 'Rich chocolate cake with chocolate frosting',
            imageUrl: 'https://example.com/chocolate_cake.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'Cheesecake',
            description:
                'Creamy cheesecake with graham cracker crust and fruit topping',
            imageUrl: 'https://example.com/cheesecake.jpg',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Apple Pie',
            description: 'Homemade apple pie with flaky crust',
            imageUrl: 'https://example.com/apple_pie.jpg',
            price: 5.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Drinks',
        items: [
          Item(
            name: 'Coke',
            description: 'Coca-Cola',
            imageUrl: 'https://example.com/coke.jpg',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Sprite',
            description: 'Sprite',
            imageUrl: 'https://example.com/sprite.jpg',
            price: 1.99,
            discount: 0,
          ),
          Item(
            name: 'Iced Tea',
            description: 'Freshly brewed iced tea with lemon',
            imageUrl: 'https://example.com/iced_tea.jpg',
            price: 2.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Appetizers',
        items: [
          Item(
            name: 'Fried Calamari',
            description: 'Crispy fried calamari with marinara sauce',
            imageUrl: 'https://example.com/fried_calamari.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Chicken Wings',
            description:
                'Buffalo-style chicken wings with blue cheese dressing',
            imageUrl: 'https://example.com/chicken_wings.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Mozzarella Sticks',
            description: 'Breaded mozzarella sticks with marinara sauce',
            imageUrl: 'https://example.com/mozzarella_sticks.jpg',
            price: 7.99,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Seafood',
        items: [
          Item(
            name: 'Shrimp Scampi',
            description:
                'Shrimp sautéed in garlic butter and white wine over linguine',
            imageUrl: 'https://example.com/shrimp_scampi.jpg',
            price: 14.99,
            discount: 0,
          ),
          Item(
            name: 'Grilled Salmon',
            description: 'Fresh grilled salmon with a lemon dill sauce',
            imageUrl: 'https://example.com/grilled_salmon.jpg',
            price: 16.99,
            discount: 0,
          ),
          Item(
            name: 'Fish and Chips',
            description: 'Beer-battered cod with fries and tartar sauce',
            imageUrl: 'https://example.com/fish_and_chips.jpg',
            price: 12.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Burgers',
        items: [
          Item(
            name: 'Classic Burger',
            description:
                'Beef patty, lettuce, tomato, onion, and pickles on a brioche bun',
            imageUrl: 'https://example.com/classic_burger.jpg',
            price: 10.99,
            discount: 0,
          ),
          Item(
            name: 'Bacon Cheeseburger',
            description:
                'Beef patty, bacon, cheddar cheese, lettuce, tomato, onion, and pickles on a brioche bun',
            imageUrl: 'https://example.com/bacon_cheeseburger.jpg',
            price: 12.99,
            discount: 0,
          ),
          Item(
            name: 'Mushroom Swiss Burger',
            description:
                'Beef patty, sautéed mushrooms, Swiss cheese, lettuce, and garlic aioli on a brioche bun',
            imageUrl: 'https://example.com/mushroom_swiss_burger.jpg',
            price: 11.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Pasta',
        items: [
          Item(
            name: 'Spaghetti and Meatballs',
            description:
                'Spaghetti with house-made meatballs and marinara sauce',
            imageUrl: 'https://example.com/spaghetti_and_meatballs.jpg',
            price: 11.99,
            discount: 0,
          ),
          Item(
            name: 'Fettuccine Alfredo',
            description: 'Fettuccine pasta with a creamy Alfredo sauce',
            imageUrl: 'https://example.com/fettuccine_alfredo.jpg',
            price: 10.99,
            discount: 0,
          ),
          Item(
            name: 'Pesto Linguine',
            description:
                'Linguine pasta with house-made pesto sauce and Parmesan cheese',
            imageUrl: 'https://example.com/pesto_linguine.jpg',
            price: 12.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Sandwiches',
        items: [
          Item(
            name: 'Grilled Cheese',
            description: 'Cheddar cheese on grilled sourdough bread',
            imageUrl: 'https://example.com/grilled_cheese.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'Turkey Club',
            description:
                'Turkey, bacon, lettuce, tomato, and mayo on toasted wheat bread',
            imageUrl: 'https://example.com/turkey_club.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Reuben',
            description:
                'Corned beef, Swiss cheese, sauerkraut, and Thousand Island dressing on rye bread',
            imageUrl: 'https://example.com/reuben.jpg',
            price: 8.99,
            discount: 0,
          ),
        ],
      ),
    ],
    [
      const Menu(
        category: 'Steaks',
        items: [
          Item(
            name: 'Ribeye',
            description:
                '12 oz ribeye steak with garlic butter and mashed potatoes',
            imageUrl: 'https://example.com/ribeye.jpg',
            price: 24.99,
            discount: 0,
          ),
          Item(
            name: 'Filet Mignon',
            description:
                '8 oz filet mignon with red wine reduction and roasted vegetables',
            imageUrl: 'https://example.com/filet_mignon.jpg',
            price: 27.99,
            discount: 0,
          ),
          Item(
            name: 'New York Strip',
            description:
                '10 oz New York strip steak with herb butter and French fries',
            imageUrl: 'https://example.com/new_york_strip.jpg',
            price: 22.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Salads',
        items: [
          Item(
            name: 'Caesar Salad',
            description:
                'Romaine lettuce, croutons, Parmesan cheese, and Caesar dressing',
            imageUrl: 'https://example.com/caesar_salad.jpg',
            price: 8.99,
            discount: 0,
          ),
          Item(
            name: 'Greek Salad',
            description:
                'Mixed greens, feta cheese, Kalamata olives, red onion, and Greek dressing',
            imageUrl: 'https://example.com/greek_salad.jpg',
            price: 9.99,
            discount: 0,
          ),
          Item(
            name: 'Cobb Salad',
            description:
                'Mixed greens, grilled chicken, avocado, bacon, egg, tomato, and blue cheese dressing',
            imageUrl: 'https://example.com/cobb_salad.jpg',
            price: 10.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Desserts',
        items: [
          Item(
            name: 'Chocolate Cake',
            description:
                'Three layers of rich chocolate cake with chocolate ganache and whipped cream',
            imageUrl: 'https://example.com/chocolate_cake.jpg',
            price: 6.99,
            discount: 0,
          ),
          Item(
            name: 'New York Cheesecake',
            description:
                'Classic New York-style cheesecake with a graham cracker crust',
            imageUrl: 'https://example.com/new_york_cheesecake.jpg',
            price: 7.99,
            discount: 0,
          ),
          Item(
            name: 'Apple Pie',
            description:
                'Warm apple pie with vanilla ice cream and caramel sauce',
            imageUrl: 'https://example.com/apple_pie.jpg',
            price: 8.99,
            discount: 0,
          ),
        ],
      ),
      const Menu(
        category: 'Drinks',
        items: [
          Item(
            name: 'Soda',
            description: 'Coca-Cola, Diet Coke, Sprite, or Fanta',
            imageUrl: '',
            price: 2.99,
            discount: 0,
          ),
          Item(
            name: 'Iced Tea',
            description: 'Freshly brewed black tea over ice',
            imageUrl: '',
            price: 2.99,
            discount: 0,
          ),
          Item(
            name: 'Beer',
            description: 'Selection of local and imported beers',
            imageUrl: '',
            price: 5.99,
            discount: 0,
          ),
        ],
      ),
    ],
  ];

  /// Getting random menu from dummy list of all menus, based on it's length and
  /// given to [Random] seed value, in our case it's num of ratings.
  List<Menu> getRandomMenu() => [
        ..._fakeMenu[_random.nextInt(
          _fakeMenu.length,
        )],
      ];
}
