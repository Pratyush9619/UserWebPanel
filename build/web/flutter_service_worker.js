'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/animations/loading_animation.gif": "d9e9dc0a3353fa6c8c5fd32048c97d6d",
"assets/AssetManifest.json": "6fd48c2ba960db95677ee052b24bb4fd",
"assets/assets/bus.jpg": "cc9739029f286241f736a3350fa154bf",
"assets/assets/demand_energy.png": "3df0da3d5b35242fb7e3a1803a28408a",
"assets/assets/Depot.jpeg": "a05d450c9a27a857163a1a732f77f2b3",
"assets/assets/depots/Ahmedabad.jpg": "b33157eb06df31bfd4bc3f0ec117cc16",
"assets/assets/depots/Bengluru.jpg": "b3085a3d4eb37ef1dda93175da937375",
"assets/assets/depots/Delhi.jpg": "605708fd16938516307bd52e9e85d2d7",
"assets/assets/depots/depot_overview.jpeg": "a05d450c9a27a857163a1a732f77f2b3",
"assets/assets/depots/Jammu.jpg": "c9ffefd9c0232860719e2f1417538b35",
"assets/assets/depots/Kolkata.jpg": "e9f7960c39ec335d4b43e575cba97e4c",
"assets/assets/depots/Lucknow.jpg": "17538aad121867737159550761d46f64",
"assets/assets/depots/Mumbai.jpg": "c923b7547cd16a9be6f0128df16a5b63",
"assets/assets/depots/patna.jpg": "e379f5f205dbac4e1f3222b7ba0057de",
"assets/assets/ev_dashboard.png": "c853556edcabddb75bb6882d24f0ad98",
"assets/assets/excel.png": "53b758ea8c12c7bd1582d992f31ce1ac",
"assets/assets/GIS.pdf": "6b8bdc356b5f1c64a73d1cf4ce0d47d5",
"assets/assets/Green.jpeg": "f94bab74093a242ab2d772629297a118",
"assets/assets/home/Picture1.png": "d1e6309570d89acade1c4d037e1d03f0",
"assets/assets/home/Picture2.png": "86e0be6ed8f41c32f392d42e920e587a",
"assets/assets/home/Picture3.png": "f05ef20849e427542c5441553e7b5ddc",
"assets/assets/home/Picture4.png": "83a30def351bdfc7ae14ade66c12b01d",
"assets/assets/home/Picture5.png": "8257de5af71fcb99632acf020b951b16",
"assets/assets/Jammu_Smart_City_Limited.pdf": "5a4249ba36b1a966a8468907641f93a8",
"assets/assets/jmr/underconstruction.jpeg": "24e1763c3e47536404379574ca007ec9",
"assets/assets/jmr/underconstruction2.jpeg": "824db105806c4860140de1c0d3b4e31f",
"assets/assets/jmr/underconstruction3.jpeg": "36c7f4a6430206835d1b61120c9685ea",
"assets/assets/jmr/underconstruction4.jpeg": "ef1dd9d33962c8394e5a0c710bfa3d13",
"assets/assets/jmr/underconstruction48.jpeg": "d3c63096b7e1e9ba9a8a00528e1a60ec",
"assets/assets/jmr/underconstruction5.jpeg": "36f2b14b06d75dd146832c0c6d91efe0",
"assets/assets/jmr/underconstruction6.jpeg": "c3afc63f62cb09857b1e6a7874169dd9",
"assets/assets/jmr/underconstruction7.jpeg": "7297b27509e021f64c6b307d4175d512",
"assets/assets/keyevents/A10image.png": "4330f8ae0044ef3a2ce40a4a4c6997b7",
"assets/assets/keyevents/A1image.png": "1071e3dde96aed5585b7836ad44e1fca",
"assets/assets/keyevents/A2image.jpg": "2678142b594b5084617858e47aeb36b4",
"assets/assets/keyevents/A3image.jpg": "cdc795e4b40fffbf9a1ea5f69390afe6",
"assets/assets/keyevents/A4image.png": "62443fd355ef2f1e5feaa7fd476f1f57",
"assets/assets/keyevents/A5image.jpg": "ca3e3adc9a4fe78b2640482ea3e3fd82",
"assets/assets/keyevents/A6image.png": "de2cce63db10458dfbae2deed4ad4677",
"assets/assets/keyevents/A7image.png": "2f1db44c5042514dc1e988920d623f90",
"assets/assets/keyevents/A8image.jpg": "bc7dce376b57488064597571074fbd17",
"assets/assets/keyevents/A9image.png": "a93257a8685c235601b68e71c75ed69b",
"assets/assets/logout.png": "57a14d2ec3510367020d785573b69e31",
"assets/assets/overview_image/closure_report.png": "0d3b599238d3793068020cd1ff58225e",
"assets/assets/overview_image/daily_progress.png": "768f0d156bcb1e3a645909b9a5ba31f2",
"assets/assets/overview_image/depotOverview.webp": "8de66434088802ee413cccd7e5060474",
"assets/assets/overview_image/detailed_engineering.png": "f6a4bd685f47c8a582e3452ca3865d3e",
"assets/assets/overview_image/easy_monitoring.jpg": "cdc795e4b40fffbf9a1ea5f69390afe6",
"assets/assets/overview_image/jmr.png": "f59fb0010b8c7ade368ded5c6573b153",
"assets/assets/overview_image/monthly.png": "77696075a4674ae1043e89e00a387670",
"assets/assets/overview_image/overview.png": "231936ea341b86b7c82502c3f5be9f8f",
"assets/assets/overview_image/project_planning.png": "a8d89b13e8f320735596000533fa7aa9",
"assets/assets/overview_image/quality.png": "2ab5f19bc29fb186b70ec846cbb54f2c",
"assets/assets/overview_image/resource.png": "2b3ed8d8d66e91317620f10f46198915",
"assets/assets/overview_image/safety.png": "9c02b7c1590d2da395a88806e862b7d7",
"assets/assets/overview_image/safety_checklist.jpeg": "10f371c767e863f20e1acb5ba28da6b4",
"assets/assets/overview_image/testing_commissioning.png": "6aea6cc05156a791332f14fd24938926",
"assets/assets/pdf_logo.png": "99e0abfa663a8c10ef2064b9852aee40",
"assets/assets/raw/mJson.json": "a97f49870dff57d79035a053eacde5e6",
"assets/assets/risk.png": "1068228bfadfb1bb5d83c5bd092bd8ef",
"assets/assets/sample_excel.xlsx": "dff598e0014cabdb16f5e008d77387ed",
"assets/assets/sustainable.jpeg": "919e7cfa2dc75d3835bb6ab5225161ca",
"assets/assets/table_loading.gif": "39bfc2518277abd6dc46ae2d8c2f1d76",
"assets/assets/Tata-Power.jpeg": "415bee529da042dff5051cab112bdb97",
"assets/assets/webhome.jpg": "9d44928b8edb591981807196aa18797d",
"assets/FontManifest.json": "a51cc4d96a3886e2148f11cbb1c92b22",
"assets/fonts/IBMPlexSans-Bold.ttf": "5159a5d89abe8bf68b09b569dbeccbc0",
"assets/fonts/IBMPlexSans-Medium.ttf": "ee83103a4a777209b0f759a4ff598066",
"assets/fonts/IBMPlexSans-SemiBold.ttf": "1ca9107e7544d3424419585c7c84cb67",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "aa146a380b63c58ee1c5989aee58442f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/syncfusion_flutter_datagrid/assets/font/FilterIcon.ttf": "c17d858d09fb1c596ef0adbf08872086",
"assets/packages/syncfusion_flutter_datagrid/assets/font/UnsortIcon.ttf": "6d8ab59254a120b76bf53f167e809470",
"assets/packages/timezone/data/latest_all.tzf": "d34414858d4bd4de35c0ef5d94f1d089",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "d57bf5a79745ec7b7a018753e982332a",
"/": "d57bf5a79745ec7b7a018753e982332a",
"logo.png": "c26f228bef8b939865b61c4e040d7c3d",
"main.dart.js": "5a6d20b36d59979324222717b91e8f0e",
"manifest.json": "f73ff0d48fe203730f88c6f9643dd732",
"version.json": "1c0ada4c30372f55569c5a98db5c8fcc"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
