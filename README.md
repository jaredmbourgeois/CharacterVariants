# CharacterVariants

## App Requirements
Write a sample app that fetches and displays data from a RESTful Web API. 

The app should be comprised of two parts, a **list** and a **detail** 
- **phones** > the list and detail should be separate screens
- **tablets** > list and detail should appear on the same screen

### List View
- data should be displayed as a text only, vertically scrollable list of character names
- search functionality that filters the character list according to characters whose titles or descriptions contain the query text

### Detail View
- character’s **image**, **title**, and **description**
- **image** > "Icon" field of the API JSON response (placeholder for blank or missing URLs)

### Variants
- each variant should have a different name, package-name, and url that it pulls data from.

--------------------
### Simpsons Character Viewer

**com.sample.simpsonsviewer**

**[DuckDuckGo Simpsons Characters API](http://api.duckduckgo.com/?q=simpsons+characters&format=json)**

--------------------
### The Wire Character Viewer

**com.sample.wireviewer**

**[DuckDuckGo The Wire Characters API](http://api.duckduckgo.com/?q=the+wire+characters&format=json)**
