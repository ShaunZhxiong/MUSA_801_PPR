# <span style='color:Red'>0. Project Understanding</span>



## 0.1 Overview

Our understanding is that the client and their stakeholders are interested in improving their ability to pro-actively deploy limited human resources for programming in the parks.



## 0.2 SOP

The current “business as usual” approach involves allocation based on programming service data associated with **amenities**, but new deployment strategies will involve the placement of “**program crews**” to areas of need. 

The goal of this project is to create <u>a proof-of-concept data system</u> that uses new mobility data from Safegraph to <u>understand parks and recreation usage</u> in a way that can assist programmers in targeting human resources to parks or service areas where there <u>is **estimated need**</u> unseen by current measurements. 



## 0.3 Keys

**One of the keys to this effort to place resources is creating an enhanced understanding of park “markets” and their attractiveness.** 

We can try to create several measures of this.

 Safegraph data can tell us (relatively speaking) how much traffic is going to these parks and where it has been coming from. We also know what the origins of these visitors are (census block groups). 

We can compare these to expected visitorship by comparing these origin and frequency data to “gravity models” that predict visitorship probabilities based on location and “attractiveness” of consumer locations. 

This difference may allow us to account for *the appeal of park amenities or programming*.



## 0.4 Deliverable

MUSA students aim to create <u>analytics</u> and <u>a dashboard</u> that can support PPR’s programming decision-making. 

This project will also contain <u>an exploratory analysis</u> designed to assess the strengths, weaknesses and limitations of using Safegraph data for this particular use.



## 0.5 Project Management

- one person to take the lead on the dashboard (a person who is taking or has taken the javascript course)
- one person should be designated to lead on the markdown
- a third person should be in charge of domain research and project management
- a fourth should lead research on ***gravity model***

<figure>
    <img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/img/Screenshot 2022-01-18 110611.png"
         alt="Project LifeCircle">
    <center><figcaption>Project LifeCircle</figcaption></center>
</figure>

## 0.6 Data Sources

Safegraph: Repository

> **Information We Collect and How We Collect It** 
>
> We obtain a variety of information (collectively the “Information”), the data categories of which we have listed below, from trusted third-party data partners such as mobile application developers and companies that aggregate information from those developers' mobile apps.

PPR: https://www.phila.gov/services/culture-recreation/find-a-playground-or-recreation-center/

Public: OpenDataPhilly



## 0.7 Models

### The Huff Model

The Huff model, which is essentially a gravity-based spatial interaction model, proposes that there are two major factors affecting the number of potential customers of a store. 

**The first is the merchandise offerings**

> namely, the ability of the store to fulfill the customers’ needs (Huff, 1963). This is also called the attractiveness of the store. If a store has a large number of items, it is able to attract more customers even from distant regions.

**The second factor is the travel time or travel distance to the store.** 

>As the cost of travel to a store increases, the willingness to visit the store could be significantly reduced (Huff, 1963).

### A time-aware dynamic Huff model (T-Huff)

### Advanced time-aware dynamic Huff (A-Huff)



# <span style='color:Red'>1. Kick-off Meeting</span>



## 1.1 The agenda at that day

Course introduction; 

Agile project management; 

Team meet; 

**Client meetings** (An hour)



## 1.2 Structure of the client meeting

- Thank them for their willingness to partner with us.
- Self-introduction

- Ask questions ( Especially their decision-making needs)

