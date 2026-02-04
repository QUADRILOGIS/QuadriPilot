import 'package:flutter_bloc/flutter_bloc.dart';

enum AppPage {
  welcome,
  dashboard,
  mapFinder,
  wifiScanner
}

class PageCubit extends Cubit<AppPage> {
  PageCubit() : super(AppPage.welcome);

  void navigateTo(AppPage page) {
    emit(page);
  }
}
