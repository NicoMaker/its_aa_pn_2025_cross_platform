import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/misc.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_list.dart";
import "package:its_aa_pn_2025_cross_platform/models.dart";
import "package:its_aa_pn_2025_cross_platform/rick_and_morty_api.dart";
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";
import "package:talker_riverpod_logger/talker_riverpod_logger.dart";

void main() {
  runApp(
    ProviderScope(
      // a simple logger for riverpod states
      // you can ignore this if you don't want it
      observers: [
        TalkerRiverpodObserver(
          settings: const TalkerRiverpodLoggerSettings(
            printProviderDisposed: true,
          ),
        ),
      ],
      // a configuration that denies retries when a provider fails
      // you can ignore this if you don't want it
      retry: (retryCount, error) {
        return null;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
        ),
      ),
      home: const FbiWantedApp(),
    );
  }
}

class FbiWantedApp extends ConsumerStatefulWidget {
  const FbiWantedApp({
    super.key,
  });

  @override
  ConsumerState<FbiWantedApp> createState() => _RickAndMortyAppState();
}

class _RickAndMortyAppState extends ConsumerState<FbiWantedApp> {
  @override
  Widget build(BuildContext context) {
    final wantedList = ref.watch(fbiListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty Episodes"),
      ),
      body: switch (wantedList) {
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncError() => const Center(
          child: Text("qualcosa è andato storto, riprova più tardi"),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final wantedPerson in value)
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return FbiWantedPersonDetailsDialog(wantedPerson);
                      },
                    );
                  },
                  child: Column(
                    children: [
                      if (wantedPerson.previewImage case final value?)
                        Image.network(
                          value,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image);
                          },
                        )
                      else
                        const Text("no images found"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      },
    );
  }
}

class FbiWantedPersonDetailsDialog extends StatelessWidget {
  const FbiWantedPersonDetailsDialog(
    this.wanted, {
    super.key,
  });
  final FbiModel wanted;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const .symmetric(
        horizontal: 480,
        vertical: 96,
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(wanted.displayDetails),
              Text(wanted.displayReason),
              SizedBox(
                height: size.height * 0.4,
                child: ListView(
                  scrollDirection: .horizontal,
                  children: [
                    for (final image in wanted.images) //
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(image),
                      ),
                  ],
                ),
              ),
              Text(wanted.displayAge),
              Text(wanted.displayHeight),
              Text(wanted.displayWeight),
              Text(wanted.displayReward),
            ],
          ),
        ),
      ),
    );
  }
}

final FutureProviderFamily<RickAndMortyResponse, String?> rickAndMortyProvider =
    FutureProvider.autoDispose.family<RickAndMortyResponse, String?>((ref, query) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchCharacters(query: query);

      return result;
    });

final FutureProviderFamily<EpisodeResponseList, String?> episodesProvider = FutureProvider
    .autoDispose
    .family<EpisodeResponseList, String?>((ref, query) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);
      final result = await api.fetchEpisodes(query: query);

      return result;
    });

final FutureProviderFamily<CharacterResponse, int> characterProvider = FutureProvider
    .autoDispose
    .family<CharacterResponse, int>((ref, id) async {
      final logger = TalkerDioLogger();
      final client = Dio();
      ref.onDispose(client.close);
      client.interceptors.add(logger);
      final api = RickAndMortyApi(client);

      await Future<void>.delayed(const Duration(seconds: 4));
      final result = await api.fetchCharacterById(id);

      return result;
    });
