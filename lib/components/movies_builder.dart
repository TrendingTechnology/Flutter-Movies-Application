import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:news_api/networking/connection.dart';
import 'package:news_api/states/loadingstate.dart';
import 'package:news_api/states/themestate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../constants.dart';
import 'movie screen/genres.dart';
import 'movie_card.dart';
import 'package:provider/provider.dart';

class MoviesBuilder extends StatelessWidget {
  const MoviesBuilder({
    @required this.scrollController,
    @required this.itemCount,
    @required this.sizingInformation,
    @required this.data,
    @required this.widgetOrigin,
    @required this.scrollDirection,
    @required this.rowCount,
    this.progressColor,
    this.onRefresh,
    this.refreshController,
  }) : assert(
          scrollController != null &&
              itemCount != null &&
              sizingInformation != null &&
              sizingInformation != null &&
              data != null &&
              widgetOrigin != null &&
              scrollDirection != null &&
              rowCount != null,
          'Required fields are missing',
        );
  final ScrollController scrollController;
  final int itemCount;
  final SizingInformation sizingInformation;
  final dynamic data;
  final Color progressColor;
  final String widgetOrigin;
  final Axis scrollDirection;
  final int rowCount;
  final Function onRefresh;
  final RefreshController refreshController;

  @override
  Widget build(BuildContext context) {
    var loader = context.watch<SetLoading>();
    var themeState = context.watch<SetThemeState>();
    return sizingInformation.isMobile || sizingInformation.isTablet
        ? SmartRefresher(
            controller: refreshController,
            onRefresh: onRefresh,
            header: WaterDropMaterialHeader(
              distance: 120,
              color: themeState.selectedTheme == ThemeSelected.dark
                  ? const Color(0xFFEC1E79)
                  : const Color(0xff16213e),
              backgroundColor: themeState.selectedTheme == ThemeSelected.dark
                  ? const Color(0xff16213e)
                  : const Color(0xFF198FD8),
              offset: 5,
            ),
            child: GridView.builder(
              controller: scrollController,
              scrollDirection: scrollDirection,
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowCount,
              ),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Hero(
                  tag: '${data['results'][index]['id']}+$widgetOrigin',
                  child: MovieCard(
                    rating:
                        '${data['results'][index]['vote_average'].toString()}/10',
                    genres: getGenres(data['results'][index]['genre_ids'],
                                    sizingInformation)
                                .length >
                            2
                        ? getGenres(data['results'][index]['genre_ids'],
                                sizingInformation)
                            .sublist(0, 2)
                        : getGenres(data['results'][index]['genre_ids'],
                            sizingInformation),
                    percentage: (data['results'][index]['popularity'])
                        .floor()
                        .toDouble(),
                    ratingBannerColor: Colors.red.withOpacity(0.5),
                    voteCount: data['results'][index]['vote_count'],
                    title: data['results'][index]['original_name'] != null
                        ? data['results'][index]['original_name'].length > 10
                            ? data['results'][index]['original_name']
                                .toString()
                                .substring(0, 10)
                            : data['results'][index]['original_name']
                        : data['results'][index]['title'].length > 10
                            ? data['results'][index]['title']
                                .toString()
                                .substring(0, 10)
                            : data['results'][index]['title'],
                    date: data['results'][index]['release_date'],
                    image: baseImgUrl + data['results'][index]['poster_path'],
                    borderColor: const Color(0xFFe0dede).withOpacity(0.5),
                    overlayColor: selectedTheme == ThemeSelected.light
                        ? const Color(0xFF198FD8).withOpacity(0.7)
                        : const Color(0xFF1b262c).withOpacity(0.93),
                    textColor: Colors.white,
                    elevation: selectedTheme == ThemeSelected.light ? 11 : 10,
                    shadowColor: selectedTheme == ThemeSelected.light
                        ? Colors.black
                        : Colors.white,
                    overlayHeight: sizingInformation.isMobile ? 105 : 115,
                    onTap: () async {
                      loader.toggleLoading();
                      var movieDetails =
                          await getMovie(data['results'][index]['id']);
                      var movieCredits = await getCredits(movieDetails['id']);
                      loader.toggleLoading();
                      await Get.toNamed('/movie',
                          arguments: [
                                movieDetails,
                                movieCredits,
                                index,
                                widgetOrigin
                              ] ??
                              '');
                    },
                  ),
                ),
              ),
            ),
          )
        : GridView.builder(
            controller: scrollController,
            scrollDirection: scrollDirection,
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowCount,
            ),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: '${data['results'][index]['id']}+$widgetOrigin',
                child: MovieCard(
                  rating:
                      '${data['results'][index]['vote_average'].toString()}/10',
                  genres: getGenres(data['results'][index]['genre_ids'],
                                  sizingInformation)
                              .length >
                          2
                      ? getGenres(data['results'][index]['genre_ids'],
                              sizingInformation)
                          .sublist(0, 2)
                      : getGenres(data['results'][index]['genre_ids'],
                          sizingInformation),
                  percentage:
                      (data['results'][index]['popularity']).floor().toDouble(),
                  ratingBannerColor: Colors.red.withOpacity(0.5),
                  voteCount: data['results'][index]['vote_count'],
                  title: data['results'][index]['original_name'] != null
                      ? data['results'][index]['original_name'].length > 10
                          ? data['results'][index]['original_name']
                              .toString()
                              .substring(0, 10)
                          : data['results'][index]['original_name']
                      : data['results'][index]['title'].length > 10
                          ? data['results'][index]['title']
                              .toString()
                              .substring(0, 10)
                          : data['results'][index]['title'],
                  date: data['results'][index]['release_date'],
                  image: baseImgUrl + data['results'][index]['poster_path'],
                  borderColor: const Color(0xFFe0dede).withOpacity(0.5),
                  overlayColor: selectedTheme == ThemeSelected.light
                      ? const Color(0xFF198FD8).withOpacity(0.7)
                      : const Color(0xFF1b262c).withOpacity(0.93),
                  textColor: Colors.white,
                  elevation: selectedTheme == ThemeSelected.light ? 11 : 10,
                  shadowColor: selectedTheme == ThemeSelected.light
                      ? Colors.black
                      : Colors.white,
                  overlayHeight: sizingInformation.isMobile ? 105 : 115,
                  onTap: () async {
                    loader.toggleLoading();
                    var movieDetails =
                        await getMovie(data['results'][index]['id']);
                    var movieCredits = await getCredits(movieDetails['id']);
                    loader.toggleLoading();
                    await Get.toNamed('/movie',
                        arguments: [
                              movieDetails,
                              movieCredits,
                              index,
                              widgetOrigin
                            ] ??
                            '');
                  },
                ),
              ),
            ),
          );
  }
}
