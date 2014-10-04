function isShortened(url) {
  try {
    url = new URL(url)
  } catch (e) {
    return false;
  }

  switch (url.hostname) {
    case "t.co":
    case "bit.ly":
    case "fb.me":
      return true;
    default:
      return false
  }
}

document.addEventListener("mouseover", function(ev) {
  if (ev.target.tagName == "A" && isShortened(ev.target.href)) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'http://expandr.dev.papill0n.org/?url=' + ev.target.href);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.onload = function() {
      var expanded = JSON.parse(xhr.response);
      console.log('expandr: ' + expanded.originalUrl + ' -> ' + expanded.expandedUrl);
      if (ev.target.textContent == ev.target.href) {
        ev.target.textContent = expanded.expandedUrl;
      }
      ev.target.href = expanded.expandedUrl;
      ev.target.title = expanded.expandedUrl;
    }
    xhr.onerror = console.error.bind(console);
    xhr.send();
  }
});
