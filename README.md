# deeplink

```
And then afterwards, pa r&d ko ug solution ani: MOBILE: coinmodewallet:// deeplink support
So bale new feature ni sya na gusto ipa add sa client. If a user clicks on this particular deeplink  coinmodewallet://  ma launch ang app. Buhati ko ug implementation by the end of the day that will open a dummy flutter project if a user opens a coinmode deeplink (edited) 

And then also, need nako ma access pud ang deeplink string because mag extract ko sa url query parameters 
So maybe i display lang sa screen ang full content sa deeplink
Example ingani: coinmodeplayer://?p=cm_pub_xxx&amount=xxx&wallet=xxxx
ASk lang if naa ka clarifications

```

adb shell am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d '"coinmodeplayer://coinmode.com/?p=cm_pubxxx&amount=xxx&wallet=xxxc"'

--------------------
?arr%5b%5d=123&arr%5b%5d=abc&addr=1%20Nowhere%20Rd&addr=Rand%20City%F0%9F%98%82
# Different kind of implementation
- Deep Links and Flutter applications. How to handle them properly. Outdated https://github.com/DenisovAV/deep_links_flutter
- Flutter Deeplink https://docs.flutter.dev/development/ui/navigation/deep-linking
- Firebase Dynamic link  https://medium.com/@yoppy-dev/flutter-deeplink-using-firebase-dynamic-links-26c7cfac7638
- Uni-Links https://pub.dev/packages/uni_links