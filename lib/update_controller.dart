import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getximagewebhp/upload_controller.dart';
import 'package:http/http.dart' as http;

class UpdateController extends GetxController {

  final uc=Get.find<UploadController>();

  var base_url='http://192.168.128.97:5000/products/';

  TextEditingController upname = TextEditingController();
  TextEditingController upprice = TextEditingController();
  TextEditingController updesc = TextEditingController();

  PlatformFile? upimagepicked;
  RxBool isLoading = false.obs;
  RxBool Web = false.obs;
  RxBool imgWeb = true.obs;

  String netImage="";


  File? upfileToDisplayHp;


  Uint8List? upfileToDisplayWeb;
  // Uint8List upfileToDisplayWeb = Uint8List(0);

  var isWeb = kIsWeb.obs;
  String? fileName;

  Future<void> upickImage() async {
    try {
      isLoading.value = true;
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null) {
        // _fileName = result.files.first.name;
        upimagepicked = result.files.first;
        upfileToDisplayHp = File(upimagepicked!.path.toString());
        print(upfileToDisplayHp);
        print(upimagepicked!.name);
      }

      isLoading.value = false;
    } catch (e) {}
  }

  Future<void> upickImageWeb() async {
    try {
      // Web.value = true;
      isLoading.value = true;

      FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;

      upimagepicked = result.files.first;
      fileName = result.files.first.name;
      upfileToDisplayWeb = Uint8List.fromList(upimagepicked!.bytes!);
      // encode64 = base64Encode(fileToDisplayWeb!);
      // print(upfileToDisplayWeb);

      isLoading.value = false;
    } catch (e) {}
  }

  updateImage(String pname, String pprice, String pdesc, String id,String pimg) async {


    print(pimg);
    print(pname);
    print(pprice);
    print(pdesc);
    print(id);

    // print(upfileToDisplayWeb);
    //
    //
    isLoading.value = true;
    var request = http.MultipartRequest(
        "PATCH", Uri.parse(base_url+ id));
    isLoading.value = false;
    //
    request.fields['pname'] =  upname.text;
    request.fields['pprice'] = upprice.text;
    request.fields['pdesc'] = updesc.text;
    //
    //
    var oldImage=pimg;



    if(isWeb.value){
      if(upfileToDisplayWeb !=null){
      request.files.add(http.MultipartFile.fromBytes('pimg', upfileToDisplayWeb!,
          filename: fileName));}else{
        request.fields['pimg'] = oldImage;
      }
    }else{
      request.files.add(await http.MultipartFile.fromPath('pimg', upimagepicked!.path.toString()));
    }
    //
    var response = await request.send();

    if (response.statusCode == 200) {
      isLoading.value = false;
      print('Image updated successfully');
      Get.back();
      uc. showImage();
    } else {
      isLoading.value = false;
      print('Image updated failed with status ${response.statusCode}');
    }
  }
}