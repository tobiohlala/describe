# describe
query word definitions from Oxford Dictionaries API

## Description

a small shell script for quickly looking up a words meaning, synonyms or antonyms from the console.

## Installation

In order to make the script work you first have to register a (free) developer account at [Oxford Dictionaries](https://developer.oxforddictionaries.com/) to obtain an APP ID and APP KEY.

Now within the script replace the _APP_ID_ and _APP_KEY_ placeholders with your own app id and app key preserving the quotation marks, e.g.

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

where _12345_ matches your app id and _1234567890_ your app key.

Optionally, create a symlink to the script to a location contained in your PATH like _/usr/bin_ or _/usr/local/bin_ to make it conveniently executable from everywhere, e.g.

if you placed the script in /opt/scripts before:

```bash
sudo ln -s /opt/scripts/describe.sh /usr/local/bin/describe
```

## Usage

To query for a words definition simply pass it as an argument to the script

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

You can also obtain definitions for more than one word at once

```bash
$ describe tiny kitten

tiny [ˈtʌɪni] is very small
kitten [ˈkɪt(ə)n] is a young cat
```

## Requirements

`curl`
`jq`
`sed`
