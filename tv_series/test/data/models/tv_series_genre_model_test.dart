import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/domain/entities/genre.dart';

void main() {
  const tGenreModel = GenreModel(
    id: 1,
    name: 'name',
  );

  const tGenre = Genre(
    id: 1,
    name: 'name',
  );

  final tGenreJson = {
    "id": 1,
    "name": 'name',
  };

  test('should be a subclass of Genre entity', () async {
    final result = tGenreModel.toEntity();
    expect(result, tGenre);
  });
  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = tGenreJson;
    // act
    final result = GenreModel.fromJson(jsonMap);
    // assert
    expect(result, tGenreModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tGenreModel.toJson();
    // assert
    final expectedJsonMap = tGenreJson;
    expect(result, expectedJsonMap);
  });
}
