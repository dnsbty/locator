import L from "leaflet";

class Map {
  constructor(element) {
    this.map = L.map(element).setView([40, 0], 2);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      noWrap: true,
    }).addTo(this.map);
  }

  addMarker({ latitude, longitude }) {
    return L.marker([latitude, longitude]).addTo(this.map);
  }

  addUserLocation({ latitude, longitude }) {
    const userIcon = new L.Icon({
      iconUrl: "/images/user-location.png",
      iconSize: [32, 32],
      iconAnchor: [16, 16],
    });

    const marker = L.marker([latitude, longitude], { icon: userIcon });

    return marker.addTo(this.map);
  }
}

export default Map;
