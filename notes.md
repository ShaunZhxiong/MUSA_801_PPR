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

>a. Background of the client
>
>- who the client is.  
>
>> Philadelphia Parks and Recreation
>
>- What the client do?
>- Who are the other relevant stakeholders besides the PPR ?
>- Their day job.
>- Are they on the technical side with knowledge of the data or are they on the domain expert side?
>
>b. Current business model
>
>- Our task is to allocate the particular resources, SO WHAT IS THIS DONE CURRENTLY?
>- What kind of human resources are currently involved in the current model?
>- If any, what are the frictions or complexities in the above decision making process.
>- **What is the successful criteria for this project? Metrics?** 
>
>c. Current human resources' responsibility
>
>- what their roving programming crews do
>- where they can go
>- when they work
>- what sorts of facilities they can staff. 
>
>d. Facilities and amenities
>
>- What facilities are relevant to this analysis
>- What the hierarchy of amenities is in the parks system
>- how various types of facilities are substitutes for one another
>- think about different kinds of parks as higher or lower ordered goods 
>
>e. Data Side
>
>- Can you describe the data we've been given?
>- What other information are needed
>
>f. Thanks and Communication Frequency
>
>- What is the communication frequency the client prefers?
>- Can we email the questions?
>
>- Thanks again for their help and time!

### 1.2.1 Things need to be done before the meeting

- [x] Read SOP
- [x] Background Reading

- [x] Learn data sources