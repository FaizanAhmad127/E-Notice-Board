import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/text_styles.dart';

class CacheImageService{

  CachedNetworkImage loadCacheImage(String url)
  {
    return CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) =>

          SizedBox(
            height: 250.h,
            width: 200.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Searching...",
                    style: kPoppinsBold700.copyWith(
                      fontSize: 16.sp,
                    ),),
                  ),
                ),
                SizedBox(height: 20.h,),
                CircularProgressIndicator(value: downloadProgress.progress),
              ],
            ),
          ),
      errorWidget: (context, url, error) {
        return  SizedBox(
          height: 100.h,
            width: 100.w,
            child: const Center(
              child: FittedBox(child: Text("No image found")),
            ));
      },
    );
  }
}