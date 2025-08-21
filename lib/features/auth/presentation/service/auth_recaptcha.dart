// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:async';

// Future<String> getRecaptchaV3Token(BuildContext context) async {
//   final completer = Completer<String>();

//   // WebView invisible
//   // final webView = SizedBox(
//   //   width: 0,
//   //   height: 0,
//   //   child: WebView(
//   //     initialUrl: 'about:blank',
//   //     javascriptMode: JavascriptMode.unrestricted,
//   //     onWebViewCreated: (controller) async {
//   //       // Cargar HTML con reCAPTCHA v3
//   //       final html = """
//   //       <html>
//   //       <head>
//   //         <script src="https://www.google.com/recaptcha/api.js?render=TU_SITE_KEY"></script>
//   //         <script>
//   //           grecaptcha.ready(function() {
//   //             grecaptcha.execute('TU_SITE_KEY', {action: 'login'}).then(function(token) {
//   //               RecaptchaToken.postMessage(token);
//   //             });
//   //           });
//   //         </script>
//   //       </head>
//   //       <body></body>
//   //       </html>
//   //       """;

//   //       await controller.loadHtmlString(html);
//   //     },
//   //     javascriptChannels: {
//   //       JavascriptChannel(
//   //         name: 'RecaptchaToken',
//   //         onMessageReceived: (message) {
//   //           final token = message.message;
//   //           if (!completer.isCompleted) completer.complete(token);
//   //         },
//   //       ),
//   //     },
//   //   ),
//   // );

//   // Necesario montar el WebView en algún lugar
//   final overlay = OverlayEntry(builder: (_) => webView);
//   Overlay.of(context).insert(overlay);

//   final token = await completer.future;
//   overlay.remove();
//   return token;
// }
