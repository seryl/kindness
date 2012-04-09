# Kindness

* [joshtoft.com/kindness](http://joshtoft.com/kindness)
* [github.com/seryl/kindness](https://github.com/seryl/kindness)

A nice way to bootstrap your box (with chef).

Sets up your brew, ruby and python environments in a sane manner.

## Installing

    bash < <(curl -sL https://bit.ly/install-kindness)

## What do I get?

    homebrew, git, rvm, ruby19, chef, Virtualbox, veewee, lunchy

Also comes with recipes for...

    pip, virtualenv, virtualenvwrapper
    

## Commands

Updating kindness

    kindness update
    
Adding a personal site-cookbooks repository

    kindness site [url]
    kindness site https://github.com/seryl/kindness-cookbooks.git
    

Completely remove kindness

    kindness implode
