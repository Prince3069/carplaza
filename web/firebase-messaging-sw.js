importScripts('https://www.gstatic.com/firebasejs/9.6.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.0/firebase-messaging-compat.js');

const firebaseConfig = {
    apiKey: "AIzaSyCNfC3g5gIVzSxcUe_BPFiNf61E8EhdimU",
    authDomain: "car-plaza-b9689.firebaseapp.com",
    projectId: "car-plaza-b9689",
    storageBucket: "car-plaza-b9689.appspot.com",
    messagingSenderId: "74696492122",
    appId: "1:74696492122:web:77c2a16681317df6c88463",
    measurementId: "G-453PDQ8XBR"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/icon-192x192.png'
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});