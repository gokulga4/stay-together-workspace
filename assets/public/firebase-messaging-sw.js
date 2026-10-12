importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js");
importScripts("/firebase-config.js");

firebase.initializeApp(self.__FIREBASE_CONFIG__);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title || "StayTogether";
  const options = {
    body: payload.notification?.body || "You have a new notification",
    icon: "/icon.png",
    badge: "/icon.png",
    data: payload.data || {}
  };

  self.registration.showNotification(title, options);
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const screen = event.notification?.data?.screen || "home";
  event.waitUntil(clients.openWindow(`/?screen=${screen}`));
});
