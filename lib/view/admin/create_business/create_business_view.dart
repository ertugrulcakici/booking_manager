import 'package:bookingmanager/view/admin/create_business/create_business_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBusinessView extends ConsumerStatefulWidget {
  const CreateBusinessView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBusinessViewState();
}

class _CreateBusinessViewState extends ConsumerState<CreateBusinessView> {
  ChangeNotifierProvider<CreateBusinessNotifier> provider =
      ChangeNotifierProvider((ref) => CreateBusinessNotifier());
  final TextEditingController _businessNameController =
      TextEditingController(text: "27. Region Horror House");

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create business")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(provider).save(businessName: _businessNameController.text);
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Business name",
                hintText: "Enter business name",
              ),
            ),
            // ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: ref.watch(provider).branches.length,
            //     itemBuilder: (context, index) => ListTile(
            //           onLongPress: () async {
            //             BranchModel? branchModel =
            //                 await NavigationService.toPage<BranchModel>(
            //                     BranchView(
            //                         branch:
            //                             ref.watch(provider).branches[index]));
            //             if (branchModel != null) {
            //               setState(() {
            //                 ref.read(provider).branches[index] = branchModel;
            //               });
            //             } else {
            //               log("branch did not updated:$branchModel");
            //             }
            //           },
            //           title: Text(ref.watch(provider).branches[index].name),
            //           trailing: IconButton(
            //             icon: const Icon(Icons.delete),
            //             onPressed: () {
            //               showDialog(
            //                   context: context,
            //                   builder: (context) => AlertDialog(
            //                         title: const Text("Delete the branch?"),
            //                         actions: [
            //                           TextButton(
            //                               onPressed: () {
            //                                 Navigator.of(context).pop();
            //                               },
            //                               child: const Text("No")),
            //                           TextButton(
            //                               onPressed: () {
            //                                 setState(() {
            //                                   ref
            //                                       .read(provider)
            //                                       .branches
            //                                       .removeAt(index);
            //                                 });
            //                                 Navigator.of(context).pop();
            //                               },
            //                               child: const Text("Yes")),
            //                         ],
            //                       ));
            //             },
            //           ),
            //         )),
            // ListTile(
            //   title: const Text("Add branch"),
            //   trailing: const Icon(Icons.add),
            //   onTap: () async {
            //     BranchModel? branchModel =
            //         await NavigationService.toPage<BranchModel>(
            //             const BranchView());
            //     if (branchModel != null) {
            //       setState(() {
            //         ref.read(provider).branches.add(branchModel);
            //       });
            //     } else {
            //       log("branch:$branchModel");
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
