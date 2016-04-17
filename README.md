# Budgie

## What is it?
A simple Rails app to keep track of your finances.

Also, thanks to its avian namesake, an exercise into how offensively brightly 
coloured a UI can be before it becomes unusable.

Very much a work in progress.

## Why?
I used to have all this in a spreadsheet, but it was starting to get a bit
unwieldy and it irritated me that I had to manually format and tag the new
entries every time I added them.

## Current functionality
Fairly limited. You can:
-	import transactions from a Santander account
	-	adding a different bank is just a case of implementing a parser and
		changing the hardcoded method in `UploadController#upload_file`
-	view most recent entries
-	add tags to existing entries to group them together
-	view the recent entries for a tag

## Roadmap
-	**0.1**: Very basic functionality and layout
-	**0.2**: Pluggable import rules for automated tagging and editing 
	descriptions
-	**0.3**: Search, filter, pagination
-	**0.4**: Graphs for tags and monthly breakdowns

## Known issues
-	Links to multi-word tags are broken. This should be an easy fix, but I'm 
	not totally sure how %20s will affect things. Should be fixed in 0.2.
-	Unhandled exception when trying to add a duplicate tag to an entry. Just 
	don't do that. Should be fixed in 0.2.
-	Currently no way to remove a tag from an entry from the UI. 
	This is because I'm not totally sure how I want this to work. It'll be 
	added after	rules are in place: if you run a rule over some entries, then 
	manually untag an entry, you (probably) don't want that entry to be 
	retagged if you	run the rule over those entries again.

## License
Budgie is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Acknowledgements
Budgie makes use of some excellent third-party software.
Most of these are Ruby gems and are not included in this repo.
They can be found in the Gemfile, and installed using Bundler.

Other software packaged with Budgie:
-	[Materialize](http://materializecss.com/), a CSS Framework based on 
	Material Design, available under the MIT License
-	[Asap](https://www.google.com/fonts/specimen/Asap), a contemporary 
	sans-serif family with subtle rounded corners, available under the SIL 
	Open Font License
