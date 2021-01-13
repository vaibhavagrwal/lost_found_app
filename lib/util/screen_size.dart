import 'package:flutter/material.dart';

const defaultWidth = 375.0;
const defaultHeight = 812.0;
const defaultSize = Size(375.0, 812.0);

class ScreenSize {
  final double _width;
  final double _height;
  static double _pwidth =
      -1; //to store width so that static functions can have access to the width and private so that it itself doesn't get changed and -1 to indicate uninitialised state
  static double _pheight =
      -1; //to store height so that static functions can have access to the height and private so that it itself doesn't get changed and -1 to indicate uninitialised state
  static double _widthMultiplyingFactor = 1;
  static double _heightMultiplyingFactor = 1;
  ScreenSize(this._width, this._height) {
    _pwidth = _width;
    _pheight = _height;
    _widthMultiplyingFactor = _width / defaultWidth;
    _heightMultiplyingFactor = _height / defaultHeight;
  }

  static double get pwidth => _pwidth;

  static double get pheight => _pheight;

  static double get heightMultiplyingFactor => _heightMultiplyingFactor;

  static double get widthMultiplyingFactor => _widthMultiplyingFactor;
}
