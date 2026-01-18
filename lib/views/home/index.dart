import 'package:flutter/material.dart';
import 'package:flutter_project/components/home/Slider.dart';
import 'package:flutter_project/utils/DioUtil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (mounted) {
        // ToastUtil.showAlertDialog(context, "初始化完成", "欢迎使用");
        var res = await DioUtil().get("/test");
        print("主页 initState: ${res.data}");
      }
    });
  }

  List<Widget> _getSlivers() {
    return [SliverToBoxAdapter(child: CustomSlider())];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _getSlivers());
  }
}
