Fuck all TODO managers.

I want something that works and is simple. How hard can that be?

The plan:

1. a single-user, self-hosted (or Heroku-hosted!) REST server with smart server-side task parsing, so that making clients is as easy as possible (and no easier)
2. a command-line client
3. a client that acts as a text file (I will make it work well with at least [ST](http://www.sublimetext.com/) and vim)
4. a web interface
5. an Android client

The first three should fit into 100 lines of code.

So far:

1. 25 SLOC

Parsing:
Task text can contain `@location` and multiple `#tags` anywhere, and a human-readable due date either at the beginning or at the end. For example "next wed homework 02 #code #java @home" will be parsed as `{ text: "homework 02", date: "2014-03-20T00:00:00.000Z", tags: [ 'code' , 'java' ], loc: "home" }`. Parsing is not bug-free, will never be unambiguous and will generally suck, unless it won't.

License: MIT
