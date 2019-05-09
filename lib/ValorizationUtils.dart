import 'package:tuple/tuple.dart';

String getValorisationFromCharacteristics(List<Tuple4<int,int,int,String>> matrix, double char1, double char2, double char3){

  var savedThreshold1 = -1;
  var savedThreshold2 = -1;
  var savedThreshold3 = -1;
  var savedOutcome = "";

  for(var entry in matrix){

      if(entry.item1 == -1) return entry.item4;
      if(entry.item1 >= char1 && (savedThreshold1 == -1 || savedThreshold1 == entry.item1)){
        savedThreshold1 = entry.item1;

        if(entry.item2 == -1) return entry.item4;
        if(entry.item2 >= char2 && (savedThreshold2 == -1 || savedThreshold2 == entry.item2)){
          savedThreshold2 = entry.item2;

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
  list.add(new Tuple4(2, 48, 57, "Combustion"));
  list.add(new Tuple4(2, 57, -1, "Combustion"));
  list.add(new Tuple4(2, -1, -1, "Combustion"));

  list.add(new Tuple4(10, 1, -1, "Pyrolyse"));
  list.add(new Tuple4(10, 30, -1, "Combustion"));
  list.add(new Tuple4(10, 90, -1, "Digestion anaérobique"));
  list.add(new Tuple4(10, -1, -1, "Digestion anaérobique"));

  list.add(new Tuple4(17, 44, -1, "Combustion"));
  list.add(new Tuple4(17, 89, -1, "Digestion anaérobique"));
  list.add(new Tuple4(17, -1, -1, "Digestion anaérobique"));

  list.add(new Tuple4(20, 1, -1, "Combustion"));
  list.add(new Tuple4(20, 50, -1, "Fermentation"));
  list.add(new Tuple4(20, 70, -1, "Digestion anaérobique"));
  list.add(new Tuple4(20, 75, -1, "Combustion"));
  list.add(new Tuple4(20, -1, -1, "Combustion"));

  list.add(new Tuple4(90, 1, 1, "Digestion anaérobique"));
  list.add(new Tuple4(90, 9, 80, "Digestion anaérobique"));
  list.add(new Tuple4(90, 30, 1, "Fermentation"));
  list.add(new Tuple4(90, 30, 50, "Pyrolyse"));
  list.add(new Tuple4(90, -1, -1, "Combustion"));


  list.add(new Tuple4(95, -1, -1, "Pyrolyse"));

  return list;
}