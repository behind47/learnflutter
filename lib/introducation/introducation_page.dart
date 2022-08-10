import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnflutter/util/widget_operation_end.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class IntroducationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntroducationPageState();
  }
}

class IntroducationPageState extends State<IntroducationPage> {
  List<BedBaseViewModel>? viewModels;
  var globalKey;

  @override
  void initState() {
    globalKey = GlobalKey();
    viewModels = [
      BedPersonalInfoVM(
          name: "章三", age: "22", tel: "44444444444", email: "qq@gmail.com"),
      BedSkillVM(),
      BedEducationVM(),
      BedJobVM(),
      BedPdfVM()..tap = () async {
        var boundary = globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List? pngBytes = byteData?.buffer.asUint8List();
        
        final pdf = pw.Document();
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Image(pw.MemoryImage(pngBytes!));
            }));
        Directory appDocDir = await getApplicationDocumentsDirectory();
        print('ApplicationDocumentsDirectory: ${appDocDir.path}');
        final file = File(appDocDir.path+'pdfexample.pdf');

        await file.writeAsBytes(await pdf.save());
        print(file.path + 'succeed to save pdf');
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('简历'),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Container(
          child: ListView(
        children: viewModels!.map((e) => e.buildContent()).toList(),
      )),),
    );
  }
}

/// a vertical list
/// 接收一组viewModel，将其展开为一个列表
/// viewModel有几个子类，用于不同的模块
class BedList extends ListView {
  final List<BedBaseViewModel> viewModels;

  BedList(this.viewModels);
}

/// 简历模块的基类
class BedBaseViewModel {
  Widget buildContent() {
    return Container(
      constraints: BoxConstraints(minHeight: 50),
      color: Colors.red,
    );
  }
}

/// 个人简介：姓名、年龄、电话、邮箱
class BedPersonalInfoVM extends BedBaseViewModel {
  var name;
  var age;
  var tel;
  var email;

  BedPersonalInfoVM(
      {this.name = "", this.age = "", this.tel = "", this.email = ""})
      : super();

  @override
  Widget buildContent() {
    double paddingLeft = 15; // 每一行左右两侧的padding
    int flexPercent = 3; // 电话row的flex比例
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('姓名:'),
                  Text(name),
                ],
              )
                  .withPadding(
                      EdgeInsets.only(left: paddingLeft, right: paddingLeft))
                  .withFlexible(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('电话:'),
                  Text(tel),
                ],
              )
                  .withPadding(
                      EdgeInsets.only(left: paddingLeft, right: paddingLeft))
                  .withFlexible(flexPercent)
            ],
          ).withPadding(EdgeInsets.only(bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('年龄:'),
                  Text(age),
                ],
              )
                  .withPadding(
                      EdgeInsets.only(left: paddingLeft, right: paddingLeft))
                  .withFlexible(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('邮箱:'),
                  Text(email),
                ],
              )
                  .withPadding(
                      EdgeInsets.only(left: paddingLeft, right: paddingLeft))
                  .withFlexible(flexPercent),
            ],
          )
        ],
      ).withPadding(EdgeInsets.only(top: 20, bottom: 20)),
    );
  }
}

/// 技术栈
class BedSkillVM extends BedBaseViewModel {
  @override
  Widget buildContent() {
    return Container(
      child: Text(
        'iOS, Objective-C, Swift',
        textAlign: TextAlign.start,
      ).withPadding(EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(3))),
    ).withPadding(EdgeInsets.all(15));
  }
}

/// 教育背景：学历、时间、学校、专业
class BedEducationVM extends BedBaseViewModel {}

/// 工作经验：时间、公司、职位、工作内容
class BedJobVM extends BedBaseViewModel {}

/// 导出pdf
class BedPdfVM extends BedBaseViewModel {
  Function? tap;

  @override
  Widget buildContent() {
    return GestureDetector(
      child: Container(
        height: 40,
        child: Text('导出pdf'),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onTap: () {
        tap?.call();
      },
    ).withPadding(
      EdgeInsets.only(top: 20, bottom: 20, left: 60, right: 60),
    );
  }
}
