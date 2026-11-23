import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const NotesApp());

class Note {
  String text;
  bool isImportant;

  Note({
    required this.text,
    this.isImportant = false,
  });
}

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  void addNote(String text) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty) {
      _notes.add(Note(text: trimmed));
      notifyListeners();
    }
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void editNote(int index, String newText) {
    final trimmed = newText.trim();
    if (trimmed.isNotEmpty) {
      _notes[index].text = trimmed;
      notifyListeners();
    }
  }

  void markAsImportant(int index) {
    if (!_notes[index].isImportant) {
      _notes[index].isImportant = true;
      notifyListeners();
    }
  }

  void restoreNormalStatus(int index) {
    if (_notes[index].isImportant) {
      _notes[index].isImportant = false;
      notifyListeners();
    }
  }
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: MaterialApp(
        title: 'Мои заметки',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF1744),
            secondary: Color(0xFFB0BEC5),
            surface: Color(0xFF16161A),
          ),
          scaffoldBackgroundColor: const Color(0xFF0B0B0E),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF16161A),
            labelStyle: const TextStyle(color: Color(0xFF9E9EA9)),
            hintStyle: const TextStyle(color: Color(0xFF6E6E7A)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF2A2A32)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF2A2A32)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF1744), width: 1.5),
            ),
          ),
        ),
        home: const NotesScreen(),
      ),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _textController = TextEditingController();

  void _addNote() {
    context.read<NotesProvider>().addNote(_textController.text);
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  void _viewNote(Note note) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF18181D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: note.isImportant
                ? const Color(0xFFFF1744)
                : const Color(0xFF2E2E38),
          ),
        ),
        title: Row(
          children: [
            Text(note.isImportant ? '⭐️ ' : '💀 '),
            Expanded(
              child: Text(
                note.isImportant ? 'Важная заметка' : 'Просмотр заметки',
                style: const TextStyle(
                  color: Color(0xFFF5F5F7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            note.text,
            style: const TextStyle(
              color: Color(0xFFD1D1D6),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF1744),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _editNote(int index, String currentText) {
    final controller = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF18181D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2E2E38)),
        ),
        title: const Text(
          '💀 Редактировать',
          style: TextStyle(
            color: Color(0xFFF5F5F7),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Введите текст...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Отмена', style: TextStyle(color: Color(0xFF8E8E9A))),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF1744),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<NotesProvider>().editNote(index, controller.text);
              Navigator.pop(dialogCtx);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '💀 МОИ ЗАМЕТКИ',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Color(0xFFF5F5F7),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF121216),
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFF25252D))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Новая заметка...'),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _addNote,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF1744),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Добавить',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF25252D), thickness: 1.5),
            Expanded(
              child: Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  final notes = notesProvider.notes;
                  if (notes.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('💀', style: TextStyle(fontSize: 54)),
                          SizedBox(height: 12),
                          Text(
                            'Пока тут пусто...',
                            style: TextStyle(
                              color: Color(0xFF8E8E9A),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Dismissible(
                        key: ObjectKey(note),
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF262630),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF454555)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Row(
                            children: [
                              Icon(Icons.restore_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Обычный статус',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB71C1C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Удалить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.delete_forever_rounded, color: Colors.white),
                            ],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // Свайп вправо -> сбрасываем статус важной и возвращаем карточку на место
                            notesProvider.restoreNormalStatus(index);
                            return false;
                          }
                          return true;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            notesProvider.deleteNote(index);
                          }
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          color: note.isImportant
                              ? const Color(0xFF291318)
                              : const Color(0xFF16161B),
                          elevation: 3,
                          shadowColor: note.isImportant
                              ? const Color(0x44FF1744)
                              : Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: note.isImportant
                                  ? const Color(0xFFFF1744)
                                  : const Color(0xFF282832),
                              width: note.isImportant ? 1.5 : 1.0,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: InkWell(
                            onTap: () => _viewNote(note),
                            onDoubleTap: () => notesProvider.markAsImportant(index),
                            onLongPress: () => _editNote(index, note.text),
                            child: ListTile(
                              leading: Text(
                                note.isImportant ? '⭐️' : '💀',
                                style: const TextStyle(fontSize: 22),
                              ),
                              title: Text(
                                note.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFFF2F2F7),
                                  fontSize: 16,
                                  fontWeight: note.isImportant
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Color(0xFF9E9EA9),
                                    ),
                                    onPressed: () => _editNote(index, note.text),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFFFF5252),
                                    ),
                                    onPressed: () => notesProvider.deleteNote(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}