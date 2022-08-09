import 'package:flutter/material.dart';

class IntroducationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntroducationPageState();
  }
}

class IntroducationPageState extends State<IntroducationPage> {
  List<BedBaseViewModel>? viewModels;

  @override
  void initState() {
    viewModels = [
      BedPersonalInfoVM(),
      BedSkillVM(),
      BedEducationVM(),
      BedJobVM()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '简历',
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text('简历'),
        ),
        body: Container(
          child: ListView.builder(
            itemBuilder: ((context, index) =>
                viewModels![index].buildContent()),
            itemCount: viewModels?.length,
            itemExtent: 5.0,
          ),
        ),
      ),
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
    return Container(width: 100, height: 100,);
  }
}

/// 个人简介：姓名、年龄、电话、邮箱
class BedPersonalInfoVM extends BedBaseViewModel {
  @override
  Widget buildContent() {
    return Container(
      color: Colors.yellow,
    );
  }
}

/// 技术栈
class BedSkillVM extends BedBaseViewModel {}

/// 教育背景：学历、时间、学校、专业
class BedEducationVM extends BedBaseViewModel {}

/// 工作经验：时间、公司、职位、工作内容
class BedJobVM extends BedBaseViewModel {}
