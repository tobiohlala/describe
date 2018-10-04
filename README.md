# describe
query word definitions from Oxford Dictionaries API

## Installation

In order to make the script work you first have to register a (free) developer account at [Oxford Dictionaries](https://developer.oxforddictionaries.com/) to obtain an APP ID and APP KEY.

Now within the script replace the APP_ID and APP_KEY placeholders with your own app id and app key preserving the quotation marks, e.g.

change

```bash
app_id="APP_ID"
app_key="APP_KEY"
```

to

```bash
app_id="12345"
app_key="1234567890"
```

where 12345 matches your app id and 1234567890 matches your app key and you're good to go!

Optionally, create a symlink to the script to a location contained in your PATH (like /usr/bin or /usr/local/bin) to make it conveniently executable from everywhere, e.g.

if you placed the script in /opt/scripts before:

```bash
sudo ln -s /opt/scripts/describe.sh /usr/local/bin/describe
```

## Usage

To query for a words definition simply pass it as an argument to the script.

```bash
$ describe tiny

tiny [ˈtʌɪni] is very small
```

Alternatively, you can try deriving the words meaning by its synonyms

```bash
$ describe --synonyms tiny

minute
small-scale
scaled-down
mini
baby
toy
pocket
fun-size
petite
dwarfish
knee-high
miniature
minuscule
microscopic
nanoscopic
infinitesimal
micro
diminutive
pocket-sized
reduced
Lilliputian
```

or its antonyms

```bash
$ describe --antonyms tiny

huge
significant
```
