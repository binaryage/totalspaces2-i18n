# TotalSpaces Internationalization ([totalspaces.binaryage.com](http://totalspaces.binaryage.com))

**TotalSpaces** is an app that brings grid spaces to OSX. This project gathers localizable resources.

<img width="500" src="http://totalspaces.binaryage.com/images/grid-view.png">

## Do you want to translate TotalSpaces into your language?

You can tweak resource files and add your preferred language.

The idea is to install TotalSpaces and then symlink its langname.lproj folder to the copy in this repository where you can edit it.
You should push your changes back to GitHub and I will then incorporate your work into [next TotalSpaces release](http://totalspaces.binaryage.com/changes).

## Where to start?

1. Read something about git version control system. Here is [the best place to start](http://git-scm.com/documentation).
2. Get familiar with GitHub. They have also [nice docs](http://help.github.com).
3. Create GitHub user and don't forget to [setup your local git](http://help.github.com/mac-set-up-git) so your commits are linked to your GitHub account.
4. See how others are working on [TotalSpaces localization](http://github.com/binaryage/totalspaces-i18n/network).

## The Workflow

### Initial step

1. [fork this project](http://help.github.com/fork-a-repo) on GitHub
2. [clone your fork](http://help.github.com/remotes) (let's assume you have it in `~/totalspaces-i18n`)
3. make sure you have [installed latest TotalSpaces](http://totalspaces.binaryage.com/changes) version
4. `cd ~/totalspaces-i18n` and run `./bin/dev.sh langname` - where langname should be the two character language code from [ISO 639-1](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)

### Development

1. edit files
2. validate your changes with `rake validate` (before first run execute `sudo gem install cmess` to install supporting library - you may also need to gem install iconv)
3. use `./bin/restart.sh` to restart TotalSpaces to reflect your changes
4. commit if needed - you can `./bin/commit.sh`
5. goto 1

### Final step

1. [push to github](http://help.github.com/remotes) and send a [pull request](http://help.github.com/pull-requests)
2. (optional) run `./bin/undev.sh langname` to return to unaltered TotalSpaces state (this won't delete your files, it will [just unlink](totalspaces-i18n/blob/master/undev.sh) sym-linked folder)

## Questions?

### What encoding should I use for my files?
> Please always use UTF-8. Other encodings will probably fail to load or you will see wrong characters. Run `rake validate` task to check your files.

### I have created MYLANGUAGE.lproj and modified string files.<br>I've restarted the TotalSpaces.app, but I don't see my localization. What's wrong?
> Double check you have MYLANGUAGE as top-most language in the `System Preferences > Language & Text > Language` list.

### May I alter dimensions in the UI to fit my language?
> Not at present. I'm using technique for defining flexible areas to fit different languages as [described here](http://code.google.com/p/google-toolbox-for-mac/wiki/UILocalization). But if the text overflows the area available, you should try to find a shorter way to express it. In dire cases please contact me and I will try to help.

## Thank you!

Every contributor in [http://github.com/binaryage/totalspaces-i18n/contributors](http://github.com/binaryage/totalspaces-i18n/contributors) will get a free TotalSpaces license. Please note that you will appear there with delay and only if your commits are properly recognized as authored by your github's account. You have to [setup your local git user](http://help.github.com/git-email-settings) properly.

**To be clear. Please note that:**

1. It is not guaranteed that I will accept changes in your fork
2. You are contributing your work under [MIT style license](https://raw.github.com/binaryage/totalspaces-i18n/master/license.txt)
3. You may want to explore [Network Graph](http://github.com/binaryage/totalspaces-i18n/network) to see if someone has been already working on your language

#### License: [MIT-Style](https://raw.github.com/binaryage/totalspaces-i18n/master/license.txt)
