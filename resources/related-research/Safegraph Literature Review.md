# Safegraph Literature Review

I searched Google Scholar for relevant research papers that used Safegraph data to analyze parks and related mobility studies. The vast majority of these papers have been published in the past couple of years and used COVID and its impact on mobility trends as the motivation for the research.

I selected five of these papers and summarized the background, how they analyzed the data, and any relevant takeaways for our data analysis with Philadelphia Parks and Recreation.

## [Paper #1: Effects of the COVID-19 Pandemic on Park Use in U.S. (Jay et al)](2021.04.23.21256007.full.pdf)

Methods: Used monthly mobility data from Safegraph cross-referenxed with a database of park locations source from local agencies. Looked at 44 cities from Jan 2018 to Nov 2020 using interrupted time series regressions. Compared parks to other amenities (eg. gyms, libraries)

Results: Saw park usage decline 14% from Mar-Nov 2020 (COVID). Saw that visits for other park amenities decreased and stayed low for longer compared to parks, and said this might be attributed to race as parks are in areas with greater white populations.

Key takeaways:

* Matching Safegraph parks with official park boundaries from agency

> We considered a SafeGraph park to have matched a TPL park if the SafeGraph park centroid intersected a TPL polygon and the area of the SafeGraph polygon was within 0.5 to 1.5 times the area of the TPL polygon. SafeGraph parks that matched TPL parks (hereafter, the “SafeGraph sample”) were included in the study. This process was designed to omit SafeGraph parks with poorly-drawn polygons or which corresponded to places (e.g., outdoor museums) that local agencies do not consider to be parks. Also, we included only parks that have appeared in the SafeGraph dataset every month since January 2018, omitting a substantial proportion (approximately 1/3) that were added in mid-2020,

* SafeGraph recommends removing outliers but authors reviewed them and left them in

> believed these counts to be plausible. For example, the farthest outliers were visits to Balboa Park in San Diego during the month that the city hosted the ComicCon convention close to the park

* Limitation: Analysis could only focus on temporal trends
  
> SafeGraph device visits are difficult to interpret in terms of real-world visitors, particularly after adjusting for changes in the size of the SafeGraph panel. Therefore, our analyses here focus solely on time trends. In other words, we do not attempt to compare the absolute levels of park use by population served, but only how the time trends differed according to population served.

* Limitation: Could not determine racial identity of park users or how parks were being used

> Because we could not observe directly the racial/ethnic identity of park users, we assigned these characteristics at the park level based on the demographics of the population living within a 0.5 mile walk.

## [Paper #2: Assess validity of SafeGraph data for visitor monitoring in Yellowstone (Liang et al)](Assessing%20the%20validity%20of%20SafeGraph%20data%20for%20visitor%20monitoring%20i.pdf)

Methods: Used SafeGraph data (2018-2020) alongside four other datasets: 3 from Yellowstone national park and the national park service on visitor use and the Census ACS.

> Study retrieved SafeGraph data from Core Places and Patterns datasets. The Core Places dataset involves about 6.1 million POIs and related information, such as POI’s address, category, NAICS CODE, open hours, brands, and unique SafeGraph ID. In addition, each POI has a geographic location (latitude & longitude). The Monthly Patterns dataset contains POIs with unique SafeGraph ID, raw visit counts (monthly), visits by day (daily), visitor home Census Block Groups (CBGs), etc. Currently, SafeGraph Patterns provides visitation data from 2018 January to 2020 November. The two datasets, Core Places and Monthly Patterns, can be linked by the same SafeGraph ID

Results: In many ways the SafeGraph data tracked fairly consistently with Yellowstone's own data.

>  The similarities and differences of
the two data sources regarding visitor demographics and temporal visitation patterns suggests that SafeGraph data can serve as an additional and complementary source of information to traditional visitor use study and count data. 

Key takeaways:

* Used Google Maps to verify place names in Safegraph dataset

> To validate the locations of SafeGraph POIs, Google Maps was employed to assess the location name, latitude & longitude, and address for each POI...


## [Paper #3: Studying spatial and temporal visitation patterns of points of interest using SafeGraph data in Florida (Juhasz et al)](Studying%20Spatial%20and%20Temporal%20Visitation%20Patterns%20of%20Points%20of%20In.pdf)

Methods: Study used Safegraph data to explore visitation patterns in three Florida cities (Miami, Orlando, Jacksonville), focusing on distance between Home and POI. Researchers used OLS Regression models to "identify factors associated with increased/decreased distance between home and a specific POI category."

