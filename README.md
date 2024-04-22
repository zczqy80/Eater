# On-time Eater

It's an app that tracks your eating habits and gives you recommendations, which includes following functions:

Record the time and type of each meal

Remind you to eat at the right time

Giving advice when you don't know what to eat

Count and analysis your eating 


# Target user

Record: People who want to keep systematic record on their eating habits.

Analysis: People who wants to improve their diet.

Advice: People who want to eat and don't know what to eat.

Remind: People who are negative about eating or dislike eating.


# Storyboard

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/7cbc7317-e73e-4acc-8c1a-03bc8ef11e97">
</div>

# Development record

##  1.Home page and subpage creation

As mentioned in the introduction section, the main page has four interactive buttons that lead to the Record, Suggestion, Database, and Settings subpages. The first three buttons are located in the lower middle of the main page, and the Settings sub-page button is in the upper right corner of the screen. The effect of the main page is shown in the following figure:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/cdaa4e3e-580a-464b-bf9d-391217a0904b">
</div>

The remaining 4 sub-pages do not add functional modules now, and the module function of the record page is planned to be added in the next update. The effect of the 4 sub-pages is shown below:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/e46f74d3-fc68-4781-9c92-654369d6c28d">
</div>

The main.dart code for this update has now been uploaded to a file called 'Main.dart__1st: Home page and subpage creation'.

##  2.Record function

In this update, a functional module has been added to the record page, in which users can choose the time and place to record their meals, as shown in the following figure：

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/0446c7bd-f01c-411b-ac73-1c79c5e38952">
</div>

A drop-down list is generated when the user records the time and place, and the time option is subtracted according to the user's selected time difference and the current time to get the user's actual meal time. intl package is used to introduce formatted dates. 

The location options are available in home, take out, and null. The shared_preferences package is used to permanently store user record data locally, even after the app is closed, the user can still access the previously recorded data list, as shown below：

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/80141044-6403-48c7-a713-696f800b4af9">
</div>

After the user completes the selection, click the save button to save the data to the data table, and then a small pop-up window will pop up to ask the user what to do next

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/7c49e28a-f00b-4e68-9fd2-fc61d1369e5c">
</div>

The user can return to the main page, or go to the database page to view their history, the current database page can display the user's last 5 data records. In the next update, the data will be statistically categorized on the database page, such as calculating the average number of meals per day and the average meal time.

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/b0ef8f9a-0548-422e-b234-14ea0c6be670">
</div>

The main.dart code for this update has now been uploaded to a file called 'Main.dart__2nd: Record function'.

##  3.Mealtime data processing

In this update, the ability to process and display mealtime data has been added to the database page. Now app can query the recorded data table, count the number of meals per day, and classify them into three periods of breakfast, lunch and dinner according to small meals, and then display the average meal time of each period. The effect is shown below:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/aa5fe42b-9804-4a28-b9a3-867d6a4d4eb">
</div>

The data in the figure is only used for random input during the test and has no practical significance. The statistical time for breakfast is 6:00 to 11:00, for lunch is 11:00 to 15:00, and for dinner is 15:00 to 22:00. The rest of the time is not counted. Data processing of dining locations will be added in the next update.

The main.dart code for this update has now been uploaded to a file called 'Main.dart__3rd: Mealtime data processing'.

##  4.Meal location data processing

In this update, it is now possible to display the percentage of places to eat, and a reminder of meal times has been added to the home page, which tells users how long it has been since their last meal. In addition, the function of deleting historical data in the Settings page is added and reminded. The database page now looks like the following:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/86d39b34-e8b4-4f22-8cf6-32cf6e726e18">
</div>

Secondly, users can see the time since their last meal on the home page:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/2a12bff7-a044-4edb-882f-e237bfde4b9c">
</div>

Finally, the setting page function is added. Now users can choose to clear historical data on the setting page:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/4f8e8b53-277d-4bc3-b27f-d86c359ff8ba">
</div>

Since the clearing of historical data is not recoverable, an additional page will pop up to ask the user for confirmation:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/cd667fff-cce5-4238-81f3-6b7490c97e37">
</div>

In the next update, the suggestion page for weather and humidity, and make food recommendations based on environmental conditions is planed to be finished.

The main.dart code for this update has now been uploaded to a file called 'Main.dart__4rd: Meal location data processing'.

##  5.Get the address and weather as well as food recommendations

The last feature added to the app in this update is now available on the suggestion page, with user permissions. After permission, the app can obtain the user's current latitude and longitude, and get the temperature and weather information through api access.

After getting the weather conditions, the app will randomly select and recommend food types from the list according to different temperature and humidity, and when the food types are not satisfied, users can choose to click the button to re-recommend:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/6898b930-90dd-400b-9900-399f252f9b23">
</div>

In addition, the main page has been re-improved. The original main page cannot be refreshed, that is, after the user completes a new record, the time difference between now and the last meal time will not change. Now a refresh button has been added to the main page, which users can manually refresh to get the exact last meal interval:

<div align="center">
  <img src="https://github.com/zczqy80/Eater/assets/146266229/063ce263-520c-436b-aee1-a689b92dfa3b">
</div>

The main.dart code for this update has now been uploaded to a file called 'Main.dart__5rd: Get the address and weather as well as food recommendations'.
(ps: API token of weather has been replaced)

##  6.Apk release and web page

The apk file of the App has been uploaded to the main folder, and all project files have been uploaded to the folder named casa0015cw.

The introduction page of the App was compiled and all contents were uploaded to a folder named On-time Eater web page.

In addition, the final code of the project, along with English comments, has now been uploaded to a file called 'Main.dart__6rd: Completed code with English commons'.

#  Contact Details

The author's school email address is zczqy80@ucl.ac.uk. If you have any further inquiries about this app, please feel free to contact us via email