>#### a. Background of the client
>
>- **<u>Who the client is.</u>**  
>
>1. Philadelphia Parks and Recreation
>
>- **<u>Are they on the technical side with knowledge of the data or are they on the domain expert side?</u>**
>
>1. `Bill Salvatore` - Dir of Strategic Development, PPR (training, recruitment, partnership work, etc)
>
>2. `Andy Viren` - Lead evaluation on the recreation side of parks and rec, 700 employees, works on the programming side
>
>- **<u>What does the PPR do?</u>**
>
>1. 700 Employees
>2. 150-160 recreation centers
>
>- <u>Who are the other relevant stakeholders besides the PPR ?</u>
>- <u>Their day job.</u>
>
>
>
>#### b. Current business model
>
>- **<u>Our task is to allocate the particular resources, SO HOW IS THIS DONE CURRENTLY? If any, what are the frictions or complexities in the above decision making process.</u>**
>
>1. Only based on the size of the amenity, don't take into consideration amenities, neighborhood, crime,  neighboring parks, etc.
>
>2. Do the schedule in ONE SEASON advanced.
>
>- **<u>What is the successful criteria for this project? Metrics?</u>** 
>
>1. Figure out what the market is for the park. 
>
>
>  **(origin neighborhood + demographic composition + how many people + seasonal/hourly characteristic + activity)**
>
>2. Metric for citizens' usage (Know the activity and how people use the services)
>3. Prediction about usage
>
>3. Metrics for park quality (now, only the "amount of trash collected"; should look at Michael's nighttime business dashboard)
>
>4. Give suggestions on how to staff the whole neighborhood (Community Area - 1 sq mile rectangular area)
>
>   (the interest of users for various places may be different between the plan and reality)
>
>
>
>### c. Current human resources' responsibility
>
>- **<u>What kind of human resources are currently involved in the current model?</u>**
>
>1. 700 employees working on the programming side. These programmers will provide activities toward citizens.
>
>- **<u>What do their roving programming crews do?</u>**
>
>1. Buckets of events: athletic, cultural, educational, environmental (7 types of activities, 80-90kinds)
>2. Wait for the list
>
>- **<u>Where can they go?</u>** 
>
>1. 150-160 recreation centers and parks
>
>- **<u>When do they work?</u>** 
>
>1. Wait for the Scheduled list of 2021.
>
>
>
>### d. Facilities and amenities
>
>- **<u>What facilities are relevant to this analysis?</u>**
>
>1. Recreation Centers & Parks
>3. Community Service Area
>
>- <u>What the hierarchy of amenities is in the parks system?</u>
>- <u>How various types of facilities are substitutes for one another?</u>
>- <u>What the hierarchy of parks is in the system? Which kind of parks have higher or lower priority?</u>
>
>
>
>### e. Data Side
>
>- <u>**What is the time window that we should focus on this proof-concept project?**</u>
>
>1. 2021
>
>- **<u>the client is in the process (1/6/2022) of securing access to the backend data associated with PPR’s activity finder,</u>** 
>
><span style="color:red">Do you know when can we have the access to the backend data?</span>
>
>- **<u>SafeGraph</u>**
>
>not necessary to look outside service areas;
>
>- **<u>How can we disentangle adults from adults+childrens?</u>**
>
>1. No data from kids under 13. But we can use origin location information (block group) to estimate



# Jan.25 Deliverables

<figure>
    <img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/img/Screenshot 2022-01-18 111023.png"
         alt="Project Timeline Example">
    <center><figcaption>Project Timeline Example, Should be submitted by next class</figcaption></center>
</figure>


Email memo

1. **Focused service ares**: This spring’s pilot is focused on the service areas in Districts 7,8,9.
2. **Location data**: pprBuildingStructures - Buildings; pprProperty - Land
3. **Programs**:  program2021 doesn't have exact date. All *AttendanceWeekDate* records use the Monday date of each week. Program schedule data is needed for this.

# Feb 1st

2. in the sop whether we should predict the absolute number of visitors or the relative number with the temperal trend (suppose we should use OLS here)
3. use other regression models (e.g. OLS)to understand the relationship between  factors and the number of visits
4. whether we should include other surrounding features like temperature into OLS model
5. we use the prediction of the number of the visitors in the 1 OLS model to run the huff model to calculate the market area

Answer: EDA will be the main content of this project, to help ppr better understand their current situations. And market area will be calculated using 2021's data. As for the prediction, that might be difficult to do the prediction. The prediction is not necessary. Another difficulty of this project is to create huff model package in R.

# Feb 6th

1. What can we do use the OpenDataPhilly data? (Trails, Picnic sites, Swimming pools etc)
2. Does district 9 include navy yard or not
3. https://docs.safegraph.com/docs/monthly-patterns

4. how to reasonably construct the attractiveness metrics for every property? service area?

   (should include data of OpenDataPhilly, # of programs)(should not include visitor number)

   https://pro.arcgis.com/zh-cn/pro-app/2.7/tool-reference/business-analyst/understanding-huff-model.htm#:~:text=A%20site%20has,a%20consumer%20survey.

5. how to reasonably construct the surrounding effect in the **Socially Aware Huff Model**? Weighted?
6. Huff model validation: compare the safegraph origin data with huff model market area. 

# Feb 13rd

Wait for PPR

- [ ] PPR will give 'facilityID' at the end of the Feburary

- [x] The district 9 doesn't include the smith area
- [ ] property exceptions

- [x] Use pprProperty and ServiceArea to spatial join to get the service area information attached to the property



Questions

1. how to reasonably construct the surrounding effect in the **Socially Aware Huff Model**? Weighted?
2. Huff model validation: compare the safegraph origin data with huff model market area.



Will do

1. - [x] Combine hui's work into the whole markdown
2. - [x] Tidy up next class presentation
3. - [x] Service Area Level Analysis
4. Decide how to properly modify and use safegraph data into our model
4. Model Building

# Feb 28th

Limitation for specific huff model practice

#### Limitations

One of the key limitations in the app is a lack of specificity in models. Buffer sizes and store square footage areas are abstracted out of the app for simplicity, but this results in a lack of quantitative feedback. The Huff Model also uses Euclidean distance rather than drive time which ignores the road network and alternative means of transit like subway or foot traffic. The Huff Model also uses census tract centroids, which can lead to counter intuitive results in large census tracts. The sales forecasting aspect of the Huff Model tab makes large assumptions on the amount of many spent by each household on goods, and is impacted by edge effects of both stores and customers that may fall outside of the Toronto CMA. The drive time buffers also fully rely on the road network (rather than incorporating transit) and are limited by an upper bounded travel time of 60 minutes from the Mapbox Isochrone API.

#### Travel Time