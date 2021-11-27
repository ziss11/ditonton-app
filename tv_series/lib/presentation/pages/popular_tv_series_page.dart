import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/cubit/tv_series_popular_cubit.dart';
import 'package:tv_series/presentation/widget/tv_card_list.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tv';
  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvSeriesPopularCubit>().fetchPopularTv(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesPopularCubit, TvSeriesPopularState>(
          builder: (context, data) {
            if (data is TvSeriesPopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is TvSeriesPopularLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    tvSeries: data.popularTvSeries[index],
                  );
                },
                itemCount: data.popularTvSeries.length,
              );
            } else if (data is TvSeriesPopularError) {
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
