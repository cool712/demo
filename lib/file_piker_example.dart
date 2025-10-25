import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePikerExample extends StatefulWidget {
  const FilePikerExample({super.key});

  @override
  State<FilePikerExample> createState() => _FilePikerExampleState();
}

class _FilePikerExampleState extends State<FilePikerExample> {
  // 文件类型
  FileType _pickingType = FileType.any;
  // 选择的文件
  List<PlatformFile>? pickedFiles;
  // 文件信息
  Widget? _resultsWidget;
  // 是否可以选择多个文件
  bool _multiPick = false;
  void _pickFiles() async {
    try {
      pickedFiles = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        //allowedExtensions: ['doc'],
        withData: true,
      ))?.files;

      if (pickedFiles != null) {
        setState(() {
          _resultsWidget = _buildFilePickerResultsWidget(
            itemCount: pickedFiles?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final path = pickedFiles![index].path?.toString() ?? '无路径信息';
              return ListTile(
                leading: Text(
                  _pickingType.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                title: Text("文件路径:"),
                subtitle: Text(path),
              );
            },
          );
        });
      } else {
        setState(() {
          _resultsWidget = const Text(
            '用户取消了选择',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          );
        });
      }
    } catch (e) {
      setState(() {
        _resultsWidget = Text(
          '选择文件出错: $e',
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        );
      });
    }
  }

  void _selectFolder() async {
    try {
      final path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        setState(() {
          _resultsWidget = Text(
            '选择的文件夹: $path',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          );
        });
      } else {
        setState(() {
          _resultsWidget = const Text(
            '用户取消了选择',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          );
        });
      }
    } catch (e) {
      setState(() {
        _resultsWidget = Text(
          '选择文件夹出错: $e',
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        );
      });
    }
  }

  void _saveFile() async {
    // 检查是否有选中的文件
    if (pickedFiles == null || pickedFiles!.isEmpty) {
      // 如果没有选中的文件，显示提示信息
      setState(() {
        _resultsWidget = const Text(
          '请先选择文件再保存',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        );
      });
      return;
    }

    // 检查选中的第一个文件是否有字节数据
    if (pickedFiles!.first.bytes == null) {
      setState(() {
        _resultsWidget = const Text(
          '选中的文件没有字节数据，无法保存',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        );
      });
      return;
    }

    try {
      final path = await FilePicker.platform.saveFile(
        type: FileType.custom,
        fileName: 'file_picker_example',
        bytes: pickedFiles!.first.bytes,
      );

      if (path != null) {
        setState(() {
          _resultsWidget = Text(
            '文件保存路径: $path',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          );
        });
      } else {
        setState(() {
          _resultsWidget = const Text(
            '用户取消了保存操作',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          );
        });
      }
    } catch (e) {
      setState(() {
        _resultsWidget = Text(
          '保存文件出错: $e',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        );
      });
    }
  }

  Widget _buildFilePickerResultsWidget({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.50,
      child: ListView.separated(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文件选择器示例应用')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: DropdownButtonFormField(
                value: _pickingType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '文件类型',
                ),
                items: FileType.values.map((fileType) {
                  return DropdownMenuItem(
                    value: fileType,
                    child: Text(fileType.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _pickingType = value!;
                  });
                },
              ),
            ),
            Divider(),
            Text(
              '操作',
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  SizedBox(
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () => _pickFiles(),
                      label: Text(_multiPick ? '选择多个文件' : '选择文件'),
                      icon: const Icon(Icons.description),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          _multiPick = !_multiPick;
                        });
                      },
                      label: Text(_multiPick ? '单选模式' : '多选模式'),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () => _selectFolder(),
                      label: const Text('选择文件夹'),
                      icon: const Icon(Icons.folder),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FloatingActionButton.extended(
                      onPressed: () => _saveFile(),
                      label: const Text('保存文件'),
                      icon: const Icon(Icons.save_as),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Text(
              '结果',
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            _resultsWidget ??
                Text(
                  '请选择文件',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
