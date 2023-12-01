import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getximagewebhp/create_image.dart';
import 'package:getximagewebhp/update_controller.dart';
import 'package:getximagewebhp/update_image.dart';
import 'package:getximagewebhp/upload_controller.dart';

class ShowImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UploadController uc = Get.put(UploadController());
    UpdateController up = Get.put(UpdateController());
    return Scaffold(
        appBar: AppBar(
          title: Text('Show Image'),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child:  IconButton(onPressed: () {
                Get.to(CreateImage());
              }, icon: Icon(Icons.create_new_folder_outlined)),
            )

          ],
        ),
        body: Obx(() => uc.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: uc.todos.value.length,
                itemBuilder: (BuildContext contex, int index) {
                  // ${index+1}
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Image.network('http://192.168.128.97:5000/images/${uc.todos.value[index].pimg}',fit: BoxFit.fill,),
                        ),
                        title: Text(
                          '${uc.todos.value[index].pname}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        subtitle: Text(
                          "${uc.todos.value[index].pdesc}",
                          style: TextStyle(fontSize: 10),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(UpdateImage(),arguments: [
                                "${uc.todos.value[index].pimg}",
                                "${uc.todos.value[index].id}",
                                "${uc.todos.value[index].pname}",
                                "${uc.todos.value[index].pprice}",
                                "${uc.todos.value[index].pdesc}"
                                ]);
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.yellowAccent,
                            ),
                            IconButton(
                            onPressed: () {
                            uc.deleteImage("${uc.todos.value[index].id}");
                            // Get.snackbar("Hapus data product", controller.message.value);
                            },
                            icon: Icon(Icons.delete,),
                            color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )));
  }
}
