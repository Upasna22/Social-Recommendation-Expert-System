;; main Module

(deftemplate question
    (slot text)
    (slot type)
    (slot ident))

(deftemplate answer
    (slot ident)
    (slot text))

(deftemplate recommendation
    (slot meetup)
    (slot explanation))

(deffacts question-data
    "The questions the system can ask."
      (question (ident age) (type yes-no)
            	(text "Are you 18 years or older?"))
    
      (question (ident city) (type string)
            	(text "Where do you live? Chicago or NewYork"))
    
      (question (ident interest) (type string)
            	(text "What are you most interested in? music, art, adventure, technology "))
    
      (question (ident rock) (type yes-no)
            	(text "Let me show you some Music genres!!            
Do you like Rock & Roll?"))
    
    (question (ident pop) (type yes-no)
            	(text "Do you like Pop music?"))
    
    (question (ident classic) (type yes-no)
            	(text "Do you like Classical music?"))
    
       
     
    (question (ident theatre) (type yes-no)
            	(text "Let me show you some Art genres !
            
Do you like Theatre?"))
    
    (question (ident painting) (type yes-no)
            	(text "Do you like Painting?"))

	(question (ident dancing) (type yes-no)
            	(text "Do you like Dancing?"))
    
    (question (ident backpack) (type yes-no)
            	(text "Let me show you some Adventure genres !
            
Do you like to go Backpacking?"))
    
    (question (ident hiking) (type yes-no)
            	(text "Do you like to go Hiking ?"))
    
    (question (ident camp) (type yes-no)
            	(text "Do you like to go Camping?"))
        
    (question (ident bigdata) (type yes-no)
            	(text "Let me show you some Technology genres !
            
Do you like BigData?"))
    
      (question (ident cloud) (type yes-no)
            	(text "Do you like Cloud?"))
      (question (ident machine) (type yes-no)
            	(text "Do you like Machine Learning?")))
    
     
(defglobal ?*crlf* = "
        ")

;; ask Module

(defmodule ask)

(deffunction is-of-type (?answer ?type)
    "Check that the answer has the right form"
    (if (eq ?type yes-no) then
        (return (or (eq ?answer yes) (eq ?answer no)))
    elif (eq ?type number) then
        (return (numberp ?answer))
    else (return (> (str-length ?answer) 0))))

(deffunction ask-user (?question ?type)
  "Ask a question, and return the answer"
  (bind ?answer "")
  (while (not (is-of-type ?answer ?type)) do
         (printout t ?question " ")
         (if (eq ?type yes-no) then
           (printout t "(yes or no) "))
         (bind ?answer (read)))
  (return ?answer))

   
(defrule ask::ask-question-by-id
  "Given the identifier of a question, ask it and assert the answer"
  (declare (auto-focus TRUE))
  (MAIN::question (ident ?id) (text ?text) (type ?type))
  (not (MAIN::answer (ident ?id)))
  ?ask <- (MAIN::ask ?id)
  =>
  (bind ?answer (ask-user ?text ?type))
  (assert (answer (ident ?id) (text ?answer)))
  (retract ?ask)
  (return))

;; interview Module
(defmodule interview)

(defrule request-city
;; If the user lives in Chicago/New York...
  =>
  (assert (ask city)))

(defrule bad-choice
   ?choice <- (answer (ident city) (text ?cs&~Chicago&~NewYork))
   =>
   (retract ?choice)
   (assert (ask city))
   (printout t "MeetUp Recommender isnt in your city yet!Choose between the following 2 cities:Chicago & New York " crlf))

(defrule bad-choice
   ?choice <- (answer (ident city) (text ?cs&~Chicago&~NewYork))
   =>
   (retract ?choice)
   (assert (ask city))
   (printout t "MeetUp Recommender isnt in your city yet!Please choose between the following 2 cities:Chicago & New York " crlf))

(defrule bad-choice
   ?choice <- (answer (ident interest) (text ?cs&~music&~art&~adventure&~technology))
   =>
   (retract ?choice)
   (assert (ask interest))
   (printout t "Your city currently has only the following categories!Please choose between music, art, adventure and technology. " crlf))

;;--------City of Chicago------------

(defrule request-interest
  
  =>
  (assert (ask interest)))

;(defrule request-interest
  ;(answer (ident city) (text ?cs&:(eq ?cs NewYork)))
 ; =>
 ; (assert (ask interest)))

/*(defrule request-music
;; If the user has music...
  (answer (ident interest) (text ?cc&:(eq ?cc music)))
  =>
  (assert (ask music)))*/

(defrule request-rock
  (answer (ident interest) (text ?cc&:(eq ?cc music)))
  =>
  (assert (ask rock)))

(defrule request-pop
    (answer (ident rock) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc music)))
  =>
  (assert (ask pop)))

(defrule request-classic
   (answer (ident rock) (text ?y&:(eq ?y no)))
    (answer (ident pop) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc music)))
  =>
  (assert (ask classic)))


(defrule request-music1
    
  ( and
       (answer (ident pop) (text ?cgc&:(eq ?cgc no))) 
       (answer (ident rock) (text ?cau&:(eq ?cau no))) 
        (answer (ident classic) (text ?cat&:(eq ?cat no)))	
  )
     
  =>
  (printout t "Your city has only rock , pop, classic" crlf))

/*
(defrule request-art
;; If the user has art...
  (answer (ident interest) (text ?cc&:(eq ?cc art)))
  =>
  (assert (ask art)))*/

(defrule request-theatre
  (answer (ident interest) (text ?cc&:(eq ?cc art)))
  =>
  (assert (ask theatre)))

(defrule request-painting    
    (answer (ident theatre) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc art)))
  =>
  (assert (ask painting)))

(defrule request-dancing
		(answer (ident theatre) (text ?y&:(eq ?y no)))
    (answer (ident painting) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc art)))
  =>
  (assert (ask dancing)))
  

(defrule request-art1
    
  ( and(answer (ident theatre) (text ?c1&:(eq ?c1 no))) 
       (answer (ident painting) (text ?p1&:(eq ?p1 no))) 	
       (answer (ident dancing) (text ?p1&:(eq ?p1 no)))
  )
     
  =>
  (printout t "Your city has only theatre , art , dancing" crlf))
    
/*
(defrule request-adventure
;; If the user has adventure...
  (answer (ident interest) (text ?cc&:(eq ?cc adventure)))
  =>
  (assert (ask adventure)))*/

(defrule request-backpack   
  (answer (ident interest) (text ?cc&:(eq ?cc adventure)))
  =>
  (assert (ask backpack)))

(defrule request-hiking
    (answer (ident backpack) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc adventure)))
  =>
  (assert (ask hiking)))

