# What's this
"Attention Informer" is an app that discovers claims in twitters using automated analytics powered by "Insights for Twitter" and "Natural Language Classifier(NLC)" on IBM Bluemix. The app is able to detect the negative tweets and judge grammatical homophone correctly.  
This time I assume the condition useed in the cell phone companies in America, but it will be utilized anywhere in general. 



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


# UI
![before](http://4.bp.blogspot.com/-0x2Xdo2qZEc/Veal9hDugMI/AAAAAAAAAaE/qa8lU5r6avU/s640/attention-informer_before.png "before")
![after](http://4.bp.blogspot.com/-M4bUAgcRv3s/VecRqlJcq5I/AAAAAAAAAao/19EtrzbcQ2Y/s640/attention-informer_after.png "after")



# Demo
(Japanese) 3min  
https://www.youtube.com/watch?v=UkwGlk7h5eU  

(English) 30sec  
https://www.youtube.com/watch?v=QfVdRtdxTCk  
Designed by [Nishi](https://instagram.com/pandaphone/)



# Notice
Please change below when to use it.  
$ vi app/controllers/twitter_controller.rb

    def post_nlc && def get_tweet
      ~snip~
      account = "your account"
      password = "your password"




# See also
http://alpha-netzilla.blogspot.jp/2015/09/attention-informer.html  
programmer' page

