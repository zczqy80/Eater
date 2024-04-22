import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';//引入shared_preferences包以储存数据
import 'package:intl/intl.dart'; // 引入 intl 包来格式化日期
import 'package:location/location.dart'; //得到location
import 'package:http/http.dart' as http; //访问网站
import 'dart:convert';
import 'dart:math';

class Record extends StatefulWidget {
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  String? _selectedTime;
  final List<String> _timeOptions = [
    '15 minutes ago',
    '30 minutes ago',  // 添加此选项
    // 生成1小时到24小时的选项
  ]..addAll(List.generate(
    24,
        (index) => '${index + 1} hour${index == 0 ? '' : 's'} ago',
  ));

  String? _selectedPlace;
  final List<String> _placeOptions = ['Home', 'Eat out', 'Null'];

  DateTime _calculateDiningTime(String selectedTime) {
    final now = DateTime.now();
    if (selectedTime.contains('minute')) {
      int minutes = int.parse(selectedTime.split(' ')[0]);
      return now.subtract(Duration(minutes: minutes));
    } else if (selectedTime.contains('hour')) {
      int hours = int.parse(selectedTime.split(' ')[0]);
      return now.subtract(Duration(hours: hours));
    }
    return now;  // 默认返回当前时间
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final diningTime = _selectedTime != null ? _calculateDiningTime(_selectedTime!) : DateTime.now();
    final diningTimeString = DateFormat('yyyy-MM-dd HH:mm').format(diningTime);

    List<String> diningRecords = prefs.getStringList('diningRecords') ?? [];
    diningRecords.insert(0, '$diningTimeString at ${_selectedPlace ?? 'Null'}');
    await prefs.setStringList('diningRecords', diningRecords);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved')));

    _showSaveDialog();
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Successful'),
          content: Text('What do you want to do next?'),
          actions: <Widget>[
            TextButton(
              child: Text('Go to Home Page'),
              onPressed: () {
                // 导航到 Home 页面的逻辑
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            TextButton(
              child: Text('Go to Database'),
              onPressed: () {
                // 导航到 Database 页面的逻辑
                Navigator.of(context).popAndPushNamed('/database');  // 假设 '/database' 是 Database 页面的路由
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Dining')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),  // 水平方向上的 Padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),  // 添加一些顶部空间
            // 时间选择部分
            Row(
              children: [
                Expanded(
                  child: Text('Please record diet time:', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 20),  // 两个元素之间的间隔
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,  // 使下拉菜单展开适应可用空间
                    value: _selectedTime,
                    hint: Text('Select time'),
                    items: _timeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTime = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 200),  // 添加间距
            // 地点选择部分
            Row(
              children: [
                Expanded(
                  child: Text('Please record your diet place:', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 20),  // 两个元素之间的间隔
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedPlace,
                    hint: Text('Select place'),
                    items: _placeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPlace = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),  // 用 Expanded 来推动按钮至底部
            // 保存按钮
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 100),  // 底部间距
          ],
        ),
      ),
    );
  }
}

class Suggestion extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  String temperature = "";
  String humidity = "";
  String lat = "";
  String lon = "";
  String foodRecommendation = "Loading recommendation...";
  Location location = new Location();

  List<String> coldDishes = [
    "Prawn cocktail",
    "Cucumber sandwich",
    "Smoked salmon salad",
    "Egg and cress sandwich",
    "Beetroot and goat cheese salad",
    "Chicken Caesar salad",
    "Stilton and pear salad",
    "Coronation chicken",
    "Crab salad",
    "Ham and melon",
    "Caprese salad",
    "Greek salad",
    "Ploughman’s lunch",
    "Mixed charcuterie board",
    "Mozzarella and tomato salad",
    "Antipasti platter",
    "Roast beef slices with horseradish sauce",
    "Pickled herring",
    "Scottish smoked salmon",
    "Tuna salad",
    "Watermelon and feta salad",
    "Ratatouille",
    "Seafood cocktail",
    "Deviled eggs",
    "Artichoke dip with crudites"
  ];

  List<String> hotDishes = [
    "Beef stew",
    "Chicken tikka masala",
    "Shepherd's pie",
    "Lancashire hotpot",
    "Fish and chips",
    "Bangers and mash",
    "Roast beef with Yorkshire pudding",
    "Steak and kidney pie",
    "Full English breakfast",
    "Jacket potato with beans",
    "Beef Wellington",
    "Toad in the hole",
    "Steak and ale pie",
    "Chili con carne",
    "Cornish pasty",
    "Mushroom risotto",
    "Chicken and leek pie",
    "Pea and ham soup",
    "Liver and onions",
    "Braised lamb shanks",
    "Pork belly roast",
    "Spaghetti bolognese",
    "Vegetable curry",
    "Cottage pie",
    "Beef bourguignon"
  ];

  List<String> lightMeals = [
    "Porridge",
    "Toast with jam",
    "Fruit salad",
    "Vegetable soup",
    "Avocado toast",
    "Greek yogurt with honey and nuts",
    "Smoothie bowl",
    "Grilled chicken salad",
    "Quinoa salad",
    "Omelette with spinach and feta",
    "Tomato and basil bruschetta",
    "Spinach and ricotta quiche",
    "Cauliflower rice",
    "Sushi rolls",
    "Pasta salad",
    "Hummus with pita bread",
    "Caprese skewers",
    "Shrimp cocktail",
    "Ceviche",
    "Chicken Caesar wrap",
    "Baked falafel",
    "Vegan wraps",
    "Miso soup",
    "Rice paper rolls",
    "Kale and almond salad"
  ];

  List<String> heartyMeals = [
    "Sunday roast",
    "Lasagna",
    "Macaroni and cheese",
    "Meatloaf",
    "Chicken parmigiana",
    "Turkey with stuffing",
    "Beef brisket",
    "Pulled pork sandwich",
    "Spaghetti and meatballs",
    "Baked ziti",
    "Fried chicken",
    "Sausage and peppers",
    "Beef tacos",
    "Gumbo",
    "Jambalaya",
    "Paella",
    "Ratatouille with sausage",
    "Pot roast",
    "Clam chowder",
    "Beef stroganoff",
    "Shepherd's pie with sweet potato",
    "Moussaka",
    "Fish pie",
    "Chicken and dumplings",
    "Barbecue ribs"
  ];

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {

    double latitude =  51.5074; // Use London latitude if null
    double longitude =  -0.1278; // Use London longitude if null

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    latitude = _locationData.latitude ?? 51.5074; // Use London latitude if null
    longitude = _locationData.longitude ?? -0.1278; // Use London longitude if null

    setState(() {
      lat = latitude.toString();  // Convert latitude to string and update state
      lon = longitude.toString();  // Convert longitude to string and update state
    });

    String apiKey = "1437ea5260b7349c4e602abc4270497d"; // Replace with your actual API key
    String url = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        temperature = "${data['main']['temp']} °C";
        humidity = "${data['main']['humidity']} %";
      });
    } else {
      print('Failed to fetch weather data');
    }

    setState(() {
      // lat = latitude.toString();  // Convert latitude to string and update state
      // lon = longitude.toString();  // Convert longitude to string and update state
      foodRecommendation = recommendFood(double.parse(temperature.split(" ")[0]), double.parse(humidity.split(" ")[0]));
    });
  }

