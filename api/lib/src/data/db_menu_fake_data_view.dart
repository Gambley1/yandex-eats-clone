// ignore_for_file: lines_longer_than_80_chars

import 'package:yandex_food_api/api.dart';

/// {@template db_fake_menus}
/// Fake menus for restaurants
/// {@endtemplate}
class DBFakeMenus {
  /// {@macro db_fake_menus}
  DBFakeMenus._();

  static final List<List<DBMenuInsertRequest>> fakeMenusInsert = [
    [
      DBMenuInsertRequest(
        category: 'Burgers',
        restaurantPlaceId: 'Keaf32LF_pa032-64312fa_=543',
      ),
      DBMenuInsertRequest(
        category: 'Pizzas',
        restaurantPlaceId: 'Keaf32LF_pa032-64312fa_=543',
      ),
      DBMenuInsertRequest(
        category: 'Salads',
        restaurantPlaceId: 'Keaf32LF_pa032-64312fa_=543',
      ),
      DBMenuInsertRequest(
        category: 'Sandwiches',
        restaurantPlaceId: 'Keaf32LF_pa032-64312fa_=543',
      ),
    ],
    [
      DBMenuInsertRequest(
        category: 'Desserts',
        restaurantPlaceId: 'Bagds84SA_ob150-52214og_=051',
      ),
      DBMenuInsertRequest(
        category: 'Drinks',
        restaurantPlaceId: 'Bagds84SA_ob150-52214og_=051',
      ),
      DBMenuInsertRequest(
        category: 'Burgers',
        restaurantPlaceId: 'Bagds84SA_ob150-52214og_=051',
      ),
      DBMenuInsertRequest(
        category: 'Pasta',
        restaurantPlaceId: 'Bagds84SA_ob150-52214og_=051',
      ),
    ],
    [
      DBMenuInsertRequest(
        category: 'Sandwiches',
        restaurantPlaceId: 'Piaf42FA_af950-23214ga_=521',
      ),
      DBMenuInsertRequest(
        category: 'Salads',
        restaurantPlaceId: 'Piaf42FA_af950-23214ga_=521',
      ),
      DBMenuInsertRequest(
        category: 'Desserts',
        restaurantPlaceId: 'Piaf42FA_af950-23214ga_=521',
      ),
      DBMenuInsertRequest(
        category: 'Drinks',
        restaurantPlaceId: 'Piaf42FA_af950-23214ga_=521',
      ),
    ],
    [
      DBMenuInsertRequest(
        category: 'Appetizers',
        restaurantPlaceId: 'Oeaf62PA_bg512-0621oe_=910',
      ),
      DBMenuInsertRequest(
        category: 'Entrees',
        restaurantPlaceId: 'Oeaf62PA_bg512-0621oe_=910',
      ),
      DBMenuInsertRequest(
        category: 'Salads',
        restaurantPlaceId: 'Oeaf62PA_bg512-0621oe_=910',
      ),
    ],
    [
      DBMenuInsertRequest(
        category: 'Breakfast',
        restaurantPlaceId: 'Jhaf52FA_af950-23214ga_=025',
      ),
      DBMenuInsertRequest(
        category: 'Desserts',
        restaurantPlaceId: 'Jhaf52FA_af950-23214ga_=025',
      ),
      DBMenuInsertRequest(
        category: 'Drinks',
        restaurantPlaceId: 'Jhaf52FA_af950-23214ga_=025',
      ),
      DBMenuInsertRequest(
        category: 'Appetizers',
        restaurantPlaceId: 'Jhaf52FA_af950-23214ga_=025',
      ),
    ],
    [
      DBMenuInsertRequest(
        category: 'Seafood',
        restaurantPlaceId: 'Avds89FA_af950-23214ga_=942',
      ),
      DBMenuInsertRequest(
        category: 'Burgers',
        restaurantPlaceId: 'Avds89FA_af950-23214ga_=942',
      ),
      DBMenuInsertRequest(
        category: 'Pasta',
        restaurantPlaceId: 'Avds89FA_af950-23214ga_=942',
      ),
      DBMenuInsertRequest(
        category: 'Sandwiches',
        restaurantPlaceId: 'Avds89FA_af950-23214ga_=942',
      ),
    ],
  ];

