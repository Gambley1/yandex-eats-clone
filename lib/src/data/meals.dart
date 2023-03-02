import 'package:logger/logger.dart';

// enum MealType {
//   popular,
//   newArrivals,
//   cart,
// }

Logger logger = Logger();

// class Meals {
//   static final Iterable<Item> meals = [
//     Item(
//       id: 1,
//       name: 'Crispy Chicken',
//       price: 20,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Burger'),
//     ),
//     Item(
//       id: 2,
//       name: 'Big King',
//       price: 13,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Burger'),
//     ),
//     Item(
//       id: 3,
//       name: 'Whopper',
//       price: 12,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Burger'),
//     ),
//     Item(
//       id: 4,
//       name: 'Whooper mini',
//       price: 11,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Burger'),
//     ),
//     Item(
//       id: 5,
//       name: 'Ice Cream',
//       price: 4,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Ice Cream'),
//     ),
//     Item(
//       id: 6,
//       name: 'Burito',
//       price: 9,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Burito'),
//     ),
//     Item(
//       id: 7,
//       name: 'Pasta',
//       price: 14,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Pasta'),
//     ),
//     Item(
//       id: 8,
//       name: 'Cola',
//       price: 10,
//       description: 'Lorem ipsum',
//       categorie: Categorie(tag: 'Cola'),
//     ),
//     Item(
//       id: 9,
//       name: 'Chicken',
//       price: 12,
//       description: 'Awesome Chicken',
//       categorie: Categorie(tag: 'Chicken'),
//     ),
//     Item(
//       id: 10,
//       name: 'Pepperoni',
//       price: 16,
//       description: 'Awesome Pizza',
//       categorie: Categorie(tag: 'Pizza'),
//     ),
//     Item(
//       id: 11,
//       name: 'Margarita',
//       price: 16,
//       description: 'Awesome Pizza',
//       categorie: Categorie(tag: 'Pizza'),
//     ),
//   ];

//   static final _popular = [1, 2, 3, 4, 5, 6, 7];

//   static final _newArrivals = [2, 4, 6];

//   static final _cart = [1, 2, 5, 6];

//   static final newCart = meals.take(3);

//   static List<int> _getProductIds(MealType mealType) {
//     switch (mealType) {
//       case MealType.popular:
//         return _popular;
//       case MealType.newArrivals:
//         return _newArrivals;
//       case MealType.cart:
//         return _cart;
//     }
//   }

//   static Item getProductById(int productId) =>
//       meals.firstWhere((meal) => meal.id == productId);

//   static List<Item> getProducts(MealType mealType) {
//     final productIds = _getProductIds(mealType);
//     return productIds.map((id) => getProductById(id)).toList();
//   }

//   static List<Item> getProductsByTag(Categorie categorie) {
//     final categorieTag = categorie.tag;
//     if (categorieTag == 'All') {
//       final allProductsByTag = meals;
//       return allProductsByTag.toList();
//     } else {
//       final productByTag =
//           meals.where((product) => product.name == categorieTag).toList();
//       logger.d(productByTag);
//       return productByTag;
//     }
//   }

//   static restaurantsJson() {
//     return {
//       "restaurants": [
//         {
//           "id": 12345,
//           "name": "DoDo Pizza",
//           "tag": "Fast Food",
//           "menu": [
//             {
//               "id": 12345,
//               "name": "Burger",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 14.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 2.99,
//                 }
//               ]
//             },
//             {
//               "id": 12345,
//               "name": "Lunch",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 14.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 2.99,
//                 }
//               ]
//             }
//           ],
//         },
//         {
//           "id": 12666,
//           "name": "KFC",
//           "tag": "Fast Food",
//           "menu": [
//             {
//               "id": 12345,
//               "name": "Lunch",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 12.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 12.99,
//                 },
//               ]
//             },
//             {
//               "id": 12345,
//               "name": "Burger",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 14.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 2.99,
//                 }
//               ]
//             }
//           ],
//         },
//         {
//           "id": 12345,
//           "name": "McDonalds",
//           "tag": "Fast Food",
//           "menu": [
//             {
//               "id": 12345,
//               "name": "Burger",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 14.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 2.99,
//                 }
//               ]
//             },
//             {
//               "id": 12345,
//               "name": "Lunch",
//               "description": "a fun menu",
//               "items": [
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 14.99,
//                 },
//                 {
//                   "name": "nuff food",
//                   "description": "awasome!!",
//                   "price": 2.99,
//                 }
//               ]
//             }
//           ],
//         },
//       ]
//     };
//   }
// }
