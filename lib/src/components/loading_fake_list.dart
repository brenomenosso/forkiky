import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingFakeList extends StatelessWidget {
  final int? length;
  final bool showSubTitle;
  
  const LoadingFakeList({
    super.key, 
    this.length = 20,
    this.showSubTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: length,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.purple.withOpacity(0.2),
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            right: 8,
            left: 0,
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.white,
          ),
          title: Container(
            height: 20,
            color: Colors.white,
            width: 100,
          ),
          subtitle: showSubTitle
              ? Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 20,
                  color: Colors.white,
                  child: const SizedBox(
                    width: 60,
                    height: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
