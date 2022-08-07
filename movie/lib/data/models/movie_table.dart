import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';

// ignore: must_be_immutable
class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  String? type;

  MovieTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.type,
  });

  factory MovieTable.fromEntity(Movie movie) => MovieTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        type: movie.type,
      );

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        type: map['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'type': type,
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        type: type!,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview, type];
}
