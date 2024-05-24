import 'package:flutter/material.dart';
import 'models/region.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alamat Input Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black), // Set default text color
        ),
      ),
      home: AddressForm(),
    );
  }
}

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final ApiService apiService = ApiService();

  List<Region> provinces = [];
  List<Region> regencies = [];
  List<Region> districts = [];

  Region? selectedProvince;
  Region? selectedRegency;
  Region? selectedDistrict;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    try {
      List<Region> provinceList = await apiService.fetchProvinces();
      setState(() {
        provinces = provinceList;
      });
    } catch (e) {
      print('Failed to load provinces: $e');
    }
  }

  Future<void> _fetchRegencies(String provinceId) async {
    try {
      List<Region> regencyList = await apiService.fetchRegencies(provinceId);
      setState(() {
        regencies = regencyList;
        selectedRegency = null;
        districts = [];
        selectedDistrict = null;
      });
    } catch (e) {
      print('Failed to load regencies: $e');
    }
  }

  Future<void> _fetchDistricts(String regencyId) async {
    try {
      List<Region> districtList = await apiService.fetchDistricts(regencyId);
      setState(() {
        districts = districtList;
        selectedDistrict = null;
      });
    } catch (e) {
      print('Failed to load districts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Alamat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Region>(
              hint: Text('Pilih Provinsi'),
              value: selectedProvince,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
              items: provinces.map((Region province) {
                return DropdownMenuItem<Region>(
                  value: province,
                  child: Text(province.name, style: TextStyle(color: Colors.black)), // Set text color
                );
              }).toList(),
              onChanged: (Region? newValue) {
                setState(() {
                  selectedProvince = newValue;
                  if (selectedProvince != null) {
                    _fetchRegencies(selectedProvince!.id);
                  }
                });
              },
              itemHeight: 48.0,
              dropdownColor: Colors.white, // Set dropdown background color
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Region>(
              hint: Text('Pilih Kabupaten/Kota'),
              value: selectedRegency,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
              items: regencies.map((Region regency) {
                return DropdownMenuItem<Region>(
                  value: regency,
                  child: Text(regency.name, style: TextStyle(color: Colors.black)), // Set text color
                );
              }).toList(),
              onChanged: (Region? newValue) {
                setState(() {
                  selectedRegency = newValue;
                  if (selectedRegency != null) {
                    _fetchDistricts(selectedRegency!.id);
                  }
                });
              },
              itemHeight: 48.0,
              dropdownColor: Colors.white, // Set dropdown background color
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Region>(
              hint: Text('Pilih Kecamatan'),
              value: selectedDistrict,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
              items: districts.map((Region district) {
                return DropdownMenuItem<Region>(
                  value: district,
                  child: Text(district.name, style: TextStyle(color: Colors.black)), // Set text color
                );
              }).toList(),
              onChanged: (Region? newValue) {
                setState(() {
                  selectedDistrict = newValue;
                });
              },
              itemHeight: 48.0,
              dropdownColor: Colors.white, // Set dropdown background color
            ),
          ],
        ),
      ),
    );
  }
}