(defrule request-camp
		(answer (ident backpack) (text ?y&:(eq ?y no)))
    (answer (ident hiking) (text ?y&:(eq ?y no)))
  (answer (ident interest) (text ?cc&:(eq ?cc adventure)))
  =>
  (assert (ask camp)))
  

(defrule request-adventure1
    
  ( and(answer (ident backpack) (text ?c1&:(eq ?c1 no))) 
       (answer (ident hiking) (text ?p1&:(eq ?p1 no))) 	
       (answer (ident camp) (text ?p1&:(eq ?p1 no)))
  )
     
  =>
  (printout t "Your city has only backpack,hiking,camp" crlf))
    

/*(defrule request-technology
;; If the user has technology...
  (answer (ident interest) (text ?cc&:(eq ?cc technology)))
  =>
  (assert (ask technology)))*/

(defrule request-bigdata
      (answer (ident interest) (text ?cc&:(eq ?cc technology)))
  =>
  (assert (ask bigdata)))

(defrule request-cloud
    (answer (ident bigdata) (text ?y&:(eq ?y no)))
    (answer (ident interest) (text ?cc&:(eq ?cc technology)))
  
  =>
  (assert (ask cloud)))

(defrule request-machine
	(answer (ident bigdata) (text ?y&:(eq ?y no)))
    (answer (ident cloud) (text ?y&:(eq ?y no)))
    (answer (ident interest) (text ?cc&:(eq ?cc technology)))
  =>
  (assert (ask machine)))
  

(defrule request-technology1
    
  ( and(answer (ident bigdata) (text ?c1&:(eq ?c1 no))) 
       (answer (ident cloud) (text ?p1&:(eq ?p1 no))) 	
       (answer (ident machine) (text ?p1&:(eq ?p1 no)))
  )
     
  =>
  (printout t "Your city has only bigdata , cloud , machine" crlf))
    






;; startup Module

(defmodule startup)

