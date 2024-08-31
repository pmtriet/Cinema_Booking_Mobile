import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieCard extends StatefulWidget {
  const MovieCard(
      {super.key,
      required this.movieId,
      required this.movieName,
      required this.movieCategory,
      this.movieImgUrl});
  final int movieId;
  final String movieName;
  final String movieCategory;
  final String? movieImgUrl;
  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  String defaultMovieImg = 'assets/images/movieImgUrl.png';
  @override
  Widget build(BuildContext context) {
    double movieItemWidth = MediaQuery.sizeOf(context).width / 2.3;
    double movieItemHeigh = movieItemWidth * 1.4;
    return InkWell(
      onTap: () {
        context.push(
            '${RouteName.movieDetail}/${widget.movieId}/${widget.movieName}');
      },
      child: Card(
        color: const Color(backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(
                height: movieItemHeigh,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: widget.movieImgUrl == null
                      ? Image.asset(
                          defaultMovieImg,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.movieImgUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              defaultMovieImg,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movieName,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.movieCategory,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xff637394)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