  String recommendFood(double temp, double hum) {
    final random = Random();
    if (temp > 25) {
      return coldDishes[random.nextInt(coldDishes.length)];
    } else if (temp < 10) {
      return hotDishes[random.nextInt(hotDishes.length)];
    } else if (hum > 80) {
      return lightMeals[random.nextInt(lightMeals.length)];
    } else {
      return heartyMeals[random.nextInt(heartyMeals.length)];
    }
  }

  void updateRecommendation() {
    // 根据温度和湿度推荐食物
    double temp = double.parse(temperature.split(" ")[0]);
    double hum = double.parse(humidity.split(" ")[0]);
    setState(() {
      foodRecommendation = recommendFood(temp, hum);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestion'),
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 75),
              child: Column(
                children: <Widget>[
                  Text('Latitude: $lat'),  // Display latitude
                  Text('Longitude: $lon'),  // Display longitude
                  Text('Temperature: $temperature', style: TextStyle(fontSize: 20)),
                  Text('Humidity: $humidity', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),

          SizedBox(height: 150), // 两个文本之间的间距

          Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text('Food Suggestion:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 20), // 两个文本之间的间距
                Text(foodRecommendation, style: TextStyle(fontSize: 25)), // 推荐食物的具体内容
              ],
            ),
          ),

          SizedBox(height: 200), // 两个文本之间的间距

          Align(
            alignment: Alignment.bottomCenter,
            child:
            ElevatedButton(
              onPressed: updateRecommendation, // 刷新推荐
              child: Text('Dislike ?', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 60.0), // 控制整体内容距顶部的距离
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Clear recorded data?',style: TextStyle(fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog(context),
                child: Text('Yes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('The data is not recoverable after clearing, are you sure you want to clear the historical data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                _clearData(context);
              },
              child: Text('Yes, I confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); // 返回主页面
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _clearData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('diningRecords'); // 假设用餐记录存储在 'diningRecords' 键下
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Historical data has been cleared'),
    ));
  }
}

// Database 页面用于展示用户保存的用餐记录
class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  double averageMealsPerDay = 0; // 平均每日用餐次数
  Map<String, String> averageMealTimes = {}; // 各餐的平均时间
  Map<String, double> placePercentages = {}; // 就餐地点百分比

  @override
  void initState() {
    super.initState();
    _loadDiningData();
  }

  void _loadDiningData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> diningRecords = prefs.getStringList('diningRecords') ?? [];

    // 计算平均每日用餐次数
    final dates = diningRecords.map((record) => record.split(' ')[0]).toSet(); // 用餐日期集合，去重
    averageMealsPerDay = diningRecords.length / dates.length; // 总用餐次数除以不同的天数

    // 计算每餐的平均时间
    Map<String, int> totalMealTimes = {'Breakfast': 0, 'Lunch': 0, 'Dinner': 0};
    Map<String, int> mealCounts = {'Breakfast': 0, 'Lunch': 0, 'Dinner': 0};


    for (String record in diningRecords) {
      List<String> parts = record.split(' ');
      List<String> timeParts = parts[1].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      String mealType;
      if (hour >= 6 && hour < 11) mealType = 'Breakfast';
      else if (hour >= 11 && hour < 15) mealType = 'Lunch';
      else if (hour >= 15 && hour < 22) mealType = 'Dinner';
      else continue; // 如果不在定义时间范围内，不计入统计

      totalMealTimes[mealType] = totalMealTimes[mealType]! + hour * 60 + minute;
      mealCounts[mealType] = mealCounts[mealType]! + 1;
    }

    Map<String, String> tempAverageMealTimes = {};
    totalMealTimes.forEach((mealType, totalTime) {
      if (mealCounts[mealType]! > 0) {
        int averageTime = totalTime ~/ mealCounts[mealType]!;
        tempAverageMealTimes[mealType] =
        '${(averageTime ~/ 60).toString().padLeft(2, '0')}:${(averageTime % 60).toString().padLeft(2, '0')}';
      }
    });

    Map<String, int> placeCounts = {};
    diningRecords.forEach((record) {
      String place = record.split(' at ')[1];
      if (place != 'Null') {  // 跳过 'Null' 选项
        placeCounts[place] = (placeCounts[place] ?? 0) + 1;
      }
    });

    // 计算每个地点的用餐百分比
    int totalValidPlaces = diningRecords.where((record) => !record.endsWith('Null')).length;
    placeCounts.forEach((key, value) {
      placePercentages[key] = (value / totalValidPlaces) * 100;
    });

    setState(() {
      averageMealTimes = tempAverageMealTimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.only(top: 60.0), // 控制文本距顶部的距离
          children: [
            ListTile(
              title: Text('Average number of meals per day', style: TextStyle(fontSize: 16)),
              trailing: Text('${averageMealsPerDay.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 30),
            ...averageMealTimes.entries.map((entry) => ListTile(
              title: Text('${entry.key} average time', style: TextStyle(fontSize: 16)),
              trailing: Text(entry.value, style: TextStyle(fontSize: 16)),
            )).toList(),
            SizedBox(height: 30),
            ...placePercentages.entries.map((entry) => ListTile(
              title: Text('${entry.key}', style: TextStyle(fontSize: 16)),
              trailing: Text('${entry.value.toStringAsFixed(2)}%', style: TextStyle(fontSize: 16)),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String timeSinceLastMeal = '';

  @override
  void initState() {
    super.initState();
    _calculateTimeSinceLastMeal();
  }

  void _calculateTimeSinceLastMeal() async {
    final prefs = await SharedPreferences.getInstance();
    // 假设diningRecords中的每条记录都是“yyyy-MM-dd HH:mm at Place”格式
    List<String> diningRecords = prefs.getStringList('diningRecords') ?? [];

    if (diningRecords.isNotEmpty) {
      String lastMealRecord = diningRecords.first;
      DateTime lastMealDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(lastMealRecord.split(' at ')[0]);
      DateTime now = DateTime.now();

      Duration difference = now.difference(lastMealDateTime);

      setState(() {
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        int minutes = difference.inMinutes % 60;
        timeSinceLastMeal = '${days > 0 ? '$days day ' : ''}${hours} hours ${minutes} minutes';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On-time Eater'),
      ),
      body: Stack(
        children: <Widget>[
          //主页面提示词
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 150.0), // 控制整体内容距顶部的距离
              child: Column(
                mainAxisSize: MainAxisSize.min, // 使 Column 占用的空间适应子部件的大小
                children: [
                  Text(
                    'Have you eaten yet?', // 第一个文本
                    style: TextStyle(fontSize: 36), // 可以调整文本大小
                  ),
                  SizedBox(height: 20), // 两个文本之间的间距

                  Text(
                    'From last meal: $timeSinceLastMeal', // 第二个文本
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 50), // 两个文本之间的间距

                  ElevatedButton(
                    onPressed: _calculateTimeSinceLastMeal, // 按钮点击事件，触发数据刷新
                    child: Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),

          // 使用 Align 将按钮组放置在屏幕中心靠下的位置
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使 Column 尽可能小
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Record()),
                    );
                  },
                  child: Text('Record'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)), // 设置按钮的最小宽度和高度
                  ),
                ),
                SizedBox(height: 20), // 按钮 1 和 按钮 2 之间的间距

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Suggestion()),
                    );
                  },
                  child: Text('Suggestion'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)), // 设置按钮的最小宽度和高度
                  ),
                ),
                SizedBox(height: 20), // 按钮 2 和 按钮 3 之间的间距

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Database()),
                    );
                  },
                  child: Text('Database'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)), // 设置按钮的最小宽度和高度
                  ),
                ),
                SizedBox(height: 75), // 与底部的距离
              ],
            ),
          ),
          // 使用 Align 将第四个按钮放置在屏幕右上角
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8.0), // 与顶部和右侧的距离
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                child: Text('Settings'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(100, 50)), // 设置按钮的最小宽度和高度
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => HomePage(),  // 假设这是您的主页
      '/database': (context) => Database(),  // 确保这里的路由名称与您跳转时使用的一致
    },
    //home: HomePage(),
  ));
}

