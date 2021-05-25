/**
 * @file
 * A JavaScript file for analytic tracking.
 */

var cookieConsent = {{ .Site.Params.cookieConsent | default false }};

var googleAnalytics = '{{ .Site.GoogleAnalytics }}';
if (cookieConsent) {
  if (typeof Cookies === 'undefined' || Cookies.get('cookieconsent') !== 'accept') {
    window['ga-disable-' + googleAnalytics] = true;
  }
}