(defrule print-banner
    =>
    (printout t "----------|WELCOME TO THE MEETUP RECOMMENDER|----------" crlf)
    (printout t "This software is meant to automate finding a Meetup in your local city." crlf)
    (printout t " " crlf)
    (printout t "Hi! I am Alexa. Let me help you in finding a Meetup nearby." crlf)  
    (printout t "Please enter your name and then press enter key> " crlf)
    (bind ?name (read))
    (printout t crlf " " crlf)
    (printout t "Hello, " ?name "." crlf)
    (printout t "Welcome to the Meetup Recommender" crlf)
    (printout t "Please answer the following questions and we will show you some awesome Meetups." crlf)
    (printout t "Note : All inputs are case sensitive. Therefore values must be entered as shown in the questions." crlf)
    (printout t " " crlf crlf))

;; recommend Module

(defmodule recommend)

;;----------- Recommendations for Chicago--------------------


(defrule meetup-rock1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text music))
    (answer (ident rock) (text yes))
        
    =>
    (assert
        (recommendation (meetup RockRoll) (explanation " ROCK MUSIC MEETUPS IN CHICAGO. 
1)Poison Boys, Easy Habits and Criminal Kids at Cole's 
Date:     Friday, February 3, 2017 10:00 PM
Location: Cole's Bar 2338 N. Milwaukee Ave, Chicago, IL 
https://www.meetup.com/Chicago-Indie-Live-Music-Meetup/events/236341766/

2) Moon Tooth, Astronoid, TanZen Monday
Date:     February 6, 2017 7:00 PM 
Location: Reggie's Music Joint 2105 S State St, Chicago, IL
https://www.meetup.com/Chicago-Heavy-Metal-Group/events/236454341/

            
                "))))

(defrule meetup-pop1
  (and  (answer (ident city) (text Chicago))
    (answer (ident interest) (text music))
    (answer (ident pop) (text yes))
        )
    =>
    (assert
        (recommendation (meetup POP) (explanation " POP MUSIC MEETUPS IN CHICAGO. 
1)The Allman Brothers Band - At Fillmore East
Date:Sunday, February 5, 2017 3:30 PM to 4:30 PM
Location: Red Lion Pub - Lincoln Square 4749 N Rockwell St., Chicago, IL

2) Northland Acoustic Kickoff Jam 2017
Date: Monday, February 6, 2017,7:00 PM
Location: Needs a location
https://www.meetup.com/Northland-Acoustic-Guitar-Meetup/events/232617704/
                
                "))))

(defrule meetup-classic1
    (and(answer (ident city) (text Chicago))
    (answer (ident interest) (text music))
    (answer (ident classic) (text yes)))
    =>
    (assert
        (recommendation (meetup CLASSIC) (explanation "CLASSICAL MUSIC MEETUPS IN CHICAGO
1) The Symphony of Oak Park & River Forest 
Date : Sunday, February 12, 2017 4:00 PM to 6:15 PM
Location :Concordia University Chapel of Our Lord Bonnie Bra, Chicago, IL
https://www.meetup.com/chicagosymphony/events/236999656/
2) Romantic Duos (Evanston)
Date : Sunday, Feb 12,2017, 3:00 PM
Location : Musical Institute of Chicago Nichols Concert Hall , 1490 Chicago Ave, Evanston,IL https://www.meetup.com/chicagosymphony/events/232565041/

                "))))

(defrule meetup-theatre1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text art))
    (answer (ident theatre) (text yes))
    =>
    (assert
        (recommendation (meetup THEATRE) (explanation " THEATRE MEETUPS IN CHICAGO
1)	Chicagoland Theater Goers
Date : Fri Feb 3 6:00 PM
Location :1670 West Division Street, Chicago, IL
https://www.meetup.com/TheatreGoers/
2)Echo Theatre & Club
Date: Sun Feb 19 7:00 PM
Location : 6840 32nd St, Berwyn, IL
https://www.meetup.com/EchoTheaterCollaborative/ "))))


(defrule meetup-painting1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text art))
    (answer (ident painting) (text yes))
    =>
    (assert
        (recommendation (meetup PAINTING) (explanation " ART MEETUPS IN CHICAGO
1)Wicker Park Figure Drawing Group
    Date :  Sat Jan 28 3:30 PM
    Location : 1579 North Milwaukee Avenue, Chicago, IL
    https://www.meetup.com/Wicker-Park-Figure-Drawing-Group/

2)Chicago Art Times
Date : Sat Feb 4 2:00 PM
Location :University of Chicago
https://www.meetup.com/Chicago-Art-Times/

                "))))

(defrule meetup-dancing1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text art))
    (answer (ident dancing) (text yes))
    =>
    (assert
        (recommendation (meetup DANCING) (explanation " DANCE MEETUPS IN CHICAGO
1)Beginner Ballroom Dance Meetup
Date : Sat Jan 28 9:00 AM
Location : 410 S Michigan Ave, Chicago, IL
https://www.meetup.com/Beginner-Ballroom-Dance-Meetup/

2)Chicago Salsa!
Date : Thu Feb 2 8:15 PM
Location : 1175 W. Lake, Bartlett, IL
https://www.meetup.com/meetup-group-QqCYkAaB/

                "))))

(defrule meetup-backpack1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text adventure))
    (answer (ident backpack) (text yes))
    =>
    (assert
        (recommendation (meetup BACKPACK) (explanation "BACKPACKERS MEETUP IN CHICAGO
1)Chicago Backpackers
    Date : Sat Jan 28 8:00 AM
    Location : W329 N846 County C, Delafield, WI
    https://www.meetup.com/Chicago-Backpackers/

2)ChicagoLand Back-packing
   Date : January 9 · 7:00 PM
   https://www.meetup.com/Chicago-Backpackers/events/227972673/

                "))))

(defrule meetup-hiking1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text adventure))
    (answer (ident hiking) (text yes))
    =>
    (assert
        (recommendation (meetup HIKING) (explanation " HIKING MEETUPS
1)Chicago Hiking & Outdoors
Date : Sat Jan 28 1:00 PM
Location :3121 Patten Road, Highland Park, IL 
https://www.meetup.com/ChicagoHOS/

2)The Corn Desert hiking group
Date : Friday, February 3, 2017 12:00 PM
Location :To be decided

                "))))

(defrule meetup-camp1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text adventure))
    (answer (ident camp) (text yes))
    =>
    (assert
        (recommendation (meetup CAMP) (explanation " CAMP MEETUP IN CHICAGO
1)Chicago Camping , Canoeing & Outdoor Adventures Group
Date : Fri Mar 24 5:00 PM
Location : 14630 Oak Park Ave, Oak Forest, IL
https://www.meetup.com/ChicagoCampers/

2)Yeti Fall & Winter Camping group
Date : Sat Feb 4 12:00 PM
Location :Starved Rock State Park, Utica, IL
https://www.meetup.com/Chicago-Winter-Camping-Meetup/

                "))))

(defrule meetup-bigdata1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text technology))
    (answer (ident bigdata) (text yes))
    =>
    (assert
        (recommendation (meetup BIGDATA) (explanation " BIG DATA MEETUPS IN CHICAGO
1)Chicago Big Data
Date : Tue Feb 7 6:00 PM
Location : 111 W. Kinzie, Chicago, IL 
https://www.meetup.com/Chicago-Big-Data/

2)Data Science Chicago
Date : Nov 10, 6:00PM
Location: TBD
https://www.meetup.com/Data-Science-Chicago/

                "))))

(defrule meetup-cloud1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text technology))
    (answer (ident cloud) (text yes))
    =>
    (assert
        (recommendation (meetup CLOUD) (explanation " CLOUD MEETUPS IN CHICAGO
1)Chicago Cloud Foundry Group
Date : January 12 · 6:00 PM
Location :Slalom Chicago

2)Data 2.0 Chicago
Date : Tue Feb 7 6:00 PM
Location : 111 W. Kinzie, Chicago, IL

                "))))

(defrule meetup-machine1
    (answer (ident city) (text Chicago))
    (answer (ident interest) (text technology))
    (answer (ident machine) (text yes))
    =>
    (assert
        (recommendation (meetup MACHINELEARNING) (explanation " MACHINE LEARNING MEETUPS IN CHICAGO
1)Chicago ML
Date : Tue Feb 28 7:00 PM
Location : 430 North Michigan Avenue #4, Chicago, IL

2)Open Source Anaytics
Date : Wed Feb 1
Location : TBD

                "))))

;;------------------- Recommendations for NewYork-----------------------------

(defrule meetup-rock
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text music))
    (answer (ident rock) (text yes))
        
    =>
    (assert
        (recommendation (meetup RockRoll) (explanation " ROCK MUSIC MEETUPS IN NEWYORK. 
1) Rock and roll jam
Date Saturday, February 11, 2017 4:00 PM to 6:00 PM
Location: Ultra Sound Rehearsal Studio 251 West 30th Street, New York, NY
https://www.meetup.com/unnamedgroup/events/236928049/

2) Wild Women of Planet Wongo

Date:     Friday, February 3, 2017 8:00 PM 
to Saturday, February 4, 2017, 10:00 PM
Location: The Parkside Lounge 
317 East Houston, between Avenues B & C., Lower East Side, NY
https://www.meetup.com/concertsinnyc/events/237217454/
                

                "))))

(defrule meetup-pop
  (and  (answer (ident city) (text NewYork))
    (answer (ident interest) (text music))
    (answer (ident pop) (text yes))
        )
    =>
    (assert
        (recommendation (meetup POP) (explanation " POP MUSIC MEETUPS IN NEWYORK.
1)New York Chamber Music Meetup
Date: Friday, February 3, 2017
7:30 PM
Location: Christ & St. Stephen's Church
120 w. 69th Street, New York, NY
https://www.meetup.com/chamber-27/events/237225589/
2) The Baby Grand Karaoke Club
Date: Tuesday, January 31, 2017 7:00 PM
Location: Needs a location
https://www.meetup.com/The-Baby-Grand-Karaoke-Club/events/237204732/

                
                "))))

(defrule meetup-classic
    (and(answer (ident city) (text NewYork))
    (answer (ident interest) (text music))
    (answer (ident classic) (text yes)))
    =>
    (assert
        (recommendation (meetup CLASSIC) (explanation "CLASSICAL MUSIC MEETUPS IN NEWYORK.
1) How to Bluff About Classical Music

Date : Friday, February 3, 2017
8:00 PM

Location : Lincoln Center- Bruno Walter Auditorium
111 Amsterdam Avenue
between 64th and 65th streets
New York, NY 
https://www.meetup.com/CLASSICAL-4-ALL/events/236990547/

2) Eliane Delage Guitar Ensemble
Date : Saturday, February 4, 2017
12:00 PM to 2:00 PM
Location: Studios 353
353 W 48th St, New York, NY
https://www.meetup.com/Eliane-Delage-Guitar-Ensemble/events/236945828/


                
                "))))

(defrule meetup-theatre
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text art))
    (answer (ident theatre) (text yes))
    =>
    (assert
        (recommendation (meetup THEATRE) (explanation " THEATRE MEETUPS IN NEWYORK
Chicagoland Theater Goers
Date : Fri Feb 3 6:00 PM
Location :1670 West Division Street, Chicago, IL
https://www.meetup.com/TheatreGoers/
2)Echo Theatre & Club
Date: Sun Feb 19 7:00 PM
Location : 6840 32nd St, Berwyn, IL
https://www.meetup.com/EchoTheaterCollaborative/

                
                "))))

(defrule meetup-painting
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text art))
    (answer (ident painting) (text yes))
    =>
    (assert
        (recommendation (meetup PAINTING) (explanation "ART MEETUPS IN NEWYORK

1) I love ART Museums!
 Date :  Sat Feb 18 12:00 PM
 Location : 4 West 54th Street, New York, NY
 https://www.meetup.com/I-love-ART-Museums/

2) New York City Art Meetup
Date : Sun Jan 29
3:00 PM
Location : 302 W. 51st Street, 10019, NY 
https://www.meetup.com/NYC-Art-Meetup/



                "))))

(defrule meetup-dancing
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text art))
    (answer (ident dancing) (text yes))
    =>
    (assert
        (recommendation (meetup DANCING) (explanation " DANCE MEETUPS IN NEWYORK

Beginner Hip Hop Dance Classes NYC
Date : Sat Feb 11 5:00 PM
Location: 257 West 39th Street, 14th Floor, New York, NY
https://www.meetup.com/ucanduitonline/

2) Salsa New York
Date : Mon Jan 30 6:30 PM
Location : 412 8th Ave & 31st St, 4th Floor, New York, NY
https://www.meetup.com/salsanewyork/

                
                "))))

(defrule meetup-backpack
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text adventure))
    (answer (ident backpack) (text yes))
    =>
    (assert
        (recommendation (meetup BACKPACK) (explanation " BACKPACKERS MEETUP IN NEWYORK
1)The Hiking and Nature Meetup
Date : Tue Jan 31 3:30 PM
Location : Rt 9D / Bear Mountain Bridge,, Peekskill, NY
https://www.meetup.com/New-York-City-Hiking/

2)NewYork Land Back-packing
   Date : January 9 · 7:00 PM


                
                "))))

(defrule meetup-hiking
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text adventure))
    (answer (ident hiking) (text yes))
    =>
    (assert
        (recommendation (meetup HIKING) (explanation " HIKING MEETUPS IN NEWYORK
1) The Hiking and Nature Meetup
 Date : Tue Jan 31 3:30 PM
  Location : Rt 9D / Bear Mountain Bridge,, Peekskill, NY
  https://www.meetup.com/New-York-City-Hiking/

2) NYC Chill Hiking, Camping, and Other Activities
Date : Sun Jan 29 1:00 PM
Location : 334 West 46 Street, New York, NY 
https://www.meetup.com/NYC-Chill-Hiking-Camping-Meetup/

                
                "))))

(defrule meetup-camp
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text adventure))
    (answer (ident camp) (text yes))
    =>
    (assert
        (recommendation (meetup CAMP) (explanation " CAMP MEETUPS IN NEWYORK

1) Catskill Getaway Group
•	Date : Fri Jan 27
7:00 PM
Location : Malden Ave, Palenville, NY
https://www.meetup.com/Catskill-Getaway-Group/

2) Sundance Outdoor Adventure Society
Date : Sat Feb 4 12:00 PM
Location : 208 W. 13th St. 
New York, NY 
https://www.meetup.com/Sundance-Outdoor-Adventure-Society/

                
                "))))

(defrule meetup-bigdata
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text technology))
    (answer (ident bigdata) (text yes))
    =>
    (assert
        (recommendation (meetup BIGDATA) (explanation " BIG DATA MEETUPS IN NEWYORK
1) Big Data Genomics NYC

Date : Thu Feb 23 7:00 PM
Location : 1140 broadway, 11th Floor, NY, NY  
https://www.meetup.com/Big-Data-Genetics/

2) Future of Data: New York
Date : Mon Feb 6 5:30 PM
Location: TBD
https://www.meetup.com/futureofdata-newyork/


                "))))

(defrule meetup-cloud
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text technology))
    (answer (ident cloud) (text yes))
    =>
    (assert
        (recommendation (meetup CLOUD) (explanation "CLOUD MEETUPS IN NEWYORK

1) Cloud and Data Center Professionals
Date : Feb 12 · 6:00 PM
Location : Needs a location
https://www.meetup.com/cloudprofessionals/

2) Snowflake Computing Cloud Data Warehousing Meetup
Date : Apr 7, 2016 · 12:00 PM
Location : location is shown only to members
https://www.meetup.com/Snowflake-Computing-Cloud-Data-Warehousing-Meetup/events/230142929/


                "))))

(defrule meetup-machine
    (answer (ident city) (text NewYork))
    (answer (ident interest) (text technology))
    (answer (ident machine) (text yes))
    =>
    (assert
        (recommendation (meetup MACHINELEARNING) (explanation " MACHINE LEARNING MEETUPS IN NEWYORK

1) NYC Machine Learning
Date : Tue Feb 28 7:00 PM
Location : TBD
https://www.meetup.com/NYC-Machine-Learning/

2) NYC Women in Machine Learning & Data Science
Date : Fri Feb 3 6:00 PM
Location : 101 Barclay Str., 10FL-East Auditorium, New York, NY 
https://www.meetup.com/NYC-Women-in-Machine-Learning-Data-Science/


                "))))

;; report Module

(defmodule report)

(defrule sort-and-print
    ?r1 <- (recommendation (meetup ?f1) (explanation ?e))
    (not (recommendation (meetup ?f2&:(< (str-compare ?f2 ?f1) 0))))
    =>
    (printout t crlf " " crlf)
    (printout t "You can go to the " ?f1 " Meetup" crlf)
    (printout t "Description: "  crlf ?e crlf)
    (retract ?r1))

;; run Module

(deffunction run-system ()
    (reset)
    (focus startup interview recommend report)
    (run))

(while TRUE
    (run-system))