# IMAP + Webhook Spike
Spike of posting emails from an imap server to a webservice. 


## Running It
Edit config.json to include your actual credentials

From the project dir:

```bash
$ npm install 
```

then

```bash
$ coffee getit
```
## Tests
Tests can be ran by typing

```bash
mocha -t 10000
```

The -t option is needed because the initial hookup to gmail seems to
take awhile so we give the test 10 seconds to do its thing. Test assumes
that config.json points to the url http://localhost:3001/example.

