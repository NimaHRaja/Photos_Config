# Photos_Config

A Project to find all the photos (~100,000) we've taken in the past ~20 years in order to remove the duplicates and analyse their metadata. I'm using [exifr](https://cran.r-project.org/web/packages/exifr/index.html).

- **INIT.R:**  
Loads packages, sources functions, and create directories.  
- **Get\_list\_of\_files.R:**  
Function 
Get\_list\_of\_files(folder\_name, num\_files\_in\_each\_bucket, output\_file).  
Finds all files in a directory (*folder\_name*). Assigns them to buckets of size *num\_files\_in\_each\_bucket* (to be analysed in bunches later). Adds a status column to the list to identify the photos that have already been analysed. Writes the list into *output\_file*.  
- **Get\_meta\_for\_a\_bucket.R:**  
Function Get\_meta\_for\_a\_bucket(i, list\_of\_files).  
Gets *list\_of\_files* and bucket number (*i*). Finds all the files in that buckets which hasn't been analysed. Extracts the metadata and melts (flatten) them. Returns the metadata and a list of the analysed files.  
- **exploratory.R:**  
Exploring exifr and my data.  
- **find\_all\_photos\_of\_a\_camera.R:** (temporary).