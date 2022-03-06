part of add_article;
int selectedResourceIndex;

class ResourcePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResourcePickerState();
  }
}

class _ResourcePickerState extends State<ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: _colorCollection.length - 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(_nameCollection.isEmpty
                    ? "Empty list"
                    : _nameCollection[index]),
                onTap: () {
                  setState(() {
                    selectedResourceIndex = index;
                  });

                  // ignore: always_specify_types
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // When task is over, close the dialog
                    Navigator.pop(context);
                  });
                },
              );
            },
          )),
    );
  }
}
