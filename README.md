# What?

![](http://i3.photobucket.com/albums/y83/SpaceGirl3900/LOLCat-Rainbow.jpg)

## Screenshot

![](https://github.com/busyloop/lolcat/raw/master/ass/screenshot.png)

## Installation

```bash
$ gem install lolcat
```

### Example Implementation

```bash
alias hextrip='cat /dev/urandom | hexdump -e "`echo $COLUMNS*1.0/3.0 | bc`/1 \"%02x \" \"\n\"" | lolcat -F 0.01'
```
