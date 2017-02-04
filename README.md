# Social-Recommendation-Expert-System


DESCRIPTION 

 The Social Meetup Recommender allows members to find and join groups unified by a common interest, such as Music , Adventure , Technology , Art etc. 
 Users enter their city and select the topic they want to meet about.
 The system helps them locate a group of like-minded people to arrange a place and time to meet.
 The aim of this system is to make finding social events easier filtered by location and interest.
 It eliminates the need to look-up or google or facebook events, which takes more time.
 This system automates the process of finding a social event based on city. People new to a city can easily socialize and network.
 The system interacts with the user to learn more about her/his interests and gives recommendations accordingly.


KNOWLEDGE BASE
NOTE: - The Knowledge base is given below in Jess. 
The knowledge base is determined by the user, as the user enters information, the choices are asserted, hence facts are defined and this is used as KB to make decisions.



(deffacts question-data
"The questions the system can ask."
(question (ident age) (type yes-no)
(text "Are you 18 years or older?"))
(question (ident city) (type string)
(text " Where do you live? Chicago or New York"))
(question (ident interest) (type string)
(text " What are you most interested in? Music, Art, Adventure, Technology "))
(question (ident rock) (type yes-no)
(text " Let me show you some Music genres!!
Do you like Rock & Roll?"))
(question (ident pop) (type yes-no)
(text " Do you like Pop music?"))
(question (ident classic) (type yes-no)
(text " Do you like Classical music?"))
(question (ident theatre) (type yes-no)
(text " Let me show you some Art genres !
Do you like Theatre?"))
(question (ident painting) (type yes-no)
(text " Do you like Painting?"))
(question (ident dancing) (type yes-no)
(text " Do you like Dancing?"))
(question (ident backpack) (type yes-no)
(text " Let me show you some Adventure genres !
Do you like to go Backpacking?"))
(question (ident hiking) (type yes-no)
(text " Do you like to go Hiking ?"))
(question (ident camp) (type yes-no)
(text " Do you like to go Camping?"))
(question (ident bigdata) (type yes-no)
(text " Let me show you some Technology genres !
Do you like BigData?"))
(question (ident cloud) (type yes-no)
(text " Do you like Cloud?"))
(question (ident machine) (type yes-no)
(text " Do you like Machine Learning?")))


TEST CASES

TESTCASE 1 :

----------|WELCOME TO THE MEETUP RECOMMENDER|----------
This software is meant to automate finding a Meetup in your local city.
Hi! I am Alexa. Let me help you in finding a Meetup nearby.

Please enter your name and then press enter key>

Dexter
Hello, Dexter.
Welcome to the Meetup Recommender
Please answer the following questions and we will show you some awesome Meetups for you.
What are you most interested in? Music, Art, Adventure, Technology music
Let me show you some Music genres!!
Do you like Rock & Roll? (yes or no) no
Do you like Pop music? (yes or no) no
Do you like Classical music? (yes or no) yes
Where do you live? Chicago or New York Chicago
You can go to the CLASSIC Meetup
Description:
CLASSICAL MUSIC MEETUPS IN CHICAGO
1) The Symphony of Oak Park & River Forest
Date : Sunday, February 12, 2017 4:00 PM to 6:15 PM
Location :Concordia University Chapel of Our Lord Bonnie Bra, Chicago, IL
https://www.meetup.com/chicagosymphony/events/236999656/
2) Romantic Duos (Evanston)
Date : Sunday, Feb 12,2017, 3:00 PM
Location : Musical Institute of Chicago Nichols Concert Hall , 1490 Chicago Ave, Evanston,IL
https://www.meetup.com/chicagosymphony/events/232565041/


TESTCASE 2:
----------|WELCOME TO THE MEETUP RECOMMENDER|----------
This software is meant to automate finding a Meetup in your local city.
Hi! I am Alexa. Let me help you in finding a Meetup nearby.

Please enter your name and then press enter key>
Ted
Hello, Ted.
Welcome to the Meetup Recommender
Please answer the following questions and we will show you some awesome Meetups for you.
What are you most interested in? Music, Art, Adventure, Technology art
Let me show you some Art genres !
Do you like Theatre? (yes or no) no
Do you like Painting? (yes or no) no
Do you like Dancing? (yes or no) no
Your city has only theatre , art , dancing.


TESTCASE 3:
----------|WELCOME TO THE MEETUP RECOMMENDER|----------
This software is meant to automate finding a Meetup in your local city.
Hi! I am Alexa. Let me help you in finding a Meetup nearby.

Please enter your name and then press enter key>
CHarlie
Hello, CHarlie.
Welcome to the Meetup Recommender
Please answer the following questions and we will show you some awesome Meetups for you.
What are you most interested in? Music, Art, Adventure, Technology technology
Let me show you some Technology genres !
Do you like BigData? (yes or no) no
Do you like Cloud? (yes or no) no
Do you like Machine Learning? (yes or no) yes
Where do you live? Chicago or New York Las Vegas
MeetUp Recommender isnt in your city yet!Choose between the following 2 cities:Chicago & New York
Where do you live? Chicago or New York Chicago
You can go to the MACHINELEARNING Meetup
Description:
MACHINE LEARNING MEETUPS IN CHICAGO
1)Chicago ML
Date : Tue Feb 28 7:00 PM
Location : 430 North Michigan Avenue #4, Chicago, IL
2)Open Source Anaytics
Date : Wed Feb 1
Location : TBD
