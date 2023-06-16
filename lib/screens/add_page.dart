import 'package:anotacao/services/notes_service.dart';
import 'package:anotacao/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class AddNewNotes extends StatefulWidget {
  final Map? notes;
  const AddNewNotes({
    super.key,
    this.notes,
  });

  @override
  State<AddNewNotes> createState() => _AddNewNotesSate();
}

class _AddNewNotesSate extends State<AddNewNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final notes = widget.notes;
    if (notes != null) {
      isEdit = true;
      final title = notes['title'];
      final description = notes['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Editar Nota' : 'Adicionar Notas',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Título'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Descrição'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Atualizar' : 'Enviar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // obtem os dados do formulário
    final notes = widget.notes;
    if (notes == null) {
      print('Você não pode chamar atualização sem dados de notas');
      return;
    }
    final id = notes['_id'];

    //enviar e atualizar dados para o servidor
    final isSuccess = await NotesServices.updateNote(id, body);

    if (isSuccess) {
      print('Sucesso: Registro atualizado com sucesso');
      showSuccessMessage(context, message: 'Anotação Atualizada');
    } else {
      print('Erro: Atualização Falhou');
      showErrorMessage(context, message: 'Erro ao atualizar Anotação');
    }
  }

  Future<void> submitData() async {
    //Enviar dados ao servidor
    final isSuccess = await NotesServices.addNote(body);
    //mostrar mensagem de sucesso ou falha com base no status
    if (isSuccess) {
      print('Sucesso: Registro criado com sucesso');
      //print(response.body);
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage(context, message: 'Anotação Criada');
    } else {
      print('Erro: Criação Falhou');
      //print(response.body);
      showErrorMessage(context, message: 'Erro ao criar Anotação');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
