import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/ui/custom_widgets/custom_search_field/custom_search_field.dart';
import 'package:notice_board/ui/screens/marks_screen/marks_screen_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ii;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../core/models/result/marks_model.dart';
import 'coordinator_pending_marks_screen_vm.dart';

class CoordinatorPendingMarksScreen extends StatelessWidget {
  CoordinatorPendingMarksScreen({Key? key}) : super(key: key);

  double getFyp1Total(MarksModel marksModel, int index) {
    double result = 0;
    double obe2 = getObe2(marksModel, index);
    double obe3 = getObe3(marksModel, index);
    double obe4 = getObe4(marksModel, index);
    double fyp1Viva = marksModel.fyp1Viva;

    result = obe2 + obe3 + obe4 + fyp1Viva;

    return result;
  }

  double getObe2(MarksModel marksModel, int index) {
    double result = 0;
    marksModel.obe2.forEach((key, value) {
      result = result + value;
    });

    if (result > 0) {
      //taking average by sum of all marks given by teacher
      // and divide by no of teachers.
      result = result / marksModel.obe2.length;
      //obe2 has 10% in all Fyp1 marks which is 100
      result = (result / 16) * 10;
    }
    return double.parse(result.toStringAsFixed(1));
  }

  double getObe3(MarksModel marksModel, int index) {
    double result = 0;
    marksModel.obe3.forEach((key, value) {
      result = result + value;
    });
    if (result > 0) {
      //taking average by sum of all marks given by teacher
      // and divide by no of teachers.
      result = result / marksModel.obe3.length;
      //obe2 has 10% in all Fyp1 marks which is 100
      result = (result / 16) * 30;
    }
    return double.parse(result.toStringAsFixed(1));
  }

  double getObe4(MarksModel marksModel, int index) {
    double result = 0;
    marksModel.obe4.forEach((key, value) {
      result = result + value;
    });
    if (result > 0) {
      //taking average by sum of all marks given by teacher
      // and divide by no of teachers.
      result = result / marksModel.obe4.length;
      //obe2 has 10% in all Fyp1 marks which is 100
      result = (result / 16) * 20;
    }

    return double.parse(result.toStringAsFixed(1));
  }

