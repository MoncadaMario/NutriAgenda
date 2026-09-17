{{flutter_js}}
{{flutter_build_config}}

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('sw.js');
}

_flutter.loader.load();