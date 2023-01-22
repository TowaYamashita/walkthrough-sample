import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walkthrough/home_page.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  late final PageController controller;
  late final StreamController<int> currentPage;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    currentPage = StreamController.broadcast();
    currentPage.add(0);
  }

  @override
  void dispose() {
    currentPage.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    goNext() {
      controller.nextPage(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    goHomePage() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const HomePage();
      }));
    }

    const walkthroughs = [
      WalkthroughA(),
      WalkthroughB(),
      WalkthroughC(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemBuilder: (_, index) => walkthroughs[index],
                  itemCount: walkthroughs.length,
                  onPageChanged: (index) {
                    currentPage.add(index);
                  },
                ),
              ),
              _Indicators(
                currentPage: currentPage.stream,
                pageAllCount: walkthroughs.length,
              ),
              _Button(
                currentPage: currentPage.stream,
                onContinued: goNext,
                onFinished: goHomePage,
                pageCount: walkthroughs.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalkthroughA extends StatelessWidget {
  const WalkthroughA({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.red,
      child: Center(
        child: Text(
          'aaa',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class WalkthroughB extends StatelessWidget {
  const WalkthroughB({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.blue,
      child: Center(
        child: Text(
          'bbb',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class WalkthroughC extends StatelessWidget {
  const WalkthroughC({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.yellow,
      child: Center(
        child: Text(
          'ccc',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class _Indicators extends StatelessWidget {
  const _Indicators({
    Key? key,
    required this.currentPage,
    required this.pageAllCount,
  }) : super(key: key);

  /// 現在表示されているページ番号
  final Stream<int> currentPage;

  /// ウォークスルー全体のページ数
  final int pageAllCount;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: currentPage,
      builder: (_, snapshot) {
        final currentPage = snapshot.data ?? 0;
        final indicators = List.generate(
          pageAllCount,
          (index) {
            return Icon(
              Icons.circle,
              color: index == currentPage ? Colors.blue : Colors.grey,
            );
          },
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indicators,
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.currentPage,
    required this.onContinued,
    required this.onFinished,
    required this.pageCount,
  }) : super(key: key);

  /// 現在表示されているページ番号
  final Stream<int> currentPage;

  /// ウォークスルーがまだ存在する時に実行する処理
  final void Function() onContinued;

  /// ウォークスルーをすべて見終わった後で実行する処理
  final void Function() onFinished;

  /// ウォークスルー全体のページ数
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: currentPage,
      builder: (_, snapshot) {
        final currentPage = snapshot.data ?? 0;
        final isLastPage = currentPage == (pageCount - 1);
        return ElevatedButton(
          onPressed: isLastPage ? onFinished : onContinued,
          child: Text(
            isLastPage ? 'はじめる' : '次へ',
          ),
        );
      },
    );
  }
}
