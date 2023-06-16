import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navegateEdit;
  final Function(String) deleteById;
  const NotesCard({
    super.key,
    required this.index,
    required this.item,
    required this.navegateEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              // Pagina de Edição
              navegateEdit(item);
            } else if (value == 'delete') {
              // Deletar e Remove o Item
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Editar'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Deletar'),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );
  }
}
