import 'dart:convert'; 

import 'package:flutter/services.dart' as root_bundle; 

class ReadJsonFile{ 
	static Future<String> readJsonData({required String path}) async { 
	
	// read json file 
	final jsondata = await root_bundle.rootBundle.loadString(path); 
	
	// decode json data as list 


	// map json and initialize 
	// using DataModel 
	return jsondata; 
} 
}
