import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getximagewebhp/update_controller.dart';
import 'package:getximagewebhp/upload_controller.dart';

class UpdateImage extends StatelessWidget {
  const UpdateImage({super.key});

  @override
  Widget build(BuildContext context) {
    // final uc = Get.find<UploadController>();
    final up = Get.find<UpdateController>();

    var data = Get.arguments;
    // print(data);

    if (data[2].isNotEmpty) {
      up.upname.text = data[2];
    }
    if (data[3].isNotEmpty) {
      up.upprice.text = data[3];
    }
    if (data[4].isNotEmpty) {
      up.updesc.text = data[4];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Image'),
      ),
      body: Obx(
        () => up.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    up.isWeb.value
                        ? Stack(children: [
                            up.upfileToDisplayWeb != null
                            // up.imgWeb==true
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.memory(
                                      up.upfileToDisplayWeb!,
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child:
                                    Image.network(
                                      'http://192.168.128.97:5000/images/${data[0]}',
                                      width: 100,
                                      height: 100,
                                    ),),

                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  up.upickImageWeb();
                                },
                                color: Colors.red,
                                iconSize: 20,
                                icon: Icon(Icons.camera),
                              ),
                              bottom: -10,
                              left: 4,
                              top: 0,
                              right: 0,
                            ),
                          ])
                        : Stack(children: [
                      up.upimagepicked != null

                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.file(
                                      up.upfileToDisplayHp!,
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child:
                                    Image.network(
                                      'http://192.168.128.97:5000/images/${data[0]}',
                                      width: 100,
                                      height: 100,
                                    ),),

                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  up.upickImage();
                                },
                                color: Colors.red,
                                iconSize: 20,
                                icon: Icon(Icons.camera),
                              ),
                              bottom: -10,
                              left: 4,
                              top: 0,
                              right: 0,
                            ),
                      ]),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: up.upname,
                      decoration: InputDecoration(
                          label: Text("Product Name"),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: up.upprice,
                      decoration: InputDecoration(
                          label: Text("Product Price"),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: up.updesc,
                      decoration: InputDecoration(
                          label: Text("Product Desc"),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                         // if(up.upfileToDisplayWeb==null){
                         //   up.netImage=data[0];
                         // }
                          up.updateImage(up.upname.text, up.upprice.text,
                              up.updesc.text, data[1],data[0]);
                        },
                        child: Text('Update Image'))
                  ],
                ),
              ),
      ),
    );
  }
}
