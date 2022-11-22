# txtfriendscli
I wrote a simple bash script that allows you to view people's friend.txt files.

# Usage
```
Usage: ./txtfriendscli.sh [-s siteURL] [-m menu] [-h]
    -h Print usage and basic information
    -s The website url without https:// or the trailing /friends.txt (just the domain)
    -m The menu you would like to use. Default is fzy but other options include: whiptail, dialog, dmenu, and rofi
```

# Concept
The friend.txt concept was originally concieved in the discord server [dank linux users](https://bugswriter.com/blog/reddit-and-discord/). It is meant to be a web of personal sites where all you would do is have a plain text file (with proper CORS headers) that would contain a list of people's personal websites. This web of websites would be a cool way for people to show their "friends".
