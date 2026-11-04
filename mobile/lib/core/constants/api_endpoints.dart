class ApiEndpoints {
  // Ganti baseUrl sesuai IP mesin server FastAPI saat pengujian lokal atau VPS
  // Default Android Emulator: 10.0.2.2:8000, Real Device: IP LAN (misal 192.168.1.xxx:8000)
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String predictHarvest = '$baseUrl/predict/harvest';
  static const String consultChat = '$baseUrl/consultation/chat';
  static const String syncData = '$baseUrl/sync/records';
  static const String articles = '$baseUrl/veterinary/guidelines';
}

