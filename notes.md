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
>1. Only based on the size of the building, don't take into consideration amenities, neighborhood, crime,  neighboring parks, etc.
>
>2. Do the schedule in ONE SEASON advanced.
>
>- **<u>What is the successful criteria for this project? Metrics?</u>** 
>
>1. Identify a priority score to evaluate every park and recreation center
>
>2. Figure out what the market is for the park. 
>
>   **(origin neighborhood + demographic composition + how many people + seasonal/hourly characteristic + activity)**
>
>3. Metric for citizens' usage (Know the activity and how people use the services)
>
>4. Metrics for park quality (now, only the "amount of trash collected"; should look at Michael's nighttime business dashboard)
>
>5. Give suggestions on how to staff the whole neighborhood (Community Area - 1 sq mile rectangular area)
>
>    (the interest of users for various places may be different between the plan and reality)
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
>1. Recreation Centers
>2. Parks
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



### 1.2.1 Things need to be done before the meeting

- [x] Read SOP
- [x] Background Reading

- [x] Learn data sources



# Jan.25 Deliverables

<figure>
    <img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/img/Screenshot 2022-01-18 111023.png"
         alt="Project Timeline Example">
    <center><figcaption>Project Timeline Example, Should be submitted by next class</figcaption></center>
</figure>