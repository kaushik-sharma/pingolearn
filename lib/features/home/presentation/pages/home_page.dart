import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presentation/providers/sign_out_controller.dart';
import '../providers/home_controller.dart';
import 'package:provider/provider.dart';

import '../../../../di.dart';
import '../widgets/comment_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => sl<HomeController>(),
      builder: (context, child) => const _HomePageHandler(),
    );
  }
}

class _HomePageHandler extends StatefulWidget {
  const _HomePageHandler();

  @override
  State<_HomePageHandler> createState() => _HomePageHandlerState();
}

class _HomePageHandlerState extends State<_HomePageHandler> {
  late final _controller = context.read<HomeController>();
  late final _signOutController = context.read<SignOutController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                _signOutController.signOut();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator.adaptive(
          onRefresh: () async {
            await _controller.getComments();
          },
          child: ListView.separated(
            padding: EdgeInsets.all(20.r),
            itemCount: _controller.comments.length,
            itemBuilder: (context, index) => CommentCard(
                comment: _controller.comments[index],
                maskEmail: _controller.maskEmail),
            separatorBuilder: (context, index) => 15.verticalSpace,
          ),
        ),
      ),
    );
  }
}
