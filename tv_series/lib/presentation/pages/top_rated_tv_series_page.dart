import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/cubit/tv_series_top_rated_cubit.dart';
import 'package:tv_series/presentation/widget/tv_card_list.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';
  const TopRatedTvSeriesPage({super.key});

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TvSeriesTopRatedCubit>().fetchTopRatedTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesTopRatedCubit, TvSeriesTopRatedState>(
          builder: (context, data) {
            if (data is TvSeriesTopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is TvSeriesTopRatedLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    tvSeries: data.topRatedTv[index],
                  );
                },
                itemCount: data.topRatedTv.length,
              );
            } else if (data is TvSeriesTopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
