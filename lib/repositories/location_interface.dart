abstract class ILocationRepository {
  Future<String> getCountryCode();
  Future<String> getNumberCode(countryName);
  Future<String> getCountryName();
}
