// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biomasse/ValorizationUtils.dart';
import 'package:biomasse/main.dart';

void main() {

  test("Valorization", () {
      var matrixValorisation = getDummyValorizations();
      expect(getValorisationFromCharacteristics(matrixValorisation, 17, 89, 8), "Digestion anaérobique");
      expect(getValorisationFromCharacteristics(matrixValorisation, 48, 17, 99), "Pyrolyse");
      expect(getValorisationFromCharacteristics(matrixValorisation, 95, 8, 4), "Pyrolyse");

      expect(getValorisationFromCharacteristics(matrixValorisation, 11, 74, 92), "Digestion anaérobique");
      expect(getValorisationFromCharacteristics(matrixValorisation, 16, 34, 91), "Combustion");
  });

  test("Valorization threshold", () {
    var matrixValorisation = getDummyValorizations();
    expect(getValorisationFromCharacteristics(matrixValorisation, 38, 54, 7), "Combustion");
  });

  test("Valorization threshold 2", () {
    var matrixValorisation = getDummyValorizations();
    expect(getValorisationFromCharacteristics(matrixValorisation, 2, 57, 59), "Combustion");
  });
}
