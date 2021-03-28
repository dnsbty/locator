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
}

export default Map;
