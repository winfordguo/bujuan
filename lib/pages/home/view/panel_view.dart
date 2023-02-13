import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/widget/mobile/flashy_navbar.dart';
import 'package:bujuan/widget/simple_extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../common/constants/other.dart';
import '../../../common/constants/platform_utils.dart';
import '../../../widget/my_get_view.dart';
import '../../../widget/swipeable.dart';

class PanelView extends GetView<Home> {
  const PanelView({Key? key}) : super(key: key);

  //进度

  @override
  Widget build(BuildContext context) {
    double bottomHeight = MediaQuery.of(controller.buildContext).padding.bottom * (PlatformUtils.isIOS ? 0.4 : 0.8);
    if (bottomHeight == 0) bottomHeight = 20.w;
    return MyGetView(
      child: _buildDefaultBody(context),
    );
  }

  Widget _buildSlide(BuildContext context) {
    print('_buildSlide');
    return Container(
      padding: EdgeInsets.only(left: 60.w, right: 60.w, bottom: 50.w),
      height: 100.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            addAutomaticKeepAlives: false,
            cacheExtent: 1.3,
            addRepaintBoundaries: false,
            addSemanticIndexes: false,
            itemBuilder: (context, index) => Obx(() => Container(
                  margin: EdgeInsets.symmetric(vertical: controller.mEffects[index]['size'] / 2, horizontal: 5.w),
                  decoration: BoxDecoration(color: controller.bodyColor.value, borderRadius: BorderRadius.circular(4)),
                  width: 1.8,
                )),
            itemCount: controller.mEffects.length,
          ),
          Obx(() => ProgressBar(
                progress: controller.duration.value,
                buffered: controller.duration.value,
                total: controller.mediaItem.value.duration ?? const Duration(seconds: 10),
                progressBarColor: Colors.transparent,
                baseBarColor: Colors.transparent,
                bufferedBarColor: Colors.transparent,
                thumbColor: controller.bodyColor.value.withOpacity(.18),
                barHeight: 0.w,
                thumbRadius: 20.w,
                barCapShape: BarCapShape.square,
                timeLabelType: TimeLabelType.remainingTime,
                timeLabelLocation: TimeLabelLocation.none,
                timeLabelTextStyle: TextStyle(color: controller.bodyColor.value, fontSize: 28.sp),
                onSeek: (duration) {
                  controller.audioServeHandler.seek(duration);
                },
              ))
        ],
      ),
    );
  }

  // height:329.h-MediaQuery.of(context).padding.top,
  Widget _buildPlayController(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => controller.likeSong(),
              icon: Obx(() => Icon(controller.likeIds.contains(int.tryParse(controller.mediaItem.value.id)) ? TablerIcons.heartbeat : TablerIcons.heart,
                  size: 46.w, color: controller.bodyColor.value))),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => IconButton(
                  onPressed: () {
                    if (controller.fm.value) {
                      return;
                    }
                    if (controller.intervalClick(1)) {
                      controller.audioServeHandler.skipToPrevious();
                    }
                  },
                  icon: Icon(
                    TablerIcons.player_skip_back,
                    size: 46.w,
                    color: controller.bodyColor.value,
                  ))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: InkWell(
                  child: Obx(() => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 5.h),
                        height: 105.h,
                        width: 105.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.w),
                          border: Border.all(color: controller.bodyColor.value.withOpacity(controller.second.value ? 0 : .08), width: 5.w),
                          // color: controller.bodyColor.value.withOpacity(0.1),
                        ),
                        child: Icon(
                          controller.playing.value ? TablerIcons.player_pause : TablerIcons.player_play,
                          size: 54.w,
                          color: controller.bodyColor.value,
                        ),
                      )),
                  onTap: () => controller.playOrPause(),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (controller.intervalClick(1)) {
                      controller.audioServeHandler.skipToNext();
                    }
                  },
                  icon: Obx(() => Icon(
                        TablerIcons.player_skip_forward,
                        size: 46.w,
                        color: controller.bodyColor.value,
                      ))),
            ],
          )),
          IconButton(
              onPressed: () {
                if (controller.fm.value) {
                  return;
                }
                controller.changeRepeatMode();
              },
              icon: Obx(() => Icon(
                    controller.getRepeatIcon(),
                    size: 43.w,
                    color: controller.bodyColor.value,
                  ))),
        ],
      ),
    ));
  }

  // Widget functionWidget({required Widget child}) {
  //   return Container(child: child);
  // }

  Widget _buildBottom(bottomHeight, context) {
    return SizedBox(
      height: 120.w + bottomHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Obx(() => Container(
                width: 70.w,
                height: 8.w,
                margin: EdgeInsets.only(top: 12.w),
                decoration: BoxDecoration(color: controller.bodyColor.value.withOpacity(.3), borderRadius: BorderRadius.circular(4.w)),
              )),
          FlashyNavbar(
            height: 120.w,
            selectedIndex: 0,
            items: [
              FlashyNavbarItem(icon: const Icon(TablerIcons.atom_2)),
              FlashyNavbarItem(icon: const Icon(TablerIcons.playlist)),
              FlashyNavbarItem(icon: const Icon(TablerIcons.quote)),
              FlashyNavbarItem(icon: const Icon(TablerIcons.message_2)),
            ],
            onItemSelected: (index) {
              controller.selectIndex.value = index;
              if (!controller.panelController.isPanelOpen) controller.panelController.open();
            },
            backgroundColor: controller.bodyColor.value,
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              child: Container(
                height: MediaQuery.of(context).padding.bottom,
                width: Get.width,
                color: Colors.transparent,
              ),
              onVerticalDragEnd: (e) {},
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return Stack(
      children: [
        Obx(() => Visibility(
          visible: controller.background.value.isEmpty,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
            ),
          ),
        )),
        Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  !controller.panelOpenPositionThan1.value && !controller.second.value
                      ? Theme.of(context).scaffoldBackgroundColor.withOpacity(.3)
                      : !controller.gradientBackground.value
                          ? controller.rx.value.dominantColor?.color.withOpacity(.7) ?? Colors.transparent
                          : controller.rx.value.lightVibrantColor?.color.withOpacity(.7) ??
                              controller.rx.value.lightMutedColor?.color.withOpacity(.7) ??
                              controller.rx.value.dominantColor?.color.withOpacity(.7) ??
                              Colors.transparent,
                  controller.rx.value.dominantColor?.color.withOpacity(.7) ?? Colors.transparent,
                ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
              ),
            )),
        Obx(() => Visibility(
              visible: controller.background.value.isNotEmpty,
              child: BackdropFilter(
                  /// 过滤器
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  /// 必须设置一个空容器
                  child: Container()),
            )),
        _buildBodyContent(context),
      ],
    );
  }

  Widget _buildDefaultBody1(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          return Visibility(
            visible: controller.panelOpenPositionThan1.value,
            child: SimpleExtendedImage(
              controller.mediaItem.value.extras!['image'] + '?param=500y500',
              fit: BoxFit.cover,
              height: Get.height,
              width: Get.width,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
            ),
          );
        }),

        // Container(
        //   color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
        // ),
        // ClipRRect(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
        //   child: BackdropFilter(
        //     /// 过滤器
        //     filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        //
        //     /// 必须设置一个空容器
        //     child: _buildBodyContent(context),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDefaultPanel(BuildContext context, bottomHeight) {
    return Stack(
      children: [
        // Obx(() {
        //   return SimpleExtendedImage(controller.mediaItem.value.extras!['image']+ '?param=500y500',fit: BoxFit.cover,height: Get.height,width: Get.width,
        //     borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),);
        // }),
        // Container(
        //   color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
        // ),
        // Obx(() => Visibility(
        //       replacement: AnimatedContainer(
        //         duration: const Duration(milliseconds: 300),
        //         decoration: BoxDecoration(
        //           color: controller.rx.value.dominantColor?.color ?? Colors.transparent,
        //           borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
        //         ),
        //       ),
        //       visible: controller.gradientBackground.value,
        //       child: AnimatedContainer(
        //           duration: const Duration(milliseconds: 300),
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(colors: [
        //               controller.rx.value.dominantColor?.color ?? Colors.transparent,
        //               !controller.gradientBackground.value
        //                   ? controller.rx.value.dominantColor?.color ?? Colors.transparent
        //                   : controller.rx.value.lightVibrantColor?.color ??
        //                       controller.rx.value.lightMutedColor?.color ??
        //                       controller.rx.value.dominantColor?.color ??
        //                       Colors.transparent,
        //             ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
        //             borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
        //           )),
        //     )),
        // ClipRRect(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
        //   child: BackdropFilter(
        //     /// 过滤器
        //     filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        //
        //     /// 必须设置一个空容器
        //     child: _buildPanelContent(context, bottomHeight),
        //   ),
        // ),
        // BackdropFilter(
        //   /// 过滤器
        //   filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        //
        //   /// 必须设置一个空容器
        //   child: _buildPanelContent(context, bottomHeight),
        // ),
        // FrameSeparateWidget(child:  Obx(() {
        //   return Visibility(
        //     visible: !controller.leftImage.value,
        //     replacement: Container(
        //       color: Colors.transparent,
        //     ),
        //     child: AnimatedContainer(
        //       duration: const Duration(milliseconds: 300),
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(colors: [
        //           !controller.panelOpenPositionThan1.value && !controller.second.value
        //               ? Theme.of(context).bottomAppBarColor.withOpacity(controller.leftImage.value ? 0 : .7)
        //               : !controller.gradientBackground.value
        //               ? controller.rx.value.dominantColor?.color.withOpacity(.7) ?? Colors.transparent
        //               : controller.rx.value.lightVibrantColor?.color.withOpacity(.7) ??
        //               controller.rx.value.lightMutedColor?.color.withOpacity(.7) ??
        //               controller.rx.value.dominantColor?.color.withOpacity(.7) ??
        //               Colors.transparent,
        //           controller.rx.value.dominantColor?.color.withOpacity(.7) ?? Colors.transparent,
        //         ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
        //         borderRadius: BorderRadius.only(topLeft: Radius.circular(25.w), topRight: Radius.circular(25.w)),
        //       ),
        //     ),
        //   );
        // })),
        _buildPanelContent(context, bottomHeight),
      ],
    );
  }

  Widget _buildPanelContent(BuildContext context, bottomHeight) {
    return Container();
    // return Padding(
    //   padding: EdgeInsets.only(top: 120.w + bottomHeight),
    //   child: Obx(() => IndexedStack(
    //   index: controller.selectIndex.value,
    // children: controller.pages,
    // ),),
    // child: PageView.builder(
    //   itemBuilder: (context, index) => controller.pages[index],
    //   itemCount: controller.pages.length,
    //   controller: controller.pageController,
    //   physics: const NeverScrollableScrollPhysics(),
    //   // preloadPagesCount: controller.pages.length,
    //   onPageChanged: (index) {
    //     controller.selectIndex.value = index;
    //   },
    // ),
    // );
  }

  Widget _buildBodyContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70.h + MediaQuery.of(context).padding.top,
        ),
        SizedBox(
          height: 100.w * 6.8,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          height: 100.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.mediaItem.value.title.fixAutoLines(),
                    style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: controller.bodyColor.value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
              Obx(() => Text(
                    (controller.mediaItem.value.artist ?? '').fixAutoLines(),
                    style: TextStyle(fontSize: 28.sp, color: controller.bodyColor.value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        ),
        // //操控区域
        _buildPlayController(context),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w, vertical: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    OtherUtils.getTimeStamp(controller.duration.value.inMilliseconds),
                    style: TextStyle(color: controller.bodyColor.value, fontSize: 28.sp),
                  )),
              Obx(() => Text(
                    OtherUtils.getTimeStamp(controller.mediaItem.value.duration?.inMilliseconds ?? 0),
                    style: TextStyle(color: controller.bodyColor.value, fontSize: 28.sp),
                  )),
            ],
          ),
        ),
        //进度条
        _buildSlide(context),
        // 功能按钮
        SizedBox(
          height: 130.w + MediaQuery.of(context).padding.bottom,
        ),
      ],
    );
  }

  Widget _buildPanelHeader(bottomHeight, context) {
    print('========_buildPanelHeader');
    return IgnorePointer(
      ignoring: controller.panelOpenPositionThan1.value && !controller.second.value,
      child: Visibility(
        replacement: GestureDetector(
          child: _buildPanelHeaderTo(bottomHeight, context),
          onHorizontalDragDown: (e) {},
          onTap: () {
            if (!controller.panelControllerHome.isPanelOpen) {
              controller.panelControllerHome.open();
            } else {
              if (controller.panelController.isPanelOpen) controller.panelController.close();
            }
          },
        ),
        visible: controller.panelOpenPositionThan8.value,
        child: GestureDetector(
          child: _buildPanelHeaderTo(bottomHeight, context),
          onHorizontalDragDown: (e) {},
          onVerticalDragDown: (e) {},
          onTap: () {
            if (!controller.panelControllerHome.isPanelOpen) {
              controller.panelControllerHome.open();
            } else {
              if (controller.panelController.isPanelOpen) controller.panelController.close();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPanelHeaderTo(bottomHeight, context) {
    return Stack(
      children: [
        Swipeable(
          onSwipeRight: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              controller.audioServeHandler.skipToPrevious();
            });
          },
          onSwipeLeft: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              controller.audioServeHandler.skipToNext();
            });
          },
          threshold: 120.w,
          background: const SizedBox.shrink(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _buildPlayBar(context),
          ),
        ),
        Positioned(
          bottom: 0,
          child: GestureDetector(
            child: Obx(() {
              print('底部高度');
              return Container(
                color: Colors.transparent,
                height: bottomHeight * (controller.panelOpenPositionThan1.value ? 0 : 1),
                width: Get.width,
              );
            }),
            onVerticalDragDown: (e) {},
          ),
        )
      ],
    );
  }

  Widget _buildPlayBar(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: controller.panelHeaderSize),
              child: Obx(
                () => RichText(
                  text: !controller.panelOpenPositionThan1.value || controller.second.value
                      ? TextSpan(
                          text: '${controller.mediaItem.value.title} - ',
                          children: [
                            TextSpan(
                              text: controller.mediaItem.value.artist ?? '',
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  color: controller.second.value ? controller.bodyColor.value : controller.getLightTextColor(context),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                          style: TextStyle(
                              fontSize: 28.sp, color: controller.second.value ? controller.bodyColor.value : controller.getLightTextColor(context), fontWeight: FontWeight.w500))
                      : const TextSpan(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )),
            FrameSeparateWidget(
                child: Obx(() => Visibility(
                      visible: !controller.panelOpenPositionThan1.value || controller.second.value,
                      child: IconButton(
                          onPressed: () => controller.playOrPause(),
                          icon: Obx(() => Icon(
                                controller.playing.value ? TablerIcons.player_pause : TablerIcons.player_play,
                                size: controller.playing.value ? 46.w : 42.w,
                                color: controller.second.value ? controller.bodyColor.value : controller.getLightTextColor(context),
                              ))),
                    ))),
            // ClassWidget(
            //     child: Obx(() => Visibility(
            //       visible: !controller.panelOpenPositionThan1.value || controller.second.value,
            //       child: IconButton(
            //           onPressed: () => controller.likeSong(),
            //           icon: Obx(() => Icon(
            //             controller.likeIds.contains(int.tryParse(controller.mediaItem.value.id)) ? TablerIcons.heartbeat : TablerIcons.heart,
            //             size: 46.w,
            //             color: controller.second.value ? controller.bodyColor.value : controller.getLightTextColor(context),
            //           ))),
            //     )))
          ],
        ),
        Obx(() => Container(
              height: controller.getImageSize() + 60.h * controller.slidePosition.value,
              padding: EdgeInsets.only(left: controller.getImageLeft(), top: 60.h * controller.slidePosition.value),
              child: SimpleExtendedImage(
                '${controller.mediaItem.value.extras?['image']}?param=500y500',
                fit: BoxFit.cover,
                height: controller.getImageSize(),
                width: controller.getImageSize(),
                borderRadius: BorderRadius.circular(controller.getImageSize() / 2 * (1 - controller.slidePosition.value * .88)),
              ),
            )),
      ],
    );
  }
}

class BottomItem {
  IconData iconData;
  int index;
  VoidCallback? onTap;

  BottomItem(this.iconData, this.index, {this.onTap});
}

extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}

// class ClassWidget extends StatelessWidget {
//   final Widget child;
//
//   const ClassWidget({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return FrameSeparateWidget(child: child);
//   }
// }

class ClassStatelessWidget extends StatelessWidget {
  final Widget child;

  const ClassStatelessWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
