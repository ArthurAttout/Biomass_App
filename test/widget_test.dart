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

  test("Ta mère", () {
    var matrixValorisation = getDummyValorizations();
    expect(getValorisationFromCharacteristics(matrixValorisation, 43, 3, 2), "Digestion anaérobique");
  });
//  test("Valorization threshold", () {
//    var matrixValorisation = getDummyValorizations();
//    expect(getValorisationFromCharacteristics(matrixValorisation, 38, 54, 7), "Custom");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 39, 54, 7), "Custom");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 38, 99, 1), "Custom");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 38, 0, 0), "Custom");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 43, 3, 2), "Digestion anaérobique");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 48, 17, 99), "Pyrolyse");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 11, 74, 92), "Digestion anaérobique");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 37, 52, 77), "Combustion 2");
//    expect(getValorisationFromCharacteristics(matrixValorisation, 80, 90, 94), "Pyrolyse");
//  });
}
