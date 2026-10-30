import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PlantDiseaseService {
  // API endpoint for the plant disease model
  static const String _apiBaseUrl = 'http://agri.platrion.com';
  static const String _predictEndpoint = '/predict';
  static const String _healthEndpoint = '/health';
  static const String _rootEndpoint = '/';
  
  String get apiUrl => '$_apiBaseUrl$_predictEndpoint';
  
  // List of plant diseases for reference
  List<String>? _labels;

  Future<void> loadLabels() async {
    try {
      // Load labels from the text file
      final labelsData = await rootBundle.loadString('assets/plant_disease_labels.txt');
      _labels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty) // Filter out empty lines
          .toList();
      debugPrint('Disease detection labels loaded successfully: ${_labels!.length} labels');
    } catch (e) {
      debugPrint('Error loading labels: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkApiHealth() async {
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl$_healthEndpoint')).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('API health check timed out');
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Health check failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API health check failed: $e');
      rethrow;
    }
  }

  Future<bool> testApiConnection() async {
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl$_rootEndpoint')).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('API connection test timed out');
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API connection test failed: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> detectDisease(File imageFile) async {
    // Make sure labels are loaded
    if (_labels == null) {
      await loadLabels();
    }

    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    
    // Add the image file to the request
    final imageStream = http.ByteStream(imageFile.openRead());
    final imageLength = await imageFile.length();
    
    final multipartFile = http.MultipartFile(
      'image',
      imageStream,
      imageLength,
      filename: 'plant_image.jpg',
      contentType: MediaType('image', 'jpeg'),
    );
    
    request.files.add(multipartFile);
    
    // Send the request
    debugPrint('Sending image to API: $apiUrl');
    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('The connection has timed out, Please try again!');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        // Parse the response
        final jsonResponse = json.decode(response.body);
        debugPrint('Received API response: $jsonResponse');
        
        // Return the complete response - it contains predictions with details
        return jsonResponse;
      } else {
        debugPrint('API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get predictions: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error detecting disease: $e');
      rethrow; // Re-throw the exception so UI can handle it
    }
  }
}