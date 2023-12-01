import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'model_product.dart';

class UploadController extends GetxController {
   var base_url='http://192.168.128.97:5000/products/';

  TextEditingController pname = TextEditingController();
  TextEditingController pprice = TextEditingController();
  TextEditingController pdesc = TextEditingController();

  TextEditingController upname = TextEditingController();
  TextEditingController upprice = TextEditingController();
  TextEditingController updesc = TextEditingController();

  PlatformFile? imagepicked;
  RxBool isLoading = false.obs;
  RxBool Web = false.obs;
  File? fileToDisplayHp;
  // Uint8List? fileToDisplayWeb;
   Uint8List fileToDisplayWeb=Uint8List(0);

  var isWeb = kIsWeb.obs;
  String? fileName;

  Rx<List<Product>> todos = Rx<List<Product>>([]);

  String? selected;
  List<String> data = ["joni", "panjul", "sugeng"];

  @override
  void onInit() {
    super.onInit();
    showImage();
  }

  Future<void> pickImage() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null) {
        // _fileName = result.files.first.name;
        imagepicked = result.files.first;
        fileToDisplayHp = File(imagepicked!.path.toString());
        print(fileToDisplayHp);
        print(imagepicked!.name);
      }

      isLoading.value = false;
    } catch (e) {}
  }

  Future<void> pickImageWeb() async {
    try {
      // Web.value = true;
      isLoading.value = true;

      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;

      imagepicked = result.files.first;
      print(imagepicked);
      fileName = result.files.first.name;
      fileToDisplayWeb = Uint8List.fromList(imagepicked!.bytes!);
      // encode64 = base64Encode(fileToDisplayWeb!);
      // print(fileToDisplayWeb);

      isLoading.value = false;
    } catch (e) {}
  }

  uploadImage() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(base_url));
    request.fields['pname'] = pname.text;
    request.fields['pprice'] = pprice.text;
    request.fields['pdesc'] = pdesc.text;
    if(isWeb.value){
      request.files.add(http.MultipartFile.fromBytes('pimg', fileToDisplayWeb,
          filename: fileName));
    }else{
      request.files.add(await http.MultipartFile.fromPath('pimg', imagepicked!.path.toString()));
    }

    // request.files.add(picture);

    var response = await request.send();
    if (response.statusCode == 201) {
      pdesc.text = "";
      pprice.text = "";
      pname.text = "";

      Get.back();
      showImage();

      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status ${response.statusCode}');
    }
  }

  showImage() async {
    try {
      isLoading.value = true;
      todos.value.clear();
      var response =
          await http.get(Uri.parse(base_url));
      if (response.statusCode == 200) {
        isLoading.value = false;
        // todos.refresh();
        // print(json.decode(response.body));

        final content = json.decode(response.body);
        // print(content);
        for (var item in content) {
          todos.value.add(Product.fromJson(item));
          // print(todos.value.length);
        }
      } else {
        isLoading.value = false;
        print("something went wrong");
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  updateImage(String pname, String pprice, String pdesc, String id) async {
    isLoading.value = true;
    var request = http.MultipartRequest(
        "PATCH", Uri.parse(base_url+ id));
    isLoading.value = false;
    request.fields['pname'] =  upname.text;
    request.fields['pprice'] = upprice.text;
    request.fields['pdesc'] = updesc.text;

   if(isWeb.value){
     request.files.add(http.MultipartFile.fromBytes('pimg', fileToDisplayWeb));
   }else{
     request.files.add(await http.MultipartFile.fromPath('pimg', imagepicked!.path.toString()));
   }

   var response = await request.send();
    if (response.statusCode == 200) {
      isLoading.value = false;
      print('Image uploaded successfully');
      Get.back();
      showImage();
    } else {
      isLoading.value = false;
      print('Image upload failed with status ${response.statusCode}');
    }
  }

  deleteImage(String id)async{
    var response=await http.delete(Uri.parse(base_url + id));
    showImage();
    if (response.statusCode == 200) {
      isLoading.value = false;
      print('Image deleted successfully');
    } else {
      isLoading.value = false;
      print('Image deleted failed with status ${response.statusCode}');
    }
  }
}