  //Create an instance of ScreenshotController
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoordinatorMarksScreenVM(),
      builder: (context, viewModel) {
        return Consumer<CoordinatorMarksScreenVM>(builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.only(
                left: 0.05.sw,
                right: 0.05.sw,
                top: 0.035.sh,
                bottom: 0.01.sh,
              ),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [  
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 30,
                          )),
                      //   RepaintBoundary(
                      //   key: _printKey,
                      //   child:
                      //       // This is the widget that will be printed.
                      //       const FlutterLogo(
                      //     size: 300,
                      //   ),
                      // ),
                      InkWell(
                        onTap: () async {
                          takess();

                          await createPdfFile();

                          savePdfFile();
                        },
                        //_printScreen,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height * 0.040,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor),
                          child: Center(
                            child: Text(
                              'Print',
                              style: kPoppinsMedium500.copyWith(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  vm.userType != 'student'
                      ? CustomSearchField(
                          searchTextEditingController: vm.searchTFController,
                          hintText: 'Search By Name')
                      : const SizedBox(),
                  vm.resultModel == null
                      ? Row(
                          children: [
                            SizedBox(
                              height: 0.05.sh,
                            ),
                            Text(
                              'Note: The result is not finalized yet',
                              style: kPoppinsMedium500.copyWith(
                                  fontSize: 13, color: kRejectedColor),
                            ),
                            SizedBox(
                              height: 0.02.sh,
                            ),
                          ],
                        )
                      : vm.resultModel!.isResultFinalized == 'no'
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 0.05.sh,
                                    ),
                                    Text(
                                      'Note: The result is not finalized yet',
                                      style: kPoppinsMedium500.copyWith(
                                          fontSize: 13, color: kRejectedColor),
                                    ),
                                    SizedBox(
                                      height: 0.02.sh,
                                    ),
                                  ],
                                ),
                                vm.userType == 'coordinator'
                                    ? Row(children: [
                                        Text(
                                          'Wanna finalize?',
                                          style: kPoppinsMedium500.copyWith(
                                              fontSize: 13,
                                              color: kPrimaryColor),
                                        ),
                                        SizedBox(
                                          width: 0.02.sw,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await vm.finalizeResult();
                                          },
                                          child: Text(
                                            'Yes',
                                            style: kPoppinsRegular400.copyWith(
                                                color: Colors.blue,
                                                fontSize: 14),
                                          ),
                                        )
                                      ])
                                    : SizedBox(),
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  height: 0.05.sh,
                                ),
                                Text(
                                  'Note: The result is finalized',
                                  style: kPoppinsMedium500.copyWith(
                                      fontSize: 13, color: kAcceptedColor),
                                ),
                              ],
                            ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  SizedBox(
                      height: 0.65.sh,
                      child: SingleChildScrollView(
                        child: Screenshot(
                          controller: _screenshotController,
                          child: Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vm.searchedStudentMarksMap.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 0.03.sh),
                                    child: Container(
                                      height: 0.3.sh,
                                      decoration: BoxDecoration(
                                          color: kDateColor,
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          boxShadow: []),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.r),
                                        child: Column(
                                          children: [
                                            ///Project name
                                            Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              'Project Name: ',
                                                              style: kPoppinsBold700
                                                                  .copyWith(
                                                                  fontSize: 18.sp,
                                                                  color:
                                                                  Colors.white),
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  vm.studentIdeasList[index]??"",
                                                                  style: kPoppinsSemiBold600
                                                                      .copyWith(
                                                                      fontSize:
                                                                      15.sp,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                )),

                                            ///Name
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'Name: ',
                                                      style: kPoppinsBold700
                                                          .copyWith(
                                                              fontSize: 18.sp,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    flex: 3,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              vm.searchedStudentMarksMap
                                                                  .keys
                                                                  .elementAt(
                                                                      index),
                                                              style: kPoppinsSemiBold600
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15.sp,
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            // Text( vm.searchedStudentMarksMap.keys.elementAt(index),

                                                            //   style: kPoppinsSemiBold600
                                                            //       .copyWith(
                                                            //     fontSize: 15.sp,
                                                            //       color: Colors.white
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),

                                            Expanded(
                                                child: Row(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'ID: ',
                                                      style: kPoppinsBold700
                                                          .copyWith(
                                                              fontSize: 18.sp,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    flex: 3,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              vm.listOfStudents[index].universityId??"",
                                                              style: kPoppinsSemiBold600
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15.sp,
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            // Text( vm.searchedStudentMarksMap.keys.elementAt(index),

                                                            //   style: kPoppinsSemiBold600
                                                            //       .copyWith(
                                                            //     fontSize: 15.sp,
                                                            //       color: Colors.white
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            )),

                                            ///FYP-1
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          kFinPenPressedColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.r),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  'FYP-1 Total: ',
                                                                  style: kPoppinsBold700
                                                                      .copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      getFyp1Total(
                                                                              vm.searchedStudentMarksMap.values.elementAt(index),
                                                                              index)
                                                                          .toString(),
                                                                      style: kPoppinsSemiBold600
                                                                          .copyWith(
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        )),

                                                        ///OBE-1 AND OBE-2 ROW
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            ///OBE-2
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'OBE-2: ',
                                                                      style: kPoppinsBold700
                                                                          .copyWith(
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          getObe2(vm.searchedStudentMarksMap.values.elementAt(index), index)
                                                                              .toString()+" "+
                                  vm.searchedStudentMarksMap.values.elementAt(index).OBE2Status,
                                                                          style:
                                                                              kPoppinsSemiBold600.copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            )),

                                                            ///OBE-3
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'OBE-3: ',
                                                                      style: kPoppinsBold700
                                                                          .copyWith(
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          getObe3(vm.searchedStudentMarksMap.values.elementAt(index), index)
                                                                              .toString(),
                                                                          style:
                                                                              kPoppinsSemiBold600.copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ))
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            ///OBE-4
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: Text(
                                                                      'OBE-4: ',
                                                                      style: kPoppinsBold700
.copyWith(
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          getObe4(vm.searchedStudentMarksMap.values.elementAt(index), index)
                                                                              .toString(),
                                                                          style:
                                                                              kPoppinsSemiBold600.copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            )),

                                                            ///FYP-1 VIVA
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          'FYP-1 Viva: ',
                                                                          style:
                                                                              kPoppinsBold700.copyWith(
                                                                            fontSize:
                                                                                15.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          vm.searchedStudentMarksMap
                                                                              .values
                                                                              .elementAt(index)
                                                                              .fyp1Viva
                                                                              .toString(),
                                                                          style:
                                                                              kPoppinsSemiBold600.copyWith(
                                                                            fontSize:
                                                                                12.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ))
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 0.01.sh,
                                            ),
                                            Expanded(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  color: kFinPenPressedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.r),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          'FYP-2 Total: ',
                                                          style: kPoppinsBold700
                                                              .copyWith(
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              vm.searchedStudentMarksMap
                                                                  .values
                                                                  .elementAt(
                                                                      index)
                                                                  .fyp2Viva
                                                                  .toString(),
                                                              style:
                                                                  kPoppinsSemiBold600
                                                                      .copyWith(
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )),
                                            GestureDetector(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.30,
                                                height: MediaQuery.of(context).size.height * 0.058,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: kPrimaryColor),
                                                child: Center(
                                                  child: Text(
                                                    'Finalize result',
                                                    style: kPoppinsMedium500.copyWith(
                                                        fontSize: 16, color: Colors.white),
                                                  ),
                                                ),
                                                margin: EdgeInsets.all(5),
                                              ),
                                              onTap: (){
                                                   vm.FinalizeResult(  vm.listOfStudents[index].uid??"",index);
                                              },
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  var pdf = pw.Document();
  createPdfFile() {
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text('PDF',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 26)),
                  pw.Divider(),
                ]),
          ];
        }));
  }

  savePdfFile() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    String id = DateTime.now().toString();

    File file = File("$documentPath/$id.pdf");

    file.writeAsBytesSync(await pdf.save());
    String pdfFile = file.path;
    pdf = pw.Document();
  }

  void takess() async {
    // final directory =
    //     (await getExternalStorageDirectory())!.path; //
    final directory = "/storage/emulated/0/Android/media/file";
    //from path_provide package
    print(directory);
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + ".png",
        path = '$directory';

    _screenshotController.captureAndSave(path, fileName: fileName);
//---------------------------------------------------------------
    var img = File(directory + "/" + fileName);
    log(img.toString());
    Future.delayed(Duration(seconds: 2)).then((value) async {
      final image = pw.MemoryImage(img.readAsBytesSync());
      // var test =
      //     ii.decodeImage(File(directory + "/" + fileName).readAsBytesSync())!;
      // // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      // var thumbnail = ii.copyResize(test, width: 1080);
      // await File('$directory/test.png')
      //   ..writeAsBytesSync(ii.encodePng(thumbnail));
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
      try {
        final dir = await getExternalStorageDirectory();
        final file = File('${dir!.path}/${fileName.split(".").first}.pdf');
        await file.writeAsBytes(await pdf.save());
        print('success saved to documents');
      } catch (e) {
        print(e.toString());
      }
    });
  }
  // Future getPdf(Uint8List screenShot) async {
  // pw.Document pdf = pw.Document();
  // pdf.addPage(
  //   pw.Page(
  //     pageFormat: PdfPageFormat.a4,
  //     build: (context) {
  //       return pw.Expanded(
  //         child: pw.Image(PdfImage.file(pdf.document, bytes: screenShot), fit: pw.BoxFit.contain)
  //       );
  //     },
  //   ),
  // );
  // File pdfFile = File('Your path + File name');
  // pdfFile.writeAsBytesSync(pdf.save());
}
// Future<void> printDoc() async{
// PdfDocument document=PdfDocument();
// document.pages.add();
// Future<List<int>> bytes = document.save();
// document.dispose();
// }
// Future<void> savedoc(List<int> bytes ,String  fileName) async{
//   final path= (await getExternalStorageDirectories()).path;
//   final file= File();

//   }

//}
