var map;
var markers = [];

// 기존의 window.onload 이벤트 핸들러를 복원
window.onload = function() {
  if (typeof initializeKakaoMap === 'function') {
    initializeKakaoMap();
  } else {
    console.error('initializeKakaoMap function is not defined');
  }
};

function initMap() {
  if (typeof kakao === 'undefined') {
    setTimeout(initMap, 100);
    return;
  }  
  var container = document.getElementById('map');
  var options = {
    center: new kakao.maps.LatLng(37.58823, 126.9936),
    level: 3
  };
  map = new kakao.maps.Map(container, options);
}

function addMarker(cafe) {
  var content = document.createElement('div');
  content.className = 'cafe-marker-label';
  if (cafe['Co-work'] === 1 || cafe['Co-work'] === '1') {
    content.classList.add('co-work');
  }
  content.innerHTML = cafe.Name + '<br>' + getHoursDisplay(cafe.Hours_weekday);

  var customOverlay = new kakao.maps.CustomOverlay({
    map: map,
    position: new kakao.maps.LatLng(cafe['Position (Latitude)'], cafe['Position (Longitude)']),
    content: content,
    yAnchor: 1.1
  });

  markers.push(customOverlay);

  kakao.maps.event.addListener(customOverlay, 'click', function() {
    // Flutter와의 상호작용 구현
    if (window.CafeChannel) {
      window.CafeChannel.postMessage(JSON.stringify(cafe));
    } else {
      console.log('CafeChannel is not available');
    }
  });
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
}

// 초기화 함수 호출을 window.onload에서 제거
// Flutter에서 초기화를 제어할 수 있도록 함
// window.onload = initMap;

// 대신, Flutter에서 호출할 수 있는 초기화 함수를 노출
window.initializeKakaoMap = initMap;