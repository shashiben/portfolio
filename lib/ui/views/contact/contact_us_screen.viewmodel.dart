part of 'contact_us_screen.dart';

class ContactUsScreenViewModel extends BaseViewModel {
  String get phoneLink => 'tel:${MYInfo.phone.replaceAll(RegExp(r'[\s\-]'), '')}';

  void open(String url) => locator.get<UrlLauncherService>().open(url);
}
