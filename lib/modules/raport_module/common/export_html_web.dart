import 'dart:convert';
import 'dart:html' as html;

void openHtmlInNewTab(String htmlContent) {
  // final blob = html.Blob([htmlContent], 'text/html');
  // final url = html.Url.createObjectUrlFromBlob(blob);
  // html.window.open(url, '_blank');

  final blob = html.Blob([htmlContent], 'text/html');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');

  // Optional: revoke object URL after a short delay
  Future.delayed(Duration(seconds: 1), () {
    html.Url.revokeObjectUrl(url);
  });
}

// void openHtmlInNewTab(String htmlContent) {
//   // Create a data URL from the HTML content
//   // final uri = Uri.dataFromString(
//   //   htmlContent,
//   //   mimeType: 'text/html',
//   //   encoding: Encoding.getByName('utf-8'),
//   // );

//   // // Open in a new tab
//   // html.window.open(uri.toString(), '_blank');
//   // final base64Content = base64Encode(utf8.encode(htmlContent));
//   // final uri = 'data:text/html;base64,$base64Content';

//   // html.window.open(uri, '_blank');
// }