  static final List<List<DBMenuItemInsertRequest>> _fakeMenuItemInsert = [
    [
      DBMenuItemInsertRequest(
        name: 'Classic Burger',
        discount: 0,
        description: 'Beef patty with lettuce, tomato, and cheese',
        imageUrl:
            'https://media.istockphoto.com/id/1045565238/photo/tasty-burger-on-a-wooden-table.jpg?b=1&s=170667a&w=0&k=20&c=PR01AdPvwqBz7vAuGt2LnzDHqorFU_Qv4oZHOycH88I=',
        price: 8.99,
        menuId: 1,
      ),
      DBMenuItemInsertRequest(
        name: 'Bacon Cheeseburger',
        discount: 0,
        description: 'Beef patty with crispy bacon and melted cheese',
        imageUrl:
            'https://media.istockphoto.com/id/593297080/photo/juicy-gourmet-cheeseburger.jpg?b=1&s=170667a&w=0&k=20&c=3AbE_VRbpUo23z0XDbYajL-vWH74hmtghPgL5-aZk6I=',
        price: 10.99,
        menuId: 1,
      ),
      DBMenuItemInsertRequest(
        name: 'Veggie Burger',
        discount: 0,
        description: 'Plant-based patty with lettuce, tomato, and avocado',
        imageUrl:
            'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmVnYW4lMjBidXJnZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        price: 9.99,
        menuId: 1,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Pepperoni Pizza',
        discount: 0,
        description: 'Tomato sauce, mozzarella cheese, and pepperoni',
        imageUrl:
            'https://media.istockphoto.com/id/1420079630/photo/fresh-baked-pepperoni-pizza-with-salami-and-olives.jpg?b=1&s=170667a&w=0&k=20&c=wKf7PUPnToslskuylQq-NPPTRlvZpoc6WrTSADe4J0w=',
        price: 12.99,
        menuId: 2,
      ),
      DBMenuItemInsertRequest(
        name: 'Vegetarian Pizza',
        discount: 0,
        description:
            'Tomato sauce, mozzarella cheese, mushrooms, peppers, and onions',
        imageUrl:
            'https://media.istockphoto.com/id/1439841909/photo/food-photos-various-entrees-appetizers-deserts-etc.jpg?b=1&s=170667a&w=0&k=20&c=LGRui5aa0tLYmCQLeklyHn-af5mLlxGqfOWaxBlITEQ=',
        price: 11.99,
        menuId: 2,
      ),
      DBMenuItemInsertRequest(
        name: 'Hawaiian Pizza',
        discount: 0,
        description: 'Tomato sauce, mozzarella cheese, ham, and pineapple',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8SGF3YWlpYW4lMjBwaXp6YXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: 13.99,
        menuId: 2,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Caesar Salad',
        discount: 0,
        description:
            'Romaine lettuce, croutons, parmesan cheese, and Caesar dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1413784982/photo/caesar-salad-with-shrimps.jpg?b=1&s=170667a&w=0&k=20&c=Bx11hX-JHPbFig7pz2i7OrUBRA7SeZKoviSR6WFse0s=',
        price: 7.99,
        menuId: 3,
      ),
      DBMenuItemInsertRequest(
        name: 'Greek Salad',
        discount: 0,
        description: 'Mixed greens, feta cheese, olives, and Greek dressing',
        imageUrl:
            'https://images.unsplash.com/photo-1599021419847-d8a7a6aba5b4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8R3JlZWslMjBTYWxhZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: 8.99,
        menuId: 3,
      ),
      DBMenuItemInsertRequest(
        name: 'Chicken Cobb Salad',
        discount: 0,
        description:
            'Mixed greens, grilled chicken, bacon, avocado, and ranch dressing',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8Q2hpY2tlbiUyMENvYmIlMjBTYWxhZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: 9.99,
        menuId: 3,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Turkey Club Sandwich',
        discount: 0,
        description: 'Turkey, bacon, lettuce, tomato, and mayo on toast',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8Q2hpY2tlbiUyMENvYmIlMjBTYWxhZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: 8.99,
        menuId: 4,
      ),
      DBMenuItemInsertRequest(
        name: 'Grilled Cheese Sandwich',
        discount: 0,
        description: 'Melted cheddar cheese on sourdough bread',
        imageUrl:
            'https://images.unsplash.com/photo-1481070414801-51fd732d7184?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8VHVya2V5JTIwQ2x1YiUyMFNhbmR3aWNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: 6.99,
        menuId: 4,
      ),
      DBMenuItemInsertRequest(
        name: 'Philly Cheesesteak',
        discount: 0,
        description:
            'Thinly sliced beef with grilled onions, peppers, and provolone cheese on a hoagie roll',
        imageUrl:
            'https://images.unsplash.com/photo-1475090169767-40ed8d18f67d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8R3JpbGxlZCUyMENoZWVzZSUyMFNhbmR3aWNofGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: 10.99,
        menuId: 4,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Chocolate Cake',
        discount: 0,
        description: 'Moist chocolate cake with chocolate frosting',
        imageUrl:
            'https://media.istockphoto.com/id/1336693855/photo/chocolate-bundt-cake-with-chocolate-ganache.jpg?b=1&s=170667a&w=0&k=20&c=PDncXs6VzjyIjBhmIxZUR2hDTQUEIERsnmm7uXPGGrE=',
        price: 5.99,
        menuId: 5,
      ),
      DBMenuItemInsertRequest(
        name: 'Cheesecake',
        discount: 0,
        description: 'Creamy cheesecake with graham cracker crust',
        imageUrl:
            'https://media.istockphoto.com/id/1167344045/photo/cheesecake-slice-new-york-style-classical-cheese-cake.jpg?b=1&s=170667a&w=0&k=20&c=cYN0DAhRQ0tLX8E8ndgU3GFfG7ilMZ3GcIJGj6Mqyxw=',
        price: 6.99,
        menuId: 5,
      ),
      DBMenuItemInsertRequest(
        name: 'Ice Cream Sundae',
        discount: 0,
        description:
            'Vanilla ice cream with chocolate syrup, whipped cream, and a cherry on top',
        imageUrl:
            'https://media.istockphoto.com/id/1467145310/photo/ice-cream-cup-with-fruits.jpg?b=1&s=170667a&w=0&k=20&c=adMUipaLO01mkugId1Zuxxji7yw40z07VIL5OhsAyrA=',
        price: 4.99,
        menuId: 5,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Iced Tea',
        discount: 0,
        description: '',
        imageUrl: '',
        price: 2.49,
        menuId: 6,
      ),
      DBMenuItemInsertRequest(
        name: 'Margarita',
        discount: 0,
        description: 'Tequila, lime juice, and triple sec',
        imageUrl:
            'https://media.istockphoto.com/id/1414575281/photo/a-delicious-and-tasty-italian-pizza-margherita-with-tomatoes-and-buffalo-mozzarella.jpg?b=1&s=170667a&w=0&k=20&c=pobf9fs5EsiNZMuyrq_44Y3LT8c4cz7_jmxvgQPclY4=',
        price: 8.99,
        menuId: 6,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Classic Burger',
        discount: 0,
        description:
            'Beef patty with lettuce, tomato, and onion on a sesame seed bun',
        imageUrl:
            'https://media.istockphoto.com/id/636305290/photo/tasty-grilled-burger-with-lettuce-and-mayonnaise-rustic-wooden-table.jpg?b=1&s=170667a&w=0&k=20&c=RfmlQaMDq2cJf0rPTT_k0aa4SQ10Ji0MVqo9XnB3JwY=',
        price: 9.99,
        menuId: 7,
      ),
      DBMenuItemInsertRequest(
        name: 'Bacon Cheeseburger',
        discount: 0,
        description:
            'Beef patty with bacon, cheddar cheese, lettuce, tomato, and onion on a sesame seed bun',
        imageUrl:
            'https://media.istockphoto.com/id/1398630614/photo/bacon-cheeseburger-on-a-toasted-bun.jpg?b=1&s=170667a&w=0&k=20&c=Aq7Dg29n3DDE3gqgT2cWSh9LYxZnr-8SFu0crRQxArA=',
        price: 11.99,
        menuId: 7,
      ),
      DBMenuItemInsertRequest(
        name: 'Veggie Burger',
        discount: 0,
        description:
            'Plant-based patty with lettuce, tomato, and onion on a sesame seed bun',
        imageUrl:
            'https://media.istockphoto.com/id/1248306530/photo/vegan-falafel-burger-with-vegetables-and-sauce-dark-background-copy-space-healthy-plant-based.jpg?b=1&s=170667a&w=0&k=20&c=stXobu4POZFV4H2UmjLn_QmAnl2pUIljlwOxD80OxrU=',
        price: 10.99,
        menuId: 7,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Spaghetti and Meatballs',
        discount: 0,
        description: 'Spaghetti with homemade meatballs in tomato sauce',
        imageUrl:
            'https://media.istockphoto.com/id/1341564316/photo/spaghetti-and-meatballs.jpg?b=1&s=170667a&w=0&k=20&c=bSfMJCKXDP2qeFZxlfp6vZDiWCy0Uhhx6v53xZJE5HI=',
        price: 12.99,
        menuId: 8,
      ),
      DBMenuItemInsertRequest(
        name: 'Fettuccine Alfredo',
        discount: 0,
        description: 'Fettuccine with creamy parmesan sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8RmV0dHVjY2luZSUyMEFsZnJlZG98ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        price: 10.99,
        menuId: 8,
      ),
      DBMenuItemInsertRequest(
        name: 'Penne Arrabiata',
        discount: 0,
        description: 'Penne with spicy tomato sauce and parmesan cheese',
        imageUrl:
            'https://media.istockphoto.com/id/1404506109/photo/penne-arrabiata-with-parmesan-cheese.jpg?b=1&s=170667a&w=0&k=20&c=acgqi5ZDEN36hh4c605Z_0Y7QA9GSDFF9wEqhs9oRkg=',
        price: 9.99,
        menuId: 8,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'BLT',
        discount: 0,
        description: 'Bacon, lettuce, and tomato on toasted bread',
        imageUrl:
            'https://media.istockphoto.com/id/154917493/photo/blt-sandwich.jpg?b=1&s=170667a&w=0&k=20&c=ADqGADahzVL05ASLMNgsD4FRleh1svYZoNh9kRIgS5I=',
        price: 7.99,
        menuId: 9,
      ),
      DBMenuItemInsertRequest(
        name: 'Turkey Club',
        discount: 0,
        description:
            'Turkey, bacon, lettuce, tomato, and mayonnaise on toasted bread',
        imageUrl:
            'https://media.istockphoto.com/id/1197744268/photo/sandwich-bread-tomato-lettuce-and-yellow-cheese.jpg?b=1&s=170667a&w=0&k=20&c=YThGnu7rdG3yqP-hnUx4gVjcbsMMgIck4-Y6mMBS1p0=',
        price: 9.99,
        menuId: 9,
      ),
      DBMenuItemInsertRequest(
        name: 'Reuben',
        discount: 0,
        description:
            'Corned beef, sauerkraut, swiss cheese, and thousand island dressing on rye bread',
        imageUrl:
            'https://media.istockphoto.com/id/155016053/photo/reuben-sandwich.jpg?b=1&s=170667a&w=0&k=20&c=r09-Ox2hs6MnRLDVkLvMbfCYO4ZBqTSeDnJWlizhMak=',
        price: 11.99,
        menuId: 9,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Caesar Salad',
        discount: 0,
        description:
            'Romaine lettuce, croutons, parmesan cheese, and caesar dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1138387864/photo/caesar-salad-with-croutons-and-parmesan-cheese-on-dark-background-copy-space.jpg?b=1&s=170667a&w=0&k=20&c=Jya-WINJAhwfJVP83CYr0ZbSI30w6J2uCWqYdWgZYk0=',
        price: 8.99,
        menuId: 10,
      ),
      DBMenuItemInsertRequest(
        name: 'Cobb Salad',
        discount: 0,
        description:
            'Lettuce, bacon, avocado, tomato, chicken, and blue cheese dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1410427183/photo/cobb-salad-keto-food-top-view-no-people-close-up.jpg?b=1&s=170667a&w=0&k=20&c=mxDReH8iWw1H8Y1wx0SNnKkVDCbp1oTJLhJ10XMFPT0=',
        price: 10.99,
        menuId: 10,
      ),
      DBMenuItemInsertRequest(
        name: 'Greek Salad',
        discount: 0,
        description:
            'Lettuce, tomato, cucumber, red onion, feta cheese, and Greek dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1461256163/photo/feta-cheese-salad-on-wooden-table.jpg?b=1&s=170667a&w=0&k=20&c=gN5zApNv-3nbUQnjyG68Qbf0zQXNoLGehpV01jEbNng=',
        price: 9.99,
        menuId: 10,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Chocolate Cake',
        discount: 0,
        description: 'Rich chocolate cake with chocolate frosting',
        imageUrl:
            'https://media.istockphoto.com/id/1370520449/photo/slice-of-chocolate-cake-with-glaze.jpg?b=1&s=170667a&w=0&k=20&c=YpiiIjJfRGC-xd7ZjJaWYI-zARdb9GMSPvpc-DKL-5I=',
        price: 6.99,
        menuId: 11,
      ),
      DBMenuItemInsertRequest(
        name: 'Apple Pie',
        discount: 0,
        description: 'Warm apple pie with cinnamon and a flaky crust',
        imageUrl:
            'https://media.istockphoto.com/id/1459605437/photo/homemade-apple-pie-on-wooden-background.jpg?b=1&s=170667a&w=0&k=20&c=9W7iQwBNm-6y6W9-8DPtD_Yqupbm_jSXSu3kQNOCyU0=',
        price: 5.99,
        menuId: 11,
      ),
      DBMenuItemInsertRequest(
        name: 'New York Cheesecake',
        discount: 0,
        description: 'Creamy cheesecake with graham cracker crust',
        imageUrl:
            'https://media.istockphoto.com/id/1428437700/photo/mini-cookies-and-cream-cheesecakes.jpg?b=1&s=170667a&w=0&k=20&c=jiB0TO2S3Wj17rrhpmj77J0CTeBVfKrBlpITuvjNFXo=',
        price: 7.99,
        menuId: 11,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Diet Coke',
        discount: 0,
        price: 2,
        description: '',
        imageUrl: '',
        menuId: 12,
      ),
      DBMenuItemInsertRequest(
        name: 'Sprite',
        discount: 0,
        price: 3,
        description: '',
        imageUrl: '',
        menuId: 12,
      ),
      DBMenuItemInsertRequest(
        name: 'Iced Tea',
        discount: 0,
        description: '',
        imageUrl: '',
        price: 2.49,
        menuId: 12,
      ),
      DBMenuItemInsertRequest(
        name: 'Lemonade',
        discount: 0,
        description: '',
        imageUrl: '',
        price: 2.49,
        menuId: 12,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Chicken Wings',
        discount: 0,
        description: 'Crispy chicken wings with your choice of sauce',
        imageUrl:
            'https://media.istockphoto.com/id/185274327/photo/picture-of-hot-spicy-buffalo-wings.jpg?b=1&s=170667a&w=0&k=20&c=UuT_dH36Io8GZ_hG35UyotrP2jkC7WT29iftji730oY=',
        price: 9.99,
        menuId: 13,
      ),
      DBMenuItemInsertRequest(
        name: 'Mozzarella Sticks',
        discount: 0,
        description: 'Fried mozzarella sticks with marinara sauce',
        imageUrl:
            'https://media.istockphoto.com/id/1349454512/photo/mozzarella-sticks.jpg?b=1&s=170667a&w=0&k=20&c=WZw4kLvdZTT6l2uuPhn9Xz9moWUSguazPEIeKyXjmGU=',
        price: 7.99,
        menuId: 13,
      ),
      DBMenuItemInsertRequest(
        name: 'Loaded Nachos',
        discount: 0,
        description:
            'Tortilla chips topped with cheese, ground beef, beans, and jalapenos',
        imageUrl:
            'https://media.istockphoto.com/id/1464174139/photo/image-of-homemade-loaded-nachos-covered-in-melted-mozzarella-cheese-cherry-tomatoes-black.jpg?b=1&s=170667a&w=0&k=20&c=sXRurNdLUdmXgJ0lKwA92yzjOaXNTzM7I2AJ3QppcBE=',
        price: 10.99,
        menuId: 13,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Grilled Salmon',
        discount: 0,
        description:
            'Fresh salmon fillet grilled to perfection with lemon butter sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1622757412229-0d1b11c1f354',
        price: 24.99,
        menuId: 14,
      ),
      DBMenuItemInsertRequest(
        name: 'Filet Mignon',
        discount: 0,
        description:
            '8 oz filet mignon with red wine reduction and roasted vegetables',
        imageUrl:
            'https://images.unsplash.com/photo-1629913348775-f5a5ca89f5ed',
        price: 27.99,
        menuId: 14,
      ),
      DBMenuItemInsertRequest(
        name: 'New York Strip',
        discount: 0,
        description:
            '10 oz New York strip steak with herb butter and French fries',
        imageUrl:
            'https://media.istockphoto.com/id/1469173715/photo/grilled-denver-beef-meat-steak-on-a-rack-black-background-top-view.jpg?b=1&s=170667a&w=0&k=20&c=mO7RoztnyNle-U0z20JPIRvCQXARrVr_FquYMLy6WCI=',
        price: 22.99,
        menuId: 14,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Caesar Salad',
        discount: 0,
        description:
            'Romaine lettuce, croutons, Parmesan cheese, and Caesar dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1401168372/photo/shrimp-caesar-salad.jpg?b=1&s=170667a&w=0&k=20&c=17pugbaFJ7lpeB4W3DFOr6NAthlO9kvr9PaXBrOUVSU=',
        price: 8.99,
        menuId: 15,
      ),
      DBMenuItemInsertRequest(
        name: 'Greek Salad',
        discount: 0,
        description:
            'Mixed greens, feta cheese, Kalamata olives, red onion, and Greek dressing',
        imageUrl:
            'https://media.istockphoto.com/id/1161711740/photo/greek-salad-with-fresh-vegetables-feta-cheese-and-kalamata-olives-healthy-food-top-view.jpg?b=1&s=170667a&w=0&k=20&c=CTeeJ9YSwAaQY3gePdYrCLot6h4XMzUymqWfWBwYoVM=',
        price: 9.99,
        menuId: 15,
      ),
      DBMenuItemInsertRequest(
        name: 'Cobb Salad',
        discount: 0,
        description:
            'Mixed greens, grilled chicken, avocado, bacon, egg, tomato',
        imageUrl:
            'https://media.istockphoto.com/id/1415364093/photo/cobb-salad-with-grilled-chicken-eggs-avocado-tomato-bacon-on-marble-white-background-keto-diet.jpg?b=1&s=170667a&w=0&k=20&c=3RrZ3J7C-k9s1jfLZBZWWxmHJsYJieH5WWDDEHoTgP0=',
        price: 11.99,
        menuId: 15,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Pancakes',
        discount: 0,
        description: 'Fluffy pancakes with butter and syrup',
        imageUrl:
            'https://media.istockphoto.com/id/1370621661/photo/belgian-waffle-and-fresh-berries.jpg?b=1&s=170667a&w=0&k=20&c=StSyy0WtN2BeBEPupul4ckWiHCilLY2IMtjZ4Jx01jY=',
        price: 7.99,
        menuId: 16,
      ),
      DBMenuItemInsertRequest(
        name: 'Eggs Benedict',
        discount: 0,
        description:
            'English muffin topped with ham, poached eggs, and hollandaise sauce',
        imageUrl:
            'https://media.istockphoto.com/id/495071200/photo/eggs-benedict.jpg?b=1&s=170667a&w=0&k=20&c=HwC2OckiO1nLFWmXPaJ3KQHUd0mlMk2THYqH_aQ_G1g=',
        price: 9.99,
        menuId: 16,
      ),
      DBMenuItemInsertRequest(
        name: 'Breakfast Burrito',
        discount: 0,
        description:
            'Scrambled eggs, sausage, cheese, and salsa wrapped in a tortilla',
        imageUrl:
            'https://media.istockphoto.com/id/599706780/photo/scrambled-egg-and-cheese-breakfast-wrap.jpg?b=1&s=170667a&w=0&k=20&c=NlTOrE04tnBZPr7VH1aj0Vc72zcYU_neay16voRRFww=',
        price: 8.99,
        menuId: 16,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Chocolate Cake',
        discount: 0,
        description: 'Rich chocolate cake with chocolate frosting',
        imageUrl:
            'https://media.istockphoto.com/id/1327828405/photo/delicious-slice-of-cake.jpg?b=1&s=170667a&w=0&k=20&c=sSFRoKieEm-jEPDqShVtyQHAKWcaxzj0f3vn5rmwSfw=',
        price: 6.99,
        menuId: 17,
      ),
      DBMenuItemInsertRequest(
        name: 'Cheesecake',
        discount: 0,
        description:
            'Creamy cheesecake with graham cracker crust and fruit topping',
        imageUrl:
            'https://media.istockphoto.com/id/1352497199/photo/slice-of-cheesecake-with-chocolate-sauce.jpg?b=1&s=170667a&w=0&k=20&c=ktA4zsk54NrsJ_KngCMmyTiRTEuyXGF-KC--42pNmhU=',
        price: 7.99,
        menuId: 17,
      ),
      DBMenuItemInsertRequest(
        name: 'Apple Pie',
        description: 'Homemade apple pie with flaky crust',
        imageUrl:
            'https://media.istockphoto.com/id/450752471/photo/homemade-organic-apple-pie-dessert.jpg?b=1&s=170667a&w=0&k=20&c=Y0SisNtd6vLbMLtxqr5ZK4kumKX4z1sPpIDzKHvOQUE=',
        price: 5.99,
        menuId: 17,
        discount: 0,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Coke',
        discount: 0,
        description: 'Coca-Cola',
        imageUrl:
            'https://images.unsplash.com/photo-1554866585-cd94860890b7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Q29rZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        price: 1.99,
        menuId: 18,
      ),
      DBMenuItemInsertRequest(
        name: 'Sprite',
        discount: 0,
        description: 'Sprite',
        imageUrl:
            'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8U3ByaXRlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        price: 1.99,
        menuId: 18,
      ),
      DBMenuItemInsertRequest(
        name: 'Iced Tea',
        discount: 0,
        description: 'Freshly brewed iced tea with lemon',
        imageUrl:
            'https://media.istockphoto.com/id/174619099/photo/iced-tea-with-lime-isolated-on-a-white-background.jpg?b=1&s=170667a&w=0&k=20&c=X9258RFJPxhtes2U3abapNZqp5VE9Oaxd6lTqAkZaNA=',
        price: 2.99,
        menuId: 18,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Fried Calamari',
        discount: 0,
        description: 'Crispy fried calamari with marinara sauce',
        imageUrl:
            'https://media.istockphoto.com/id/593297194/photo/fried-calimari-rings-on-wooden-tray-with-dipping-sauce.jpg?b=1&s=170667a&w=0&k=20&c=9sOVGA85gwDUX7_CcB2qhWjbWqKphHTy-iX5aem_SWo=',
        price: 9.99,
        menuId: 19,
      ),
      DBMenuItemInsertRequest(
        name: 'Chicken Wings',
        discount: 0,
        description: 'Buffalo-style chicken wings with blue cheese dressing',
        imageUrl: 'https://example.com/chicken_wings.jpg',
        price: 8.99,
        menuId: 19,
      ),
      DBMenuItemInsertRequest(
        name: 'Mozzarella Sticks',
        discount: 0,
        description: 'Breaded mozzarella sticks with marinara sauce',
        imageUrl: 'https://example.com/mozzarella_sticks.jpg',
        price: 7.99,
        menuId: 19,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Shrimp Scampi',
        discount: 0,
        description:
            'Shrimp sautéed in garlic butter and white wine over linguine',
        imageUrl: 'https://example.com/shrimp_scampi.jpg',
        price: 14.99,
        menuId: 20,
      ),
      DBMenuItemInsertRequest(
        name: 'Grilled Salmon',
        discount: 0,
        description: 'Fresh grilled salmon with a lemon dill sauce',
        imageUrl: 'https://example.com/grilled_salmon.jpg',
        price: 16.99,
        menuId: 20,
      ),
      DBMenuItemInsertRequest(
        name: 'Fish and Chips',
        discount: 0,
        description: 'Beer-battered cod with fries and tartar sauce',
        imageUrl: 'https://example.com/fish_and_chips.jpg',
        price: 12.99,
        menuId: 20,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Classic Burger',
        discount: 0,
        description:
            'Beef patty, lettuce, tomato, onion, and pickles on a brioche bun',
        imageUrl: 'https://example.com/classic_burger.jpg',
        price: 10.99,
        menuId: 21,
      ),
      DBMenuItemInsertRequest(
        name: 'Bacon Cheeseburger',
        discount: 0,
        description:
            'Beef patty, bacon, cheddar cheese, lettuce, tomato, onion, and pickles on a brioche bun',
        imageUrl: 'https://example.com/bacon_cheeseburger.jpg',
        price: 12.99,
        menuId: 21,
      ),
      DBMenuItemInsertRequest(
        name: 'Mushroom Swiss Burger',
        discount: 0,
        description:
            'Beef patty, sautéed mushrooms, Swiss cheese, lettuce, and garlic aioli on a brioche bun',
        imageUrl: 'https://example.com/mushroom_swiss_burger.jpg',
        price: 11.99,
        menuId: 21,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Spaghetti and Meatballs',
        discount: 0,
        description: 'Spaghetti with house-made meatballs and marinara sauce',
        imageUrl: 'https://example.com/spaghetti_and_meatballs.jpg',
        price: 11.99,
        menuId: 22,
      ),
      DBMenuItemInsertRequest(
        name: 'Fettuccine Alfredo',
        discount: 0,
        description: 'Fettuccine pasta with a creamy Alfredo sauce',
        imageUrl: 'https://example.com/fettuccine_alfredo.jpg',
        price: 10.99,
        menuId: 22,
      ),
      DBMenuItemInsertRequest(
        name: 'Pesto Linguine',
        discount: 0,
        description:
            'Linguine pasta with house-made pesto sauce and Parmesan cheese',
        imageUrl: 'https://example.com/pesto_linguine.jpg',
        price: 12.99,
        menuId: 22,
      ),
    ],
    [
      DBMenuItemInsertRequest(
        name: 'Grilled Cheese',
        discount: 0,
        description: 'Cheddar cheese on grilled sourdough bread',
        imageUrl: 'https://example.com/grilled_cheese.jpg',
        price: 6.99,
        menuId: 23,
      ),
      DBMenuItemInsertRequest(
        name: 'Turkey Club',
        discount: 0,
        description:
            'Turkey, bacon, lettuce, tomato, and mayo on toasted wheat bread',
        imageUrl: 'https://example.com/turkey_club.jpg',
        price: 9.99,
        menuId: 23,
      ),
      DBMenuItemInsertRequest(
        name: 'Reuben',
        discount: 0,
        description:
            'Corned beef, Swiss cheese, sauerkraut, and Thousand Island dressing on rye bread',
        imageUrl: 'https://example.com/reuben.jpg',
        price: 8.99,
        menuId: 23,
      ),
    ],
  ];

  static final abc = _fakeMenuItemInsert.expand((element) => element).toList();

  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert1 =
      fakeMenusInsert[0];
  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert2 =
      fakeMenusInsert[1];
  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert3 =
      fakeMenusInsert[2];
  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert4 =
      fakeMenusInsert[3];
  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert5 =
      fakeMenusInsert[4];
  static final List<DBMenuInsertRequest> fakeMenuRestaurantInsert6 =
      fakeMenusInsert[5];
}
