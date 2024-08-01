var map;
var markers = [];
var isMapInitialized = false;

// 기존의 window.onload 이벤트 핸들러를 복원
// window.onload = function() {
//   if (typeof initMap === 'function') {
//     initMap();
//   } else {
//     console.error('initializeKakaoMap function is not defined');
//   }
// };

function initMap(mapElementId, cafeData) {
  if (isMapInitialized) {
    console.log("Map is already initialized. Skipping initialization.");
    return;
  }

  console.log("Attempting to initialize map with ID:", mapElementId);
  
  var container = document.getElementById(mapElementId);
  if (!container) {
    console.error("Map container not found! ID:", mapElementId);
    return;
  }
  
  console.log("Map container found, initializing map");
  map = new kakao.maps.Map(container, {
    center: new kakao.maps.LatLng(37.58823, 126.9936),
    level: 3
  });
  
  if (cafeData) {
    console.log("data exists!!!");
    addCafes(cafeData);
  }
  else
  {
    console.log("NO DATA!!!");
  }
  
  isMapInitialized = true;
  console.log("Map initialized successfully");
}


function addMarker(cafe) {
  var content = document.createElement('div');
  content.className = 'cafe-marker-label';
  if (cafe['Co-work'] === 1 || cafe['Co-work'] === '1') {
    content.classList.add('co-work');
  }
  
  // 카페 이름과 영업 시간을 별도의 span 요소로 만들어 줄바꿈 효과를 줍니다.
  content.innerHTML = `
    <span>${cafe.Name}</span><br>
    <span>${getHoursDisplay(cafe.Hours_weekday)}</span>
  `;

  // 인라인 스타일을 추가하여 CSS를 적용합니다.
  content.style.cssText = `
    padding: 3px 5px;
    background: white;
    border: 1px solid black;
    border-radius: 3px;
    text-align: center;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 10px;
    white-space: nowrap;
    cursor: pointer;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
  `;

  // co-work 클래스에 대한 스타일도 추가합니다.
  if (content.classList.contains('co-work')) {
    content.style.background = '#ffe9bc';
    content.style.color = 'rgb(0, 0, 0)';
  }

  var customOverlay = new kakao.maps.CustomOverlay({
    map: map,
    position: new kakao.maps.LatLng(cafe['Position (Latitude)'], cafe['Position (Longitude)']),
    content: content,
    yAnchor: 1.1
  });

  markers.push(customOverlay);

  content.addEventListener('click', function(e) {
    e.stopPropagation();
//console.log("Clicked!!!!");
    if (window.onCafeSelected) {
        window.onCafeSelected(JSON.stringify(cafe));
    } else {
        console.log('onCafeSelected is not available');
    }
});


//   kakao.maps.event.addListener(customOverlay, 'click', function() {
// console.log("Clicked!!!!");    
//     if (window.onCafeSelected) {
//       window.onCafeSelected(JSON.stringify(cafe));
//     } else {
//       console.log('onCafeSelected is not available');
//     }
//   });
}

function getHoursDisplay(hours) {
  if (hours === -1) return '무제한';
  if (hours === 0) return '권장X';
  return hours + '시간';
}

function addCafes(cafeData) {
  var cafes = JSON.parse(cafeData);
  cafes.forEach(addMarker);
}

function moveToLocation(lat, lng) {
  map.setCenter(new kakao.maps.LatLng(lat, lng));
  map.setLevel(1);
}


function setMapInteraction(enable) {
  if (map) {
    if (enable) {
      map.setDraggable(true);
      map.setZoomable(true);
    } else {
      map.setDraggable(false);
      map.setZoomable(false);
    }
  }
}

// 초기화 함수 호출을 window.onload에서 제거
// Flutter에서 초기화를 제어할 수 있도록 함
// window.onload = initMap;

// 대신, Flutter에서 호출할 수 있는 초기화 함수를 노출
window.initMap = initMap;
