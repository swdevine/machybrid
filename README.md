# machybrid
Simple Makefile based Swift Cocoa / C Core Foundation MacOS App

This is a simple skeleton MacOS application. I needed a modern looking MacOS application that integrates with a old school C code. So after a lot of googling and trial and error this application satisfies these goals:

  - Use up-to-date MacOS Cocoa foundation
  - Use Swift for the Cocoa piece, I could never figure out objective-C
  - Easily integrate with exisiting C framework. 
  - Implement some views in C using Core Graphics and Core Text
  - Be able to build from the command line using make and makefiles

### Building
```
   # to build the min application
   > make
   
   # to run the bare executable
   > ./build/min
   
   # to run the .app bundle
   > cd build
   > open min.app
   
   # remove the build
   > make clean
```

### Notes
  
  - I threw all the swift into one file. It should be fine to structure the classes into their own files as xcode would do.
  - The main idea needed to compile from the command line without xcode is the last lines in main.swift. These do the initialization and running of the app delegate and main menu bar. Some things I have seen say this needs to be in a file called main.swift but I didn't try it so I don't know. Otherwise I think you can take files directly from xcode templates.
  - Info.plist does not need to be there. I have found that having it there fixes some weird behavior so I added it.
  - The icons are totally optional. Its one of the things that can't be done programtically so added them to the build.
      
Good luck!
