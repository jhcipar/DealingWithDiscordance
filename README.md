## DealingWithDiscordance

## Overview

### Quickstart/I don't care that much about details right now, I just want to put the code in here and figure out what these things mean later

open a terminal window and type `git --version`, if you don't have git installed this should prompt you on how to install it. You can also check out https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

Once you have git installed enter `cd ~/git` into your terminal window

Enter `git clone https://github.com/jhcipar/DealingWithDiscordance.git && cd DealingWithDiscordance`

Enter `git checkout -b 'add_discordance_code'`

(if you use VScode you can also type `code .` into your terminal window, this will open VScode in the current directory)

Put the discordance code into the repository, doesn't matter how (`mv` or copy paste in VSCode) or just make an experimental change if you want to test this out (you can make a text file or something)

Enter `git add .`
Enter `git commit -m 'initial commit'`
Enter `git push -u origin main`

### Git setup
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

In a terminal window, you should be able to just type `git --version`. If you don't have git installed, this should prompt you on how to install it.

Once it's installed, you should be able to clone this repository to your local machine. Navigate to a folder in the terminal where you want to store this repository. I like to use ~/git/ - if you want to do that, you can do:
`cd ~/git`
followed by:
`git clone https://github.com/jhcipar/DealingWithDiscordance.git`
(we can change this to be owned by one of y'all if you want)

If this works, you should now have a copy of this repository on your local machine. If you type `ls` in the terminal, you should see the folder `DealingWithDiscordance`. Change your working directory into that folder by typing `cd DealingWithDiscordance`.

This folder is a git repository, meaning it now has certain properties. Most importantly, it handles changes to code within it in a way that allows us to add, change, or remove features more easily.

### Branches
The first concept you should understand is a **branch**. You can have several branches stored in parallel in the same repository on your machine or locally. You can make changes to different branches without having them touch each other, and then merge branches together.

This is what allows multiple people to work on a single app at the same time, or a single person to work on multiple different features at the same time locally. Right now you're on the `main` branch. The main branch is what it sounds like - the primary version of your app.

In general, the development cycle involves creating a new branch from `main`, making changes to the code on that new branch, and then merging the changes from that new branch into `main`.

To be continued...