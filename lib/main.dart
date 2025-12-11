import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:reactive_forms/reactive_forms.dart";
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
      home: const ReviewListWidget(),
    );
  }
}

class ReviewListWidget extends StatefulWidget {
  const ReviewListWidget({
    super.key,
  });

  @override
  State<ReviewListWidget> createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  List<Review> list = <Review>[];

  Future<void> addReview() async {
    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return const Dialog(child: EditReviewForm());
      },
    );

    if (result == null) return;

    final review = Review(
      title: result["title"]! as String,
      rating: result["rating"]! as int,
      comment: result["comment"] as String?,
    );

    setState(() {
      list.add(review);
    });
  }

  Future<Review?> editReview(int index) async {
    final currentReview = list[index];
    final result = await showDialog<Json>(
      context: context,
      builder: (context) {
        return Dialog(
          child: EditReviewForm(
            review: currentReview,
          ),
        );
      },
    );

    if (result == null) return null;

    final editedReview = Review(
      title: result["title"]! as String,
      rating: result["rating"]! as int,
      comment: result["comment"] as String?,
    );

    setState(() {
      list[index] = editedReview;
    });

    return editedReview;
  }

  void deleteReview(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  Future<void> openDetails(int index) async {
    final review = list[index];
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: ReviewDetailWidget(
            review: review,
            onDelete: () {
              deleteReview(index);
            },
            onEdit: () {
              return editReview(index);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("le nostre recensioni! 🎉"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addReview,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final (i, review) in list.indexed)
            ListTile(
              onTap: () {
                unawaited(openDetails(i));
              },
              title: Text(review.title),
              subtitle: switch (review.comment) {
                null => null,
                final value => Text(value),
              },
              leading: IconButton(
                onPressed: () {
                  unawaited(editReview(i));
                },
                icon: const Icon(Icons.edit),
              ),
              trailing: IconButton(
                onPressed: () {
                  deleteReview(i);
                },
                icon: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
    );
  }
}

class EditReviewForm extends StatefulWidget {
  const EditReviewForm({
    super.key,
    this.review,
  });
  final Review? review;

  @override
  State<EditReviewForm> createState() => _EditReviewFormState();
}

class _EditReviewFormState extends State<EditReviewForm> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      "title": FormControl<String>(
        value: widget.review?.title,
        validators: [
          Validators.required,
          Validators.minLength(2),
        ],
      ),
      "comment": FormControl<String>(
        value: widget.review?.comment,
      ),
      "rating": FormControl<int>(
        value: widget.review?.rating,
        validators: [
          Validators.required,
          Validators.min(1),
          Validators.max(5),
        ],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          ReactiveTextField<String>(
            formControlName: "title",
          ),
          ReactiveTextField<String>(
            formControlName: "comment",
          ),
          ReactiveTextField<int>(
            formControlName: "rating",
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return ElevatedButton.icon(
                onPressed: form.valid ? saveReview : null,
                icon: const Icon(Icons.save),
                label: const Text("salva"),
              );
            },
          ),
        ],
      ),
    );
  }

  void saveReview() {
    Navigator.pop(context, form.value);
  }
}

class ReviewDetailWidget extends StatefulWidget {
  const ReviewDetailWidget({
    required this.review,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });
  final Review review;
  final VoidCallback onDelete;
  final AsyncValueGetter<Review?> onEdit;

  @override
  State<ReviewDetailWidget> createState() => _ReviewDetailWidgetState();
}

class _ReviewDetailWidgetState extends State<ReviewDetailWidget> {
  late Review review;

  @override
  void initState() {
    super.initState();
    review = widget.review;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.review.title),
        actions: [
          IconButton(
            onPressed: editReview,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: deleteReview,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.review.comment case final value?) Text(value),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.review.rating; i++)
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              for (var i = 0; i < 5 - widget.review.rating; i++)
                const Icon(
                  Icons.star_border,
                  color: Colors.yellow,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteReview() {
    widget.onDelete();
    Navigator.pop(context);
  }

  Future<void> editReview() async {
    final edited = await widget.onEdit();
    if (edited == null) return;

    setState(() {
      review = edited;
    });
  }
}

class Review {
  Review({
    required this.title,
    required this.rating,
    this.comment,
  });
  String title;
  int rating;
  String? comment;
}

typedef Json = Map<String, Object?>;
