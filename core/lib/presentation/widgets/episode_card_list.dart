import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeCardList extends StatefulWidget {
  final int id;
  final int season;

  const EpisodeCardList({
    Key? key,
    required this.id,
    required this.season,
  }) : super(key: key);

  @override
  State<EpisodeCardList> createState() => _EpisodeCardListState();
}

class _EpisodeCardListState extends State<EpisodeCardList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvSeriesDetailNotifier>(context, listen: false)
            .fetchTvSeriesEpisode(widget.id, widget.season));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TvSeriesDetailNotifier>(
      builder: (context, eps, child) => ListView.builder(
          key: const Key('episode_list'),
          scrollDirection: Axis.horizontal,
          itemCount: eps.episodeTvSeries.length,
          itemBuilder: (context, index) {
            final data = eps.episodeTvSeries[index];
            return Container(
              width: 350,
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGrey,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: data.stillPath.isEmpty
                        ? const SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.error),
                          )
                        : CachedNetworkImage(
                            imageUrl: '$baseImageUrl${data.stillPath}',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Episode ${data.episodeNumber}',
                          style: kHeading6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data.name,
                          style: kBodyText.copyWith(
                            color: kMikadoYellow,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          data.overview,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
