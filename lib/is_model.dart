// import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

class IsModel {
//These are the values that this Demo model can store
  String baslik = '';
  String aciliyet = '';
  String aciklama = '';
  String uuid = '';
  bool starCheck = false;
  Icon leadingIcon = Icon(Icons.star_border);
  bool isRemoved = false;

  IsModel(String baslikString, String aciliyetString, String aciklama,
      String id, bool starCheck, Icon leadingIcon, bool isRemoved) {
    baslik = baslikString;
    aciliyet = aciliyetString;
    aciklama = aciklama;
    uuid = id;
    starCheck = starCheck;
    leadingIcon = leadingIcon;
    isRemoved = isRemoved;
  }

  void isRemovedList(bool selection) {
    isRemoved = selection;
  }
}
