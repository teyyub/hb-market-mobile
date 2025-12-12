String getFriendlyMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Sorğunuz düzgün göndərilməyib';
    case 401:
      return 'Siz giriş etməmisiniz və ya icazəniz yoxdur';
    case 403:
      return 'Bu əməliyyatı icra etməyə icazəniz yoxdur';
    case 404:
      return 'Məlumat tapılmadı';
    case 500:
      return 'Serverdə problem baş verdi, zəhmət olmasa bir az sonra yenidən cəhd edin';
    default:
      return 'Naməlum xəta baş verdi, zəhmət olmasa yenidən cəhd edin';
  }
}
