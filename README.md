# SOLAS Target Populator
The target populator takes an XLIFF file with alternative translations and selects the most appropriate one to automatically populate the target. The selection is made using the match quality attributes and the provenance records. It is written in Dart compiled to Javascript and as such can run in any modern web browser (however, Google Chrome or Firefox are recommended).
 
The solution decouples the populating algorithms from CAT tools and makes them logically independent of the human intervention and hence compatible with a roundtrip of specialized agents participating in a single roundtrip upon the standardized exchange/messaging format. It is aware of state of the art metadata containers, is modular and allows for connecting of third party decision making algorithms.
 
SOLAS Target Populator supports open standards; it is ITS 2 aware by design via the XLIFF 1.2. and XLIFF 2.0 Mapping. It is a reference implementation of the XLIFF 2.0 and ITS 2.0 standards.
 
 
**Coded by:**
* [Manuel Honegger](https://github.com/manuelh)
* [Sean Mooney](https://github.com/SeanMooney)
* [Phillip O’Duffy](https://github.com/PhilipUL)

# License notice
This software is licensed under the terms of the GNU LESSER GENERAL PUBLIC LICENSE Version 3, 29 June 2007 For full terms see License.txt or http://www.gnu.org/licenses/lgpl-3.0.txt

# Live demo
*  http://demo.solas.uni.me/wfr/

# References
* http://www.w3.org/International/multilingualweb/lt/wiki/images/2/22/D3.1.2.pdf
* http://www.w3.org/International/multilingualweb/rome/posters/mlwlt_rome2013poster-07.pdf

# Acknowledgement
This research is supported by "FP7-ICT-2011-7 - Language technologies" Project "MultilingualWeb-LT (LT-Web) - Language Technology in the Web" (287815 - CSA).
