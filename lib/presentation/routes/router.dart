import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_ddd/presentation/splash/splash_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute(page: SignInPage),
  AutoRoute(page: SplashPage, initial: true)
])
class AppRouter extends _$AppRouter {}
