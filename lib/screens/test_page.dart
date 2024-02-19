import 'package:flutter/material.dart';
import 'package:todo/test_data.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

late TextEditingController nameController;
late TextEditingController addressController;
late TextEditingController ageController;
late GlobalKey<FormState> formKey;
late ScrollController scrollController;
String fullname = '';
String address = '';
String age = '';

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressController = TextEditingController();
    ageController = TextEditingController();
    formKey = GlobalKey<FormState>();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    ageController.dispose();
    scrollController.dispose();
  }

  TestData testData = TestData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Test'),
      ),
      body: FutureBuilder(
          future: testData.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Unable to fetch data'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data to display'),
                );
              } else {
                return ListView.builder(
                  key: const PageStorageKey<String>('items'),
                  controller: scrollController,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    List? snapshotData = snapshot.data;
                    var item = snapshotData?[index];
                    return Card(
                      margin:
                          EdgeInsets.fromLTRB(20, index == 0 ? 10 : 0, 20, 10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        leading: Text('${item['id']}'),
                        title: Text(item['fullname'] as String),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['address'] as String),
                            Text('${item['age']} years')
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () {
                                  customShowDialog(false);
                                },
                                child: const Row(
                                  children: [
                                    Text('Edit'),
                                    Spacer(),
                                    Icon(Icons.edit)
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm delete'),
                                          content: const Text(
                                              'Are you sure you want to delete the file?'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final response =
                                                    await testData.deleteData(
                                                        '${item['id']}');
                                                if (response) {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                  messenger('Recorded deleted');
                                                } else {
                                                  messenger(
                                                      'Unable to delete record');
                                                }
                                              },
                                              child: const Text('Delete'),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: const Row(
                                  children: [
                                    Text('Delete'),
                                    Spacer(),
                                    Icon(Icons.delete)
                                  ],
                                ),
                              )
                            ];
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text('Unknown error'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add info',
        onPressed: () {
          customShowDialog(true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  dataInputDialog(bool forAdd) {
    return Form(
      key: formKey,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(forAdd ? 'Add Info' : 'Update Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field is required';
                }

                return null;
              },
              controller: nameController,
              decoration: const InputDecoration(label: Text('Full Name')),
              onChanged: forAdd
                  ? null
                  : (value) {
                      setState(() => fullname = value);
                    },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field is required';
                }
                return null;
              },
              controller: addressController,
              decoration: const InputDecoration(label: Text('Address')),
              onChanged: forAdd
                  ? null
                  : (value) {
                      setState(() => address = value);
                    },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field is required';
                }
                if (int.parse(value) > 100 || int.parse(value) < 0) {
                  return 'Enter a valid age';
                }
                return null;
              },
              controller: ageController,
              decoration: const InputDecoration(
                label: Text('Age'),
              ),
              onChanged: forAdd
                  ? null
                  : (value) {
                      setState(() => age = value);
                    },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                Navigator.pop(context);
                loadingWidget();
                bool result = await testData.addData({
                  "fullname": nameController.text.trim(),
                  "address": addressController.text.trim(),
                  "age": ageController.text.trim(),
                });

                Navigator.pop(context);
                setState(() {});

                if (result) {
                  Future.delayed(
                      const Duration(seconds: 2),
                      () => {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn)
                          });

                  messenger('Record added');
                  nameController.clear();
                  addressController.clear();
                  ageController.clear();
                } else {
                  customShowDialog(true);
                }
              },
              child: Text(forAdd ? 'Add' : 'Update'))
        ],
      ),
    );
  }

  customShowDialog(bool forAdd) {
    showDialog(
        context: context,
        builder: (context) {
          return dataInputDialog(forAdd);
        });
  }

  messenger(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  loadingWidget() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
