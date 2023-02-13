import 'package:auto_route/auto_route.dart';
import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/widget/request_widget/request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:keframe/keframe.dart';

import '../../common/netease_api/src/api/play/bean.dart';
import '../../common/netease_api/src/api/search/bean.dart';
import '../../common/netease_api/src/dio_ext.dart';
import '../../common/netease_api/src/netease_handler.dart';
import '../../widget/app_bar.dart';
import '../../widget/custom_filed.dart';
import '../../widget/mobile/flashy_navbar.dart';
import '../../widget/request_widget/request_loadmore_view.dart';
import '../../widget/simple_extended_image.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _search = TextEditingController();
  final PageController _pageController = PageController();
  int _selectIndex = 0;
  List<FlashyNavbarItem> items = [
    FlashyNavbarItem(icon: const Icon(TablerIcons.brand_tiktok)),
    FlashyNavbarItem(icon: const Icon(TablerIcons.playlist)),
    FlashyNavbarItem(icon: const Icon(TablerIcons.disc)),
    FlashyNavbarItem(icon: const Icon(TablerIcons.users)),
  ];

  String searchContent = '';

  DioMetaData searchSongDioMetaData(String keyword, int type, {bool cloudSearch = true, int offset = 0, int limit = 30}) {
    var params = {'s': keyword, 'type': type, 'limit': limit, 'offset': offset};
    return DioMetaData(_searchUrl(cloudSearch), data: params, options: joinOptions());
  }

  DioMetaData searchHotKeyDioMetaData() {
    return DioMetaData(joinUri('/weapi/search/hot'), data: {'type': 1111}, options: joinOptions(userAgent: UserAgent.Mobile));
  }

  Uri _searchUrl(bool cloudSearch) => cloudSearch ? joinUri('/weapi/cloudsearch/pc') : joinUri('/weapi/search/get');

  @override
  void initState() {
    super.initState();
    _search.addListener(listener);
  }

  listener() {
    if (_search.text.isEmpty) {
      setState(() {
        searchContent = '';
      });
    }
  }

  @override
  void dispose() {
    _search.removeListener(listener);
    _search.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
      backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 0.w,
          leading: const SizedBox.shrink(),
          title: CustomFiled(
            iconData: TablerIcons.search,
            textEditingController: _search,
            hitText: '输入歌曲、歌手、歌单...',
            textInputAction: TextInputAction.search,
            onSubmitted: (String value) {
              if (value.isNotEmpty) {
                searchContent = value;
                setState(() {});
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
              icon: const Icon(TablerIcons.x),
              iconSize: 54.w,
            )
          ],
        ),
        body: FrameSeparateWidget(
            child: Visibility(
                visible: searchContent.isNotEmpty,
                replacement: RequestWidget<SearchKeyWrapX>(
                    dioMetaData: searchHotKeyDioMetaData(),
                    childBuilder: (data) => FrameSeparateWidget(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
                          child: Wrap(
                            children: data.result.hots
                                .map((e) => InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 15.w),
                                        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
                                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary, borderRadius: BorderRadius.circular(30.w)),
                                        child: Text(
                                          e.first ?? '',
                                          style: TextStyle(fontSize: 26.sp),
                                        ),
                                      ),
                                      onTap: () {
                                        _search.text = e.first ?? '';
                                        searchContent = _search.text;
                                        setState(() {});
                                      },
                                    ))
                                .toList(),
                          ),
                        ))),
                child: FrameSeparateWidget(
                    child: Column(
                  children: [
                    Expanded(
                        child: FrameSeparateWidget(
                            child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectIndex = index;
                        });
                      },
                      children: [
                        FrameSeparateWidget(child: _buildSongSearchView()),
                        FrameSeparateWidget(child: _buildPlayListSearchView()),
                        FrameSeparateWidget(child: _buildAlbumSearchView()),
                        FrameSeparateWidget(child: _buildArtistsSearchView()),
                      ],
                    ))),
                    FrameSeparateWidget(
                        child: Container(
                      padding: EdgeInsets.only(bottom: 20.w),
                      child: FlashyNavbar(
                        height: 90.h,
                        selectedIndex: _selectIndex,
                        backgroundColor: Theme.of(context).cardColor.withOpacity(1),
                        items: items,
                        onItemSelected: (int index) {
                          _pageController.jumpToPage(index);
                        },
                      ),
                    ))
                  ],
                )))),
      ),
      onHorizontalDragDown: (e) {},
    );
  }

  Widget _buildSongSearchView() {
    return FrameSeparateWidget(child: RequestLoadMoreWidget<SearchSongWrapX, Song2>(
      dioMetaData: searchSongDioMetaData(searchContent, 1),
      childBuilder: (List<Song2> songs) {
        var list = Home.to.song2ToMedia(songs);
        return ListView.builder(
          itemExtent: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          itemBuilder: (context, index) => FrameSeparateWidget(child: InkWell(
            child: SizedBox(
              height: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    list[index].title,
                    maxLines: 1,
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 3.w)),
                  Text(
                    list[index].artist ?? '',
                    style: TextStyle(fontSize: 24.sp, color: Colors.grey),
                  )
                ],
              ),
            ),
            onTap: () {
              Home.to.playByIndex(
                index,
                'search${DateTime.now().millisecondsSinceEpoch}',
                mediaItem: list.length > 500 ? list.sublist(0, 499) : list,
              );
            },
          )),
          itemCount: list.length,
        );
      },
      listKey: const ['result', 'songs'],
    ));
  }

  Widget _buildPlayListSearchView() {
    return RequestLoadMoreWidget<SearchPlaylistWrapX, Play>(
      dioMetaData: searchSongDioMetaData(searchContent, 1000),
      childBuilder: (List<Play> playlist) {
        return FrameSeparateWidget(child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemExtent: 120.w,
          itemBuilder: (context, index) => FrameSeparateWidget(child: InkWell(
            child: SizedBox(
              height: 120.w,
              child: Row(
                children: [
                  SimpleExtendedImage(
                    '${playlist[index].coverImgUrl ?? ''}?param=200y200',
                    width: 85.w,
                    height: 85.w,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              playlist[index].name ?? '',
                              maxLines: 1,
                              style: TextStyle(fontSize: 28.sp),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 3.w)),
                            Text(
                              '${playlist[index].trackCount ?? 0} 首',
                              style: TextStyle(fontSize: 26.sp, color: Colors.grey),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            onTap: () {
              // context.router.push(const PlayListView().copyWith(args: playlist[index]));
            },
          )),
          itemCount: playlist.length,
        ));
      },
      listKey: const ['result', 'playlists'],
    );
  }

  Widget _buildAlbumSearchView() {
    return RequestLoadMoreWidget<SearchAlbumsWrapX, Album>(
      dioMetaData: searchSongDioMetaData(searchContent, 10),
      childBuilder: (List<Album> playlist) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemExtent: 120.w,
          itemBuilder: (context, index) => InkWell(
            child: SizedBox(
              height: 120.w,
              child: Row(
                children: [
                  SimpleExtendedImage(
                    '${playlist[index].picUrl ?? ''}?param=200y200',
                    width: 85.w,
                    height: 85.w,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          playlist[index].name ?? '',
                          maxLines: 1,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.w)),
                        Text(
                          '${playlist[index].artist?.name}',
                          style: TextStyle(fontSize: 26.sp, color: Colors.grey),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
          itemCount: playlist.length,
        );
      },
      listKey: const ['result', 'albums'],
    );
  }

  Widget _buildArtistsSearchView() {
    return RequestLoadMoreWidget<SearchArtistsWrapX, Artists>(
      dioMetaData: searchSongDioMetaData(searchContent, 100),
      childBuilder: (List<Artists> playlist) {
        return ListView.builder(
          itemExtent: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemBuilder: (context, index) => InkWell(
            child: SizedBox(
              height: 120.w,
              child: Row(
                children: [
                  SimpleExtendedImage(
                    '${playlist[index].picUrl ?? ''}?param=200y200',
                    width: 85.w,
                    height: 85.w,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          playlist[index].name ?? '',
                          maxLines: 1,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.w)),
                        Text(
                          '${playlist[index].albumSize}',
                          style: TextStyle(fontSize: 26.sp, color: Colors.grey),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            onTap: () {
              // context.router.push(const ArtistsView().copyWith(args: playlist[index]));
            },
          ),
          itemCount: playlist.length,
        );
      },
      listKey: const ['result', 'artists'],
    );
  }
}
