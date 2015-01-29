(function() {
  var closeTab, dev, login, loginCallback, loginTab, removeListener, root, saveSocial, senderTab, tabClosed, tabUpdated, updatePublishTime;

  dev = true;

  if (dev) {
    root = "http://localhost:3000";
  } else {
    root = "http://gawker-socializer.herokuapp.com";
  }

  chrome.runtime.onInstalled.addListener(function(details) {
    return console.log('previousVersion', details.previousVersion);
  });

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    if (request) {
      console.log(sender.tab ? "from a content script:" + sender.tab.url : "from the extension");
      if (request.method === "saveSocial") {
        delete request.method;
        return saveSocial(request);
      } else if (request.method === "updatePublishTime") {
        delete request.method;
        return updatePublishTime(request);
      } else if (request.method === "login") {
        return login(sender.tab);
      }
    }
  });

  loginTab = {};

  senderTab = null;

  loginCallback = null;

  login = function(_senderTab) {
    senderTab = _senderTab;
    chrome.tabs.create({
      windowId: null,
      url: "" + root + "/signin",
      index: senderTab.index + 1
    }, function(_tab) {
      return loginTab = _tab;
    });
    chrome.tabs.onRemoved.addListener(tabClosed);
    return chrome.tabs.onUpdated.addListener(tabUpdated);
  };

  tabUpdated = function(tabId, changeInfo, tab) {
    if (tabId === loginTab.id) {
      return closeTab(tab, tabId, senderTab);
    }
  };

  closeTab = function(tab, tabId, senderTab) {
    if (tab.url.match(/^http:\/\/(localhost:3000|gawker-socializer.herokuapp.com)\/login_success/)) {
      console.log('now close the tab and go back to editor');
      chrome.tabs.remove(tabId);
      chrome.tabs.update(senderTab.id, {
        active: true
      });
      return chrome.tabs.onUpdated.removeListener(tabUpdated);
    }
  };

  tabClosed = function(tabId, removeInfo) {
    console.log('running tabClosed');
    if (tabId = loginTab.id) {
      loginTab = {};
      console.log('it is the right tab');
      chrome.tabs.sendMessage(senderTab.id, {
        method: 'loginComplete'
      });
      return removeListener();
    }
  };

  removeListener = function() {
    return chrome.tabs.onRemoved.removeListener(tabClosed);
  };

  saveSocial = function(params) {
    console.log('saving social!');
    params.publish_at = new Date(params.publish_at);
    console.log(params);
    return $.ajax({
      url: "" + root + "/stories",
      method: "POST",
      data: params,
      success: (function(_this) {
        return function(data) {
          return console.log('saved posts', data);
        };
      })(this),
      error: function() {
        return console.log('something went wrong saving this');
      }
    });
  };

  updatePublishTime = function(params) {
    console.log('updating publish time');
    params.publish_at = new Date(params.publish_at);
    console.log(params);
    return $.ajax({
      url: "" + root + "/stories/update_pub",
      method: "POST",
      data: params,
      success: (function(_this) {
        return function(data) {
          return console.log('saved posts', data);
        };
      })(this),
      error: function() {
        return console.log('something went wrong saving this');
      }
    });
  };

  console.log('\'Allo \'Allo! Event Page');

}).call(this);

//# sourceMappingURL=background.js.map
