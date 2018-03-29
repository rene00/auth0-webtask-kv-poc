What?
====

A proof-of-concept simple key value store using the serverless platform [webtask.io](https://webtask.io/).

Why?
====

I was interested in learning more about the serverless platform webtask.io. I was also tasked with hacking together something using webtask.io and felt I should build something that myself or someone else would find useful for future projects.

I've found that a simple key value store is something I really need for hacking on tiny proof of concept projects which require very little state. Hacking together a key value store on webtask.io was perfect for this.

How?
====

First, install the wt command line interface:

```
    # npm install wt-cli -g
```

Initialize wt:

```
    $ wt init $EMAIL
```

Then deploy:

```
    $ bash deploy.sh s3cr3t
```

This will create a webtask using [webtask.js](webtask.js) named `kv-poc`. You will need the authorization secret `s3cr3t` to access the webtask. [deploy.sh](deploy.sh) will output the URL for the webtask.

To POST key values:

```
    $ curl -H "Authorization: Bearer s3cr3t" -X POST $WEBTASK_URL \
      -d "key=Australia" -d "value=AUD"

    $ curl -H "Authorization: Bearer s3cr3t" -X POST $WEBTASK_URL \
      -d "key=Greece" -d "value=EUR"

    $ curl -H "Authorization: Bearer s3cr3t" -X POST $WEBTASK_URL \
      -d "key=China" -d "value=CNY"
```

To GET a value from a specific key:

```
    $ curl -H "Authorization: Bearer s3cr3t" $WEBTASK_URL/Australia
```

To GET all key values:

```
    $ curl -H "Authorization: Bearer s3cr3t" $WEBTASK_URL
```

To DELETE a key value:

```
    $ curl -H "Authorization: Bearer s3cr3t" -X DELETE $WEBTASK_URL/Australia
```

For a simple test suite, I wrote [test.sh](test.sh):

```
    $ bash test.sh
```

Demo
====

[![asciicast](https://asciinema.org/a/6KwlXwP873bTgdL9wIcxbeMIv.png)](https://asciinema.org/a/6KwlXwP873bTgdL9wIcxbeMIv)
