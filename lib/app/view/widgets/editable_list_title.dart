// app/view/widgets/editable_list_title.dart
import 'package:flutter/material.dart';

class EditableListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function(String)? onSubmitted;

  const EditableListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subtitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing && widget.onSubmitted != null) {
      widget.onSubmitted!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 253, 253).withOpacity(0.5),
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(253, 1, 51, 44).withOpacity(0.50),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        onTap: _toggleEdit,
        leading: Icon(widget.icon, color: Colors.blueAccent),
        title: _isEditing
            ? TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.title,
                ),
                onSubmitted: (_) => _toggleEdit(),
              )
            : Text(widget.title),
        subtitle: Text(_controller.text),
        trailing: Icon(_isEditing ? Icons.check : Icons.edit),
      ),
    );
  }
}
