import 'package:core/data/models/tv_series/episode_model.dart';
import 'package:equatable/equatable.dart';

class EpisodeResponse extends Equatable {
  final List<EpisodeModel> episodeList;

  const EpisodeResponse({required this.episodeList});

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) =>
      EpisodeResponse(
        episodeList: List<EpisodeModel>.from(
            (json["episodes"] as List).map((x) => EpisodeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "episodes": List<dynamic>.from(episodeList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [episodeList];
}
