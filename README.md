# WWDC-2019-Scholarship

This is the playground I submitted for WWDC19 Scholarship and luckily it was accepted 😊 It's also my first time applying for WWDC Scholarship.

I spend about three full days to complete this playground. I give my playground the name “Potentials Of You”, because this playground illustrates four kinds of biological electric potentials in our body.

This playground introduces four kinds of "potentials" of human body. The word "potential" has two meanings. For one thing, it means the qualities that exist and can be developed. For another, it also means the difference in voltage between two points in an electric field or circuit. Here the word "potential" is a pun, meaning both human potentials and biological electric potentials.

I got my idea since my major is related to both computer science and biology, and I hope to spread more biological knowledge to ordinary people.

![demo of the playground](https://raw.githubusercontent.com/AndyLuoJJ/WWDC-2019-Scholarship/master/demo.gif)

**Attention**

I upgraded my Xcode to version 10.2 ASAP which contains Swift 5. However, my playground is completed under Xcode 10.1 and Swift 4. Therefore, I have to modify my code to have it work under Swift 5. 

If you are using Xcode 10.1 or earlier, please modify the code a little bit to make it work:

1. Add ? after "jsonParser" of line 30 in ```Contents.swift```
2. Add ? after "jsonParser" of line 31 in ```Contents.swift```
3. Add ? after "jsonParser" of line 66 in ```Contents.swift```

The cause of this problem is that in Swift 5, the ```try?``` expression doesn't introduce an extra level of optionality to expressions that already return optionals. Hence, I need to remove those extra question-marks in my code 😄