There is a [tool](http://www.ofb.net/~egnor/xml2/) to convert XML files to 
intermediate format that allows editing and data extraction to be performed 
with simple (not XML-aware) tools, such as regular expressions-based `grep` 
or `sed`. It does not solve the general task of transforming XML files, but 
still allows text handling tools to go farther than in case of 
[direct attempt to use them on XML](http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags).

But xml2 is for XML, and somebody may want the similar tool for JSON.

Here there are two main tools plus several supplementrary ones:

* json2 - converts JSON to intermediate text-editable format;
* 2json - converts that intermediate format back to JSON;
* json_compare - compares two JSON files to equality and reports the found difference, if any;
* random_json - generates random "tricky" JSON (with confusing strings, empty objects, etc.);
* json_keys - gathers keys used for in objects in the JSON
* test.sh - endless "fuzz test" of `json2 | 2json` using random_json and json_compare.
* json2dir and dir2json - "unpacks" JSON to files and directories and back;

Tested with Python 2.6, 2.7 and 3.2.

Example
---

JSON file

```
{ "mist": "qua\nlity\n",
  "fist": [],
   "gist": [5,6,"7"],
   "...": null,
   "test":[[[false]]],
   "var":{"lib":{"dpkg":"status"}}
}
```

Output of json2:

```
/...=null
/gist/0=5
/gist/1=6
/gist/2="7
/var/lib/dpkg=status
/fist=[]
/test/0/0/0=false
/mist="qua
/mist="lity
/mist="
```

Rules of the format
---

* Each line must contain "=". The first "=" on each line is always put by 
json2, 
subsequent "="s may happen in the data extracted from JSON;
* The left part of the line before "=" is "address", the right part after the 
first 
"=" is "value".
* Value can be string, number, null, float, boolean, empty list or empty object.
* Any value that can't be interpreted as non-string is interpreted as string. 
Using `"` character just after `=` forces it to be a string. By default `json2` 
uses unescaped strings where possible: `if there_may_be_problems then 
prefix_with_" else use_the_string_as_is`. `JSON2_ALWAYS_MARK_STRINGS=true` 
overrides this and makes json2 put `"` before any string values.
* Only empty lists and objects must be explicitly mentioned as values. Non-empty 
lists and objects still can have "stubs" like `=[]` or `={}` at the respective 
address. `JSON2_ALWAYS_STUBS=true` forces stubs for all lists and objects.
* Address is a list of keys separated by "/". The first empty key (before the 
first `/`) is ignored, subsequent empty keys are assumed as empty keys of 
objects (for example, `{"":{"":""}}` -> `//="`). Each address entry "descends" 
from the top-level list of object into it's children (creating intermediate 
lists or objects if necessary).
* Numeric keys are used as indexes (starting from 0) of the lists in JSON. 
Non-numeric keys are keys for object fileds.
* All keys of object fileds are mangled to preserve assumptions about usage of 
`/`, `=`, `"` and `\n`  characters and to avoid mistakingly interepreting them
as indexes for lists instead of keys for objects. Mangling rules are not 
standard: apart from usual \n, \r and \t, `/ " = \` becomes `\| \' \_ \!`. 
Additionally the entire key may be prefixed with `\` if it looks like a number.
* Multiline string values are handled as repeated lines (with the same address).
* Apart from multi-line string values, lines in `2json` input file may be reordered arbitrarily.

Limitations
---

* Order of fields in objects is not preserved;
* 2json is slow. It navigates into the hierarchy of objects and lists from the 
root for every line;
* All tools load the entire input file in memory as a tree, 
not "streamed".
* Is may be poor option if you need to handle recursive JSON files.

See also
---

* [gron](https://github.com/tomnomnom/gron)
