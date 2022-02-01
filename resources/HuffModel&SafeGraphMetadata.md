# Updates of Huff Model & SafeGraph Research


## [SafeGraph Core Places Metadata (relevant to "core_poi")](https://docs.safegraph.com/docs/core-places)

**Key takeaways:**

* **safegraph_place_id, parent_safegraph_place_id, tracking_opened_since** columns dropped based on [July-2021 Release Notes](https://docs.safegraph.com/changelog/july-2021-release-notes), and **placekey** and **parent_placekey** are referenced moving forward. tracking_opened_sincewas dropped, due to the column being redundant. If a POI has an opened_onvalue, it implies we've been tracking it since that date. If a POI does not have an opened_on` value, it implies we were not able to track the exact date it opened.

* **placekey**
Placekey is a unique and persistent identifier for any physical place in the world that intelligently partitions the ID into meaningful encodings. When both parts of a placekey come together, the final result reads as What@Where. This is a unique way of shedding light on both the descriptive element of a place as well as its geospatial position in the physical world via a single identifier.

  **What: Address Encoding**
The first three characters refer to the Address Encoding, creating a unique identifier for a given address. 

  **What: POI Encoding**
The second set of three characters in the 'What Part' refers to the POI Encoding. If a specific place has a location name (like "Central Park") and is already included in the Placekey reference datasets, these characters will be present. The benefit of the POI Encoding is that it can point to a specific point of interest that may have existed at a certain address at a given point in time.

  **Where: H3 Encoding**
The 'Where Part,' on the other hand, is made up of three unique character sequences, built upon Uber’s open source H3 grid system. This information in the 'Where Part' is based on the centroid of that place. In other words, we take the latitude and longitude of a specific place and then use a conversion function to determine a hexagon in the physical world, representing about 15,000 sq. meters, containing the centroid of that place. The 'Where Part' of the Placekey is, therefore, the full encoding of that hexagon.

* **Point POIs**
Some places are small and not well defined by a geometric shape. We refer to these places as "Point POIs" and intentionally do not offer a polygon nor Patterns data. Places like transit stops, ATMs, kiosks, and electric vehicle charging stations are examples of Point POIs found in our data, and we flag these by setting the geometry_type column = "POINT." Point POIs are a premium portion of the Core places offering, and we are continually adding new types and brands.

## [SafeGraph Geometry Metadata](https://docs.safegraph.com/docs/geometry-data)
**Key takeaways:**
* **Methodology describe POI geometry:**

  **polygon_wkt:** a polygon that represents the shape of the POI, formatted as Well-Known Text (WKT).

  **polygon_class:** a field that describes whether the polygon describes the POI itself (owned_polygon) or if the polygon is shared by more than one POI (shared_polygon).

  The polygon accurately covers the building footprint of interest in both shape and size.
  If a POI is part of a larger structure (such as a strip mall), the polygon should accurately represent the shape and size of the individual store.

  Polygons were only determined to be accurate if they were within 2 meters of the Google Maps imagery as this discrepancy can be accounted for in differing pitches of satellite imagery.

* **enclosed** If true, then this POI is completely enclosed indoors by its parent and is only accessible by entering the parent structure. See Influence on Patterns for more information on visit attribution to enclosed POI.

## [SafeGraph Patterns Metadata](https://docs.safegraph.com/docs/monthly-patterns)
**Key takeaways:**

* [Visit Attribution](https://www.safegraph.com/guides/visit-attribution)

* **raw_visit_counts:**
These are the aggregated raw counts that we see visit the POI from our panel of mobile devices. The duration of the visit must last at least <span style='color:Red'> **4 minutes**</span>  to count as a visit to a given POI.

* **visitor_home_cbg, visitor_home_aggregation, and visitor_country_of_origin** are determined <span style='color:Red'>by analyzing 6 weeks of data during nighttime hours (between 6pm and 7am)</span>. We require a sufficient amount of evidence (total data points and distinct days) to assign a home (common nighttime) geohash-7 for the device, which is then mapped to a census block group, census tract, and country of origin.

* **visitor_home_cbgs:**
These are the home census block groups of the visitors to the POI.
For each census block group, we show the number of associated visitors (as opposed to the number of visits). If visits by home cbg is desired, we recommend taking the visitors from each CBG and multiplying by the average visits/visitor (i.e., raw_visit_counts / raw_visitor_counts) as an approximation.

* **distance_from_home:**
<span style='color:Red'>This is the median distance from home to the POI in meters for the visitors we have identified a home location.</span>
This is calculated by taking the haversine distance (great-circle distance between two points ) between the visitor's home geohash-7 and the location of the POI for each visit. We then take the median of all of the home-POI distance pairs.
If we have fewer than 5 visitors to a POI, the value will be null.
We do not adjust for visits - each visitor is counted equally.

* **popularity_by_hour:**
This is an array of visits seen in each hour of the day over the course of the month.
Local time is used.
If a visitor stays for multiple hours, an item in the array will be incremented for each hour during which the visitor stayed. <span style='color:Red'>This means that if you sum the numbers in the popularity_by_hour array the sum will likely be greater than the amount shown in the raw_visit_counts column (since the raw_visit_counts counts a multiple-hour visit as one visit).</span>