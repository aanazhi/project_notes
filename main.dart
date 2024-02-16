import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      
      create: (context) => NoteProvider(),
      child: const MaterialApp(
        home: NoteApp(),
      ),
    );
  }
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      appBar: AppBar(
        title: const Text('My notes'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          return provider.currentTab == TabType.personal ? const PersonalTab() :
                 provider.currentTab == TabType.noteGroup ? const NoteGroupTab() :
                 const NoteTab();
        },
      ),
      bottomNavigationBar: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            currentIndex: provider.currentTab.index,
            onTap: (index) {
              provider.changeTab(TabType.values[index]);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Личный кабинет',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Группа заметок',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note),
                label: 'Заметки',
              ),
            ],
          );
        },
      ),
    );
  }
}



class PersonalTab extends StatefulWidget {
  const PersonalTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = Provider.of<NoteProvider>(context, listen: false).email;
    nameController.text = Provider.of<NoteProvider>(context, listen: false).name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                onChanged: (value) {
                  Provider.of<NoteProvider>(context, listen: false).email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  Provider.of<NoteProvider>(context, listen: false).name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class NoteGroupTab extends StatelessWidget {
  const NoteGroupTab({super.key});

@override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 136, 163, 186),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 70,
        child: const Center(
          child: Text(
            'Учеба',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 152, 195, 153),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 70,
        child: const Center(
          child: Text(
            'Работа',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 199, 117, 144),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 70,
        child: const Center(
          child: Text(
            'Личное',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 197, 169, 113),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        height: 70,
        child: const Center(
          child: Text(
            'Прочее',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
        
      ],
    );
  }
}


class NoteTab extends StatefulWidget {
  const NoteTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteTabState createState() => _NoteTabState();
}

class _NoteTabState extends State<NoteTab> with AutomaticKeepAliveClientMixin {
  List<String> notes = [];
  List<Color> noteColors = [
    const Color.fromARGB(255, 152, 195, 153), 
  const Color.fromARGB(255, 199, 117, 144), 
  const Color.fromARGB(255, 136, 163, 186), 
  const Color.fromARGB(255, 197, 169, 113)];
  List<Color> noteBackgroundColors = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    noteBackgroundColors = List.generate(noteColors.length, (index) => noteColors[index % noteColors.length]);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Поиск заметок',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (text) {
            setState(() {
              searchText = text;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              notes.add('Новая заметка ${notes.length + 1}');
              noteBackgroundColors.add(noteColors[notes.length % noteColors.length]);
            });
          },
          child: const Text("Создать заметку"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              if (searchText.isNotEmpty && !notes[index].toLowerCase().contains(searchText.toLowerCase())) {
                return const SizedBox.shrink(); 
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                child: Container(
                  key: Key(notes[index]),
                  decoration: BoxDecoration(
                    color: noteBackgroundColors[index],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(notes[index])),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String editedNote = notes[index];
                              Color selectedColor = noteBackgroundColors[index];
                              return AlertDialog(
                                title: const Text('Редактировать заметку'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: TextEditingController(text: notes[index]),
                                      onChanged: (text) {
                                        editedNote = text;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    const Text('Выберите цвет заметки:'),
                                    Wrap(
                                      spacing: 8.0,
                                      children: noteColors.map((color) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor = color;
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            color: color,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        notes[index] = editedNote;
                                        noteBackgroundColors[index] = selectedColor;
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Готово'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            notes.removeAt(index);
                            noteBackgroundColors.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class NoteGroup {
  final String title;

  NoteGroup(this.title);
}

class Note {
  final String title;
  final String content;
  

  Note(this.title, this.content);
}



class NoteProvider with ChangeNotifier {
  TabType _currentTab = TabType.personal;
  final List<NoteGroup> _noteGroups = [];


  String email = '';
  String name = '';





  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  String getEmail() {
    return email;
  }

  String getName() {
    return name;
  }



  List<NoteGroup> getNoteGroups() {
    return _noteGroups;
  }

  TabType get currentTab => _currentTab;

  void changeTab(TabType tab) {
    _currentTab = tab;
    notifyListeners();
  }
}

enum TabType {
  personal,
  noteGroup,
  note,
}

