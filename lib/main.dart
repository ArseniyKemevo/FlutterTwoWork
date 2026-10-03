import 'package:flutter/material.dart';

void main() => runApp(const NotesApp());

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF06292),
          primary: const Color(0xFFE91E63),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Color(0xFFBA68C8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF8BBD0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF8BBD0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
          ),
        ),
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> _notes = [];
  final TextEditingController _textController = TextEditingController();

  void _addNote() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() => _notes.add(text));
      _textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _deleteNote(int index) {
    setState(() => _notes.removeAt(index));
  }

  void _editNote(int index) {
    final controller = TextEditingController(text: _notes[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Редактировать заметку',
          style: TextStyle(color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Введите новый текст...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF06292)),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() => _notes[index] = text);
              }
              Navigator.pop(context);
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
          'Мои заметки',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC2185B)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFFFCE4EC))),
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
                    decoration: const InputDecoration(labelText: 'Введите текст заметки'),
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _addNote,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF06292),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Сохранить'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFFCE4EC), thickness: 1.5),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 48, color: Color(0xFFF48FB1)),
                          SizedBox(height: 8),
                          Text('Список пуст', style: TextStyle(color: Color(0xFFBA68C8), fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) => Card(
                        color: Colors.white,
                        elevation: 1.5,
                        shadowColor: const Color(0x33F48FB1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFFCE4EC)),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            _notes[index],
                            style: const TextStyle(color: Color(0xFF4A154B), fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, color: Color(0xFFF06292)),
                                onPressed: () => _editNote(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE57373)),
                                onPressed: () => _deleteNote(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}