import 'dart:convert';
import 'package:natanjir_mobile/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:natanjir_mobile/models/proizvod.dart';

class CartProvider {
  final int? userId;
  static const String _cartKeyPrefix = 'cart_';

  CartProvider(this.userId);

  Map<String, dynamic> _proizvodToMap(Proizvod proizvod) {
    return {
      'id': proizvod.proizvodId,
      'naziv': proizvod.naziv,
      'slika': proizvod.slika,
      'cijena': proizvod.cijena,
      'vrstaProizvodaId': proizvod.vrstaProizvodaId,
      'opis': proizvod.opis,
      'restoranId': proizvod.restoranId,
    };
  }

  Future<void> addToCart(Proizvod proizvod, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';

    Map<String, dynamic> cart = {};

    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;

      try {
        cart = Map<String, dynamic>.from(json.decode(cartData));
      } catch (e) {}
    }
    if (cart.isNotEmpty) {
      String firstProductKey = cart.keys.first;
      int existingRestoranId = cart[firstProductKey]['restoranId'];

      if (existingRestoranId != proizvod.restoranId) {
        throw new UserException(
            "Korpa može sadržavati proizvode iz samo jednog restorana.");
      }
    }
    String productId = proizvod.proizvodId.toString();

    if (cart.containsKey(productId)) {
      if (cart[productId]['kolicina'] != null) {
        cart[productId]['kolicina'] += quantity;
      } else {
        cart[productId]['kolicina'] = quantity;
      }
    } else {
      cart[productId] = {
        ..._proizvodToMap(proizvod),
        'kolicina': quantity,
      };
    }

    await prefs.setString(cartKey, json.encode(cart));
  }

  Future<Map<String, dynamic>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';

    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;

      try {
        return Map<String, dynamic>.from(json.decode(cartData));
      } catch (e) {}
    }

    return {};
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    await prefs.remove(cartKey);
  }

  Future<void> deleteProductFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';

    Map<String, dynamic> cart = {};

    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;

      try {
        cart = Map<String, dynamic>.from(json.decode(cartData));
      } catch (e) {}
    }

    if (cart.containsKey(productId.toString())) {
      cart.remove(productId.toString());
    }

    await prefs.setString(cartKey, json.encode(cart));
  }

  Future<void> updateCart(int productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';

    Map<String, dynamic> cart = {};

    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;

      try {
        cart = Map<String, dynamic>.from(json.decode(cartData));
      } catch (e) {}
    }

    if (cart.containsKey(productId.toString())) {
      cart[productId.toString()]['kolicina'] = quantity;
    }

    await prefs.setString(cartKey, json.encode(cart));
  }
}