Results: Study concludes that Safegraph data can be useful to learn more about travel patterns.

Key takeaways:

*  Table on page 5 of PDF shows examples of different POI categories and total counts in dataset

* "Distance from home" is an attribute in the SafeGraph Patterns data, analyzed with Wilcoxon rank sum tests

> As one of its attributes, the SafeGraph monthly Patterns data includes the median distance between visitors’ home locations and a POI. [...] Comparison of median distances for POIs within a city was conducted through a series of unpaired two- sample Wilcoxon rank sum tests. This type of test is a nonparametric test of the null hypothesis that the medians of two populations are equal. For this analysis, we expected that POIs from categories that provide local services for everyday activities (e.g. grocery stores, gas stations, post offices, or schools) would be closer to home locations than POIs used for recreational or travel-related activities, such as amusement parks, hotels or restaurants, which provide distinct services at specific locations and thus justify longer tripsComparison of median distances for POIs within a city was conducted through a series of unpaired two- sample Wilcoxon rank sum tests. This type of test is a nonparametric test of the null hypothesis that the medians of two populations are equal. For this analysis, we expected that POIs from categories that provide local services for everyday activities (e.g. grocery stores, gas stations, post offices, or schools) would be closer to home locations than POIs used for recreational or travel-related activities, such as amusement parks, hotels or restaurants, which provide distinct services at specific locations and thus justify longer trips


* Pg 17 shows output from an OLS Regression of what other attributes can be used to predict a POI category, including POI NN distance, job density, highway distance, etc.

## [Paper #4: Urban park use during the COVID Pandemic: Are socially vulnerable communities disproportionately impacted? (Larson et al)](frsc-03-710243.pdf)

Methods: Used a survey of residents alongside SafeGraph data 

Results: "Data from both methods revealed urban park use declined during the pandemic; 56% of survey respondents said they stopped or reduced park use, and geo-tracked park visits dropped by 15%. Park users also became more homogenous, with visits increasing the most for past park visitors and declining the most in socially vulnerable communities and among individuals who were BIPOC or lower-income"

Key takeaways:

* Did cleanup on the Parks POI

> Parks were first identified within the larger SafeGraph data category of “Nature Parks or Similar Places.” We then filtered data to focus only on POIs with “park” in their name, with the goal of eliminating POIs, such as museums, that did not constitute outdoor public spaces and were likely to be closed during the pandemic.

* Used Social Vulnerability Index from CDC to characterize socio demographic attributes

>  Use of SVI enabled us to capture different components of social vulnerability simultaneously, thereby reducing the risk of multi-collinearity in regression models. We used three themes, or dimensions, of SVI that roughly aligned with demographic variables in our self-reported survey (Study 1)

* Used ParkServe dataset for info about park size and park access

> we also integrated data regarding the number of parks within a census tract and the park ratio within the tract (i.e., the percentage of land within a census tract designated as parks). The data used to calculate park ratio was derived from ParkServe (The Trust for Public Land, 2020b), a geodatabase providing information about park size and park access to the public

## [Paper #5: Using mobile device data to track the effects of COVID-19 pandemic on spatiotemporal patterns of national park visitation (Kupfer et al)](sustainability-13-09366.pdf)


Methods: "In this study, we mapped and analyzed the spatiotemporal patterns of visitation for six national parks in the western U.S., taking advantage of large mobility records sampled from mobile devices and released by SafeGraph as part of their Social Distancing Metric dataset"

Results: "our results confirmed that mobility records from digital devices can effectively capture park visitation patterns but with much finer spatiotemporal granularity. In general, triggers of visitation changes corresponded well with the parks’ management responses to COVID-19, with all six parks showing dramatic decreases in the number of visitors (compared to 2019) beginning in March 2020 and continuing through April and May"

Key takeaways:

* Used SafeGraph's Social Distancing Metric for analysis

> Social Distancing Metric data, which are based on an aggregated, anonymized, privacy-safe summary of foot traffic to 6 million POIs in North America, including national parks. These data were available at a daily timestep

* Limitation: SafeGraph does not include interantional travelers, suggested using geotagged tweets as add'l data source

>  the SafeGraph data used in this study only cover flows within the U.S. and thus ignore international travelers, who can make up a significant percentage of visitors at some parks during certain seasons [...] To bridge this gap, social media data, such as geotagged tweets, that have been proven to be effective in tracking global human movement [35–37] can be incorporated in future studies.