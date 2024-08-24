import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class Paginator extends StatelessWidget {
  const Paginator({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    required this.totalPages,
  });
  final int currentIndex;
  final void Function(int) onPageChanged;
  final int totalPages;
  @override
  Widget build(BuildContext context) {
    return NumberPagination(
      pageInit: currentIndex + 1,
      onPageChanged: onPageChanged,
      pageTotal: totalPages,
      threshold: 4,
      colorSub: Colors.white,
      colorPrimary: Colors.black,
    );
  }
}
