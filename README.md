# CharacterVariants

## iOS Techniques Demonstrated
- build multiple variants of an app from a common code base
- UISplitViewController for a master-detail application
	* classes SplitViewController, ListViewController, DetailViewController
- CoreData used to cache characters and images once downloaded
- AutoLayout used throughout the app
- CALayers, custom CoreGraphics drawing
- asynchronous, multi-threaded design using NSOperation / Operation / OperationQueue / Dispatch
- reactive programming model using View Models that notify the observers of changes

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
# Simpsons Character Viewer

**com.sample.simpsonsviewer**

**[DuckDuckGo Simpsons Characters API](http://api.duckduckgo.com/?q=simpsons+characters&format=json)**
--------------------
# The Wire Character Viewer

**com.sample.wireviewer**

**[DuckDuckGo The Wire Characters API](http://api.duckduckgo.com/?q=the+wire+characters&format=json)**
--------------------

# Architecture
- all variants use CharacterVariantsCommon framework with required classes
- app variants customized in Info.plist > CharacterVariantsConfiguration
- logoImage.png used for LaunchScreen
  - logo inside app (LogoHeaderView) downloaded from CharacterVariantsConfiguration.URL.logoImage and cached locally
  
**CharacterVariantsCommon**
**SimpsonsCharacters**
**WireCharacters**

## CharacterVariantsConfiguration
```
<key>CharacterVariantsConfiguration</key>
	<dict>
		<key>AnimateLoadingImage</key><string>1</string>
		<key>ColorSRGB255</key><dict>
			 <key>detailBackgroundDark</key><dict>
				<key>blue</key><string>160</string>
				<key>green</key><string>100</string>
				<key>red</key><string>0</string>
			</dict>
			<key>detailBackgroundLight</key><dict>
				<key>blue</key><string>210</string>
				<key>green</key><string>175</string>
				<key>red</key><string>70</string>
			</dict>
			<key>font</key><dict>
				<key>blue</key><string>160</string>
				<key>green</key><string>100</string>
				<key>red</key><string>0</string>
			</dict>
			<key>listBackgroundDark</key><dict>
				<key>blue</key><string>255</string>
				<key>green</key><string>255</string>
				<key>red</key><string>255</string>
			</dict>
			<key>listBackgroundLight</key><dict>
				<key>blue</key><string>255</string>
				<key>green</key><string>255</string>
				<key>red</key><string>255</string>
			</dict>
		</dict>
		<key>FileSystem</key><dict>
			<key>databaseName</key><string>CoreDataDatabase</string>
			<key>logoImageName</key><string>logoSimpsons</string>
			<key>managedObjectModelName</key><string>CoreDataModel</string>
		</dict>
		<key>URL</key><dict>
			<key>api</key><string>http://api.duckduckgo.com/?q=simpsons+characters&amp;format=json</string>
			<key>loadingImage</key><string>https://cdn.imgbin.com/16/15/6/imgbin-the-simpsons-tapped-out-homer-simpson-donuts-coffee-and-doughnuts-bakery-homero-photo-of-donut-gwSrt1fXg1Cu5WufDnamzkMj0.jpg</string>
			<key>logoImage</key><string>https://assets.foxdcg.com/dpp-uploaded/images/the-simpsons/the-simpsons_31/logo-tab_s31.png?fit=inside%7C*:120</string>
		</dict>
	</dict>
```


# Model-View-ViewModel-Coordinator

### Model
**Interfaces**
- CoreDataInterface
- NetworkInterface
- FileSystemInterface

**Plist / XML**
- Configuration

**CoreData** (CoreDataNSManagedObjects/, CoreDataExtensions.swift)
- CVCharacter
- extensions to insert and update from JSON models, delete

**JSON** (Model.swift)
- CharacterAPIResponse
- Character
- conform to Decodable protocol with CodingKeys corresponding to JSON keys

### View (View.swift)
- ButtonContainerView
- CharacterCell
- GradientLayer
- LogoHeaderView

### ViewModel (ViewModel.swift)
- Character
  * store data for Character view content (DetailViewController's view)
  * calls didSet handlers to update DetailViewController's imageView once character image is downloaded and cached 
  
### Coordinator
- ViewModelCoordinator
  * coordinates core data actions
  * downloads data in background using networkQueue
  * searches for Characters matching text in background using searchQueue
  * data source, delegate for StackOverflowUserTableView
  * populates VMs from CoreData models
  * notifies viewcontroller when VMs changed (downloaded characters, delete characters, search results)
- UserInputCoordinator
  * handles user input by coordinating asynchronous commands sent to ViewModelCoordinator
  
### Controller
- SplitViewController
  * sets up its view controllers
  * handles user input via UserInputCoordinator
- ListViewController
  * sets up its views
- DetailViewController
  * dismisses itself by conforming to Dismissable protocol
