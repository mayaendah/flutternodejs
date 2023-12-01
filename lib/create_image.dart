import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getximagewebhp/upload_controller.dart';

class CreateImage extends StatelessWidget {
  const CreateImage({super.key});

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UploadController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Image'),
      ),
      body: Obx(
        () => Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: uc.isLoading.value
                    ? CircularProgressIndicator()
                    : uc.isWeb.value
                        ? ElevatedButton.icon(
                            onPressed: () {
                              uc.pickImageWeb();
                              uc.Web.value = true;
                            },
                            icon: Icon(Icons.image_outlined), label: Text('Pick Imageweb'),
                          )
                        : IconButton(
                            onPressed: () async {
                              uc.pickImage();
                              uc.Web.value = false;
                            },
                            icon: Icon(Icons.image_rounded),
                          ),
              ),
              if (uc.imagepicked != null)
                SizedBox(
                    height: 100,
                    width: 200,
                    child: uc.Web.value == false
                        ? Image.file(uc.fileToDisplayHp!)
                        : Image.memory(uc.fileToDisplayWeb)),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: uc.pname,
                decoration: InputDecoration(
                    label: Text("Product Name"), border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: uc.pprice,
                decoration: InputDecoration(
                    label: Text("Product Price"), border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: uc.pdesc,
                decoration: InputDecoration(
                    label: Text("Product Desc"), border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    uc.uploadImage();
                  },
                  child: Text('Save Image')),
              // ElevatedButton(
              //     onPressed: () {
              //       Get.to(()=>ShowImage());
              //     },
              //     child: Text('show Image')),
              Center(
                  child: DropdownButton(
                      value: uc.selected,
                      hint: Text('Pilih nama'),
                      items: uc.data
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        uc.selected = value;

                        print(value);
                      })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    clearButtonProps: ClearButtonProps(isVisible: true),
                    items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Menu mode",
                        hintText: "country in menu mode",
                      ),
                    ),
                    onChanged: (value) {
                      print(value);
                    },
                    selectedItem: "Brazil",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
