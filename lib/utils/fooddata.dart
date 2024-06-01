 List<String> foodItems = [
    'Bag of Rice',
    'Plate of Pepper',
    'Bag of Beans',
    'Tuber Of Yam',
    'Noddles',
    '500g Spaghetti',
    'Crate Of Eggs',
    'Garri',
    'Noodles',
    'Kilo of Fish',
    'Bunch of Plantain',		
'Bunch of Banana',	
'Piece of Apple Fruit',		
'Piece of Orange Fruit',	
'Piece of Watermelon Fruit',		
'Piece of Pineapple Fruit',		
'Usual Plastic Congo of Wheat',		
'Usual Plastic Congo of Elubo',				
'Usual Plastic Congo of Grains',		
'Usual Plastic Congo of Melon',		
'Kilo of Meat',		
'Bunch of Vegetables',
  ];

  final Map<String, List<String>?> foodSubTypes = {
    'Bag of Rice': ['Foreign', 'Imported'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'oloyin'],
    'Plate of Pepper': [
      'Rodo',
      'Tatase',
      'Sombo/Bawa',
      'Bell/Sweet',
      'Alligator',
      'Black',
      'White',
      'Habanero'
    ],
    'Tuber Of Yam': ['Water Yam', 'Dry Yam', 'White Guinea Yam'],
    '500g Spaghetti': ['Power Pasta', 'Crown Premium', 'Honywell'],
    'Garri': ['Brown', 'White'],
    'Noodles': [],
    'Kilo of Fish': [
      'Alaran/Sardines',
          'Panla',
          'Express',
          'Shawa/Mackerel',
          'Croaker',
          'Catfish',
          'Bonga',
    ],
    'Basket Of Cassava': null,
  };

 /* final Map<String, List<String>?> foodSubTypes = {
    'Bag of Rice': ['Foreign', 'Imported'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'Oloyin'],
    'Plate of Pepper': ['Rodo', 'Tatase', 'Sombo/Bawa', 'Bell/Sweet', 'Alligator', 'Black', 'White', 'Habanero'],
    'Tuber Of Yam': ['Water Yam', 'Dry Yam', 'White Guinea Yam'],
    '500g Spaghetti': ['Power Pasta', 'Crown Premium', 'Honeywell'],
    'Garri': ['Brown', 'White'],
    'Noodles':['Mimee',	'Golden Penny','Supreme','Cherrie','Tummy Tummy','Bestie','Jolly Jolly','Master','Honeywell'],
    'Kilo of Fish': ['Alaran/Sardines', 'Panla', 'Express', 'Shawa/Mackerel', 'Croaker', 'Catfish', 'Bonga'],
    'Crate Of Eggs':['Small','Big','Medium'],
    //'Usual Plastic Congo of Elubo':['green','yellow']
  };*/  


  
 /* Widget buildSubtypeOrBrandDropdown() {
    if (foodSubTypes[selectedFoodItem] == null) {
      return const SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
                    SizedBox(height: 5),
                    Text("Select Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
                  ],
                ),
                isExpanded: true,
                value: selectedSubtype,
                items: foodSubTypes[selectedFoodItem]!.map((String subtype) {
                  return DropdownMenuItem<String>(
                    value: subtype,
                    child: Text(subtype),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubtype = newValue;
                    customSubtype = null;
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
          /*const SizedBox(height: 5),
         if (selectedSubtype == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Custom Type",
                  hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  customSubtype = value;
                  _notifyParent();
                },
              ),
            ),*/
            const SizedBox(height: 5),
        ],
      );
    }
  }*/