import 'package:anotacao/screens/add_page.dart';
import 'package:anotacao/services/notes_service.dart';
import 'package:anotacao/utils/snackbar_helper.dart';
import 'package:anotacao/widget/notes_card.dart';
import 'package:flutter/material.dart';

class NewNotesPage extends StatefulWidget {
  const NewNotesPage({super.key});

  @override
  State<NewNotesPage> createState() => _NewNotesPage();
}

class _NewNotesPage extends State<NewNotesPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Notes'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchNotes,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'Sem Anotações',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return NotesCard(
                  item: item,
                  index: index,
                  deleteById: deleteById,
                  navegateEdit: navigateToEditPage,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text('Adicionar Notas')),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddNewNotes(notes: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddNewNotes(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  Future<void> deleteById(String id) async {
    // Deleta o Registro
    final isSuccess = await NotesServices.deleteById(id);
    if (isSuccess) {
      // Remove o Registro da Lista
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // Erro ao Remover Registro
      showErrorMessage(context, message: 'Falha ao Deletar');
    }
  }

  Future<void> fetchNotes() async {
    final response = await NotesServices.fetchNote();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Algo deu errado');
    }

    setState(() {
      isLoading = false;
    });
  }
}
