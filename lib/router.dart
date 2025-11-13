import "package:go_router/go_router.dart";
import "package:its_aa_pn_2025_cross_platform/counter_page/pages/counter_page.dart";
import "package:its_aa_pn_2025_cross_platform/home_page.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "router.g.dart";

@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: "/counter",
        builder: (context, state) {
          return const CounterPage();
        },
      ),
    ],
  );
  ref.onDispose(router.dispose);

  return router;
}
