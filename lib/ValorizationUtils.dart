import 'package:tuple/tuple.dart';

String getValorisationFromCharacteristics(List<Tuple4<int,int,int,String>> matrix, int char1, int char2, int char3){

  var savedThreshold1 = -1;
  var savedThreshold2 = -1;
  var savedThreshold3 = -1;
  var savedOutcome = "Inconnu";

  print("Getting for");
  print(char1);
  print(char2);
  print(char3);
  print("****");

  // Je regarde dans la matrice
  // Colonne par colonne, je prends le premier enregistrement qui est
  // Plus grand ou égal à moi
  // Je reste TOUJOURS sur ce seuil
  // Je passe à la colonne suivante, et pareil
  // Si ma valeur dépasse le dernier seuil, on fallback sur l'actuel

  for(var entry in matrix){

      if(entry.item1 == -1) return entry.item4;
      if(entry.item1 >= char1 && (savedThreshold1 == -1 || savedThreshold1 == entry.item1)){
        savedThreshold1 = entry.item1;
        savedOutcome = entry.item4;

        if(entry.item2 == -1) return entry.item4;
        if(entry.item2 >= char2 && (savedThreshold2 == -1 || savedThreshold2 == entry.item2)){
          savedThreshold2 = entry.item2;
          savedOutcome = entry.item4;

          if(entry.item3 == -1) return entry.item4;
          savedOutcome = entry.item4;
        }
      }
  }
  return savedOutcome;
}

List<Tuple4<int,int,int,String>> getDummyValorizations(){
  var list = new List<Tuple4<int,int,int,String>>();

  list.add(new Tuple4(2, 1, -1, "Fermentation"));
  list.add(new Tuple4(2, 48, 1, "Fermentation"));
  list.add(new Tuple4(2, 48, 57, "Pyrolyse"));
  list.add(new Tuple4(2, 57, -1, "Combustion"));

  list.add(new Tuple4(10, 1, -1, "Pyrolyse"));
  list.add(new Tuple4(10, 30, -1, "Combustion"));
  list.add(new Tuple4(10, 90, -1, "Digestion anaérobique"));

  list.add(new Tuple4(17, 44, -1, "Combustion"));
  list.add(new Tuple4(17, 89, 8, "Digestion anaérobique"));

  list.add(new Tuple4(20, 1, -1, "Combustion"));
  list.add(new Tuple4(20, 50, -1, "Fermentation"));
  list.add(new Tuple4(20, 70, -1, "Digestion anaérobique"));
  list.add(new Tuple4(20, 75, -1, "Combustion"));

  list.add(new Tuple4(37, 54, 7, "Combustion 2"));
  list.add(new Tuple4(42, -1, -1, "Custom"));

  list.add(new Tuple4(90, 1, 1, "Digestion anaérobique"));
  list.add(new Tuple4(90, 9, 80, "Digestion anaérobique"));
  list.add(new Tuple4(90, 30, 1, "Fermentation"));
  list.add(new Tuple4(90, 30, 50, "Pyrolyse"));


  list.add(new Tuple4(99, 99, 99, "Fermentation"));

  return list;
}