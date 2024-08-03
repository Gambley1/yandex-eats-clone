import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context, String number) async {
  final decodedNumber = Uri.decodeComponent(number);
  return switch (context.request.method) {
    HttpMethod.post => await _onPostRequest(context, decodedNumber),
    HttpMethod.put => await _onPutRequest(context, decodedNumber),
    HttpMethod.delete => await _onDeleteRequest(context, decodedNumber),
    _ => Response().methodNotAllowed(),
  };
}

Future<Response> _onPostRequest(RequestContext context, String number) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final expiryDate = body['expiry_date'] as String?;
  final cvv = body['cvv'] as String?;

  if (expiryDate == null || cvv == null) return Response().badRequest();

  final cardView = await db.dbcreditCards.query(
    const FindUserCreditCardByNumber(),
    QueryParams(values: {'user_id': user.id, 'number': number}),
  );
  if (cardView != null) {
    await db.dbcreditCards.updateCreditCard(
      number: number,
      cvv: cvv,
      expiryDate: expiryDate,
      card: cardView,
    );
    final updatedCardView = await db.dbcreditCards.query(
      const FindUserCreditCardByNumber(),
      QueryParams(values: {'user_id': user.id, 'number': number}),
    );
    final updatedCard = CreditCard.fromView(updatedCardView!);
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'credit_card': updatedCard.toJson()},
    );
  }
  final insert = DBCreditCardInsertRequest(
    number: number,
    expiryDate: expiryDate,
    cvv: cvv,
    userId: user.id,
  );
  await db.dbcreditCards.insertOne(insert);

  final createdCardView = await db.dbcreditCards.query(
    const FindUserCreditCardByNumber(),
    QueryParams(values: {'user_id': user.id, 'number': number}),
  );
  final createdCard = CreditCard.fromView(createdCardView!);
  return Response.json(
    statusCode: HttpStatus.created,
    body: {'credit_card': createdCard.toJson()},
  );
}

Future<Response> _onDeleteRequest(RequestContext context, String number) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final crediCard = await db.dbcreditCards.query(
    const FindUserCreditCardByNumber(),
    QueryParams(values: {'user_id': user.id, 'number': number}),
  );
  if (crediCard == null) return Response().notFound();

  await db.dbcreditCards.deleteOne(crediCard.id);
  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onPutRequest(RequestContext context, String number) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final expiryDate = body['expiry_date'] as String?;
  final cvv = body['cvv'] as String?;

  if (expiryDate == null && cvv == null) return Response().badRequest();

  final card = await db.dbcreditCards.query(
    const FindUserCreditCardByNumber(),
    QueryParams(values: {'user_id': user.id, 'number': number}),
  );
  if (card == null) return Response().notFound();
  await db.dbcreditCards.updateCreditCard(
    number: number,
    cvv: cvv,
    expiryDate: expiryDate,
    card: card,
  );
  return Response(statusCode: HttpStatus.created);
}
