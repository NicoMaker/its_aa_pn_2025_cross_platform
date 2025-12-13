import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/dog_api.dart";
import "package:its_aa_pn_2025_cross_platform/dog_models.dart";
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";

final dioProvider = Provider.autoDispose<Dio>((ref) {
  final client = Dio();
  ref.onDispose(client.close);

  client.interceptors.add(TalkerDioLogger());

  return client;
});

final dogBreedsProvider = FutureProvider.autoDispose<DogBreedsResponse>((ref) async {
  final dio = ref.watch(dioProvider);
  final api = DogApi(dio);
  final breeds = await api.fetchBreeds();
  return breeds;
});

final dogImagesByBreedProvider = FutureProvider.autoDispose
    .family<DogBreedImagesResponse, String>((ref, breedId) async {
      final dio = ref.watch(dioProvider);
      final api = DogApi(dio);
      final images = await api.fetchImages(breedId);
      return images;
    });
