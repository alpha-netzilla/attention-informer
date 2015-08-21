# What's this
"Attention Informer" is an app that discovers claims in twitters using automated analytics powered by Insights for Twitter and the Natural Language Classifier(NLC) on IBM Bluemix. The app is able to detect the negative tweets and judge grammatical homophone correctly.  
This time I assume the condition that are able to use in the cell phone companies in America, but it will be used anywhere in general. 



# Synopsis
From twitter timeline
- extract positive, negative tweets.
- detect the proper department to deal with claims from the content.
  
I used a few services on bluemix produced by IBM at the point of (1), (2), (3)

  ```
    twitter → positive tweets  
            → negative tweets  → department1
        (1), (2)               → department2
                              (3)
  ```

**Insights for Twitter**  
    (1) abnormal detection  
It classifies negative and positive tweet.  
Abnormal condition is when the ratio of negative tweet exceeds 10% of the total tweet.  


**Natural Language Classifier(NLC)**  
It is necessary to learn before operating the app.  
Later I explain.  

(2) homonyms discrimination  
For example, when searching the sprint, it is not necessarily the discovery associated with mobile companies.  
   
    o: I wanna Apple iPhone sold in sprint.  
    x: I need to work on my sprint finish.  

(3) notification destination discrimination  
    In this application, it was implemented by assuming the "base station monitoring department" and "server monitoring department" as the notification destination.  

    base station: Can't call any Sprint customers right now for some reason.
    server：      Sprint server down? There is no valid DNS server so !?

This time I have been using the twilio as a notification means, but of course any tools like mail are good as well.



# Demo
https://youtu.be/UkwGlk7h5eU



# See also
