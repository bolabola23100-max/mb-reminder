import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/core/widgets/card_widget.dart';
import 'package:mb_reminder/features/details/screens/details_screen.dart';

class YoutubeScreen extends StatefulWidget {
  final String? sharedLink;

  const YoutubeScreen({super.key, this.sharedLink});

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  final Box box = Hive.box('mb_reminder_box');

  List<String> items = [];

  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    items = List<String>.from(box.get('youtube_folders') ?? []);
  }

  void _addItem() {
    controller.clear();

    showDialog(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return AlertDialog(
          title: const Text('اسم الملف'),

          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'اكتب الاسم هنا'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم الملف';
                }

                return null;
              },
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final name = controller.text.trim();

                setState(() {
                  items.add(name);
                });

                box.put('youtube_folders', items);

                controller.clear();

                Navigator.pop(context);
              },
              child: Text('إضافة', style: TextStyle(color: colors.primary)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),

        child: SingleChildScrollView(
          child: Column(
            children: [
              CardWidget(
                icons: AppIcons.youtube,
                items: items,
                onTap: (index) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        item: items[index],
                        sharedLink: widget.sharedLink,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'youtube_fab',
        backgroundColor: colors.primary,
        onPressed: _addItem,
        child: Icon(Icons.add, color: colors.onPrimary),
      ),
    );
  }
}
