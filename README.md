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

![image](https://github.com/zczqy80/Eater/assets/146266229/7cbc7317-e73e-4acc-8c1a-03bc8ef11e97)


# Development record

##  1.Home page and subpage creation

As mentioned in the introduction section, the main page has four interactive buttons that lead to the Record, Suggestion, Database, and Settings subpages. The first three buttons are located in the lower middle of the main page, and the Settings sub-page button is in the upper right corner of the screen. The effect of the main page is shown in the following figure:

![image](https://github.com/zczqy80/Eater/assets/146266229/cdaa4e3e-580a-464b-bf9d-391217a0904b)

The remaining 4 sub-pages do not add functional modules now, and the module function of the record page is planned to be added in the next update. The effect of the 4 sub-pages is shown below:

![image](https://github.com/zczqy80/Eater/assets/146266229/e46f74d3-fc68-4781-9c92-654369d6c28d)

The main.dart code for this update has now been uploaded to a file called 'Main.dart__1st: Home page and subpage creation'.

##  2.Record function

In this update, a functional module has been added to the record page, in which users can choose the time and place to record their meals, as shown in the following figure：

![image](https://github.com/zczqy80/Eater/assets/146266229/0446c7bd-f01c-411b-ac73-1c79c5e38952)

A drop-down list is generated when the user records the time and place, and the time option is subtracted according to the user's selected time difference and the current time to get the user's actual meal time. intl package is used to introduce formatted dates. 

The location options are available in home, take out, and null. The shared_preferences package is used to permanently store user record data locally, even after the app is closed, the user can still access the previously recorded data list, as shown below：

![image](https://github.com/zczqy80/Eater/assets/146266229/80141044-6403-48c7-a713-696f800b4af9)

After the user completes the selection, click the save button to save the data to the data table, and then a small pop-up window will pop up to ask the user what to do next

![image](https://github.com/zczqy80/Eater/assets/146266229/7c49e28a-f00b-4e68-9fd2-fc61d1369e5c)

The user can return to the main page, or go to the database page to view their history, the current database page can display the user's last 5 data records. In the next update, the data will be statistically categorized on the database page, such as calculating the average number of meals per day and the average meal time.

![image](https://github.com/zczqy80/Eater/assets/146266229/b0ef8f9a-0548-422e-b234-14ea0c6be670)

The main.dart code for this update has now been uploaded to a file called 'Main.dart__2nd: Record function'.

#  Contact Details

Having Contact Details is also good as it shows people how to get in contact with you if they'd like to contribute to the app. 
