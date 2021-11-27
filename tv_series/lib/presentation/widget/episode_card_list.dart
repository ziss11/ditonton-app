import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';

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
    Future.microtask(
      () =>
          context.read<EpisodeCubit>().fetchEpisodeTv(widget.id, widget.season),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodeCubit, EpisodeState>(
      builder: (context, eps) {
        if (eps is EpisodeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (eps is EpisodeLoaded) {
          return ListView.builder(
            key: const Key('episode_list'),
            scrollDirection: Axis.horizontal,
            itemCount: eps.episode.length,
            itemBuilder: (context, index) {
              final data = eps.episode[index];
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
            },
          );
        } else if (eps is EpisodeInitial) {
          return const Center(
            key: Key('empty_message'),
            child: Text('Episode tidak ditemukan'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
