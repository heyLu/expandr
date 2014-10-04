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

function expand(el) {
  if (el.tagName == "A" && isShortened(el.href)) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'http://expandr.dev.papill0n.org/?url=' + el.href);
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.onload = function() {
      var expanded = JSON.parse(xhr.response);
      console.log('expandr: ' + expanded.originalUrl + ' -> ' + expanded.expandedUrl);
      if (el.textContent == el.href) {
        el.textContent = expanded.expandedUrl;
      }
      el.href = expanded.expandedUrl;
      el.title = expanded.expandedUrl;
    }
    xhr.onerror = console.error.bind(console);
    xhr.send();
  }
}

document.addEventListener("mouseover", function(ev) {
  expand(ev.target);
});
