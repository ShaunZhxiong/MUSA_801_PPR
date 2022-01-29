# Safegraph Literature Review

I searched Google Scholar for relevant research papers that used Safegraph data to analyze parks and related mobility studies. The vast majority of these papers have been published in the past couple of years and used COVID and its impact on mobility trends as the motivation for the research.

I selected five of these papers and summarized the background, how they analyzed the data, and any relevant takeaways for our data analysis with Philadelphia Parks and Recreation.

## Paper #1: Effects of the COVID-19 Pandemic on Park Use in U.S. (Jay et al)

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

## Paper #2:

## Paper #3:

## Paper #4:

## Paper #5:
