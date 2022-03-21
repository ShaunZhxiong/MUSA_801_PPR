# MUSA_801_PPR
This is the repository for the practicum project of MUSA.

[Notes for the class](notes.md) (Keep Updating till the end of the project)

[Management Plan](https://docs.google.com/spreadsheets/d/1FgCO618cihtmxwfZZv87nweTDBh2rQip/edit?usp=sharing&ouid=107802804023877926203&rtpof=true&sd=true) (Keep Updating till the end of the project)

## Project Path
#### [Week0](Process/Week0)

Read the SOP and project materials

Fist Kick-off meeting with client - [Interview Notes](Process/Week0/interviewnotes_0118.md)

Download all available [datasets](data/open-data-philly/00-sources-and-metadata.md) into [R](Process/Week0/PPPR.html)

#### [Week1](Process/Week1)

[Data Relationship](/Process/Week1/dataRelationship/note_Database_Relationship.md)

[SOP- Metrics](Process/Week1/sopMetrics/sucessfulMetrics.md)

[App Sketches](Process/Week1/appSketches/README.md)

[Safegraph & gravity model Reference Summary](Process/Week1/dataAndModelReference/ModelReference.md) 

#### Week2
PPR SafeGraph Data Wragnling and [Mapping](demo/) (First Version)

[R Huff package Review](https://raw.githubusercontent.com/alexsingleton/Huff-Tools/master/huff-tools.r)

[Huff Model literature review & Safegraph Metadata](Process/Week1/dataAndModelReference/Huff Model Reference.docx)

[Safegraph literature review](resources/related-research/Safegraph Literature Review.md)

#### Week3

[Current Facility & Programming Analysis](Process\Week3\PPPR-Program.html) 

[Unnest Safegraph Data & Visualization](PPPR.html)

[Census Data Analysis based on PPR Service Areas](https://ppr-dashboard-xfw9y.ondigitalocean.app/)

[Questions](notes.md)

#### Week4

The most popular facility Analysis (by # of visits and by dwelling time)

The most strange facility Analysis

Categorized Properties into several types

Origin Flow Map and Departure Flow Map

[Further Development on Dashboard and Census Analysis](https://ppr-dashboard-xfw9y.ondigitalocean.app/)

Further Analysis of Programs organized by PPR

[Questions](notes.md)

#### Week5 - Midterm

[PPT](https://docs.google.com/presentation/d/1bBRV1WXwandpqySlg-J_grMCS6epUF8gNEZjnMhIpu8/edit) 

[Markdown](PPPR_Midterm.html)

[Feedback](midtermfeedback.md)

#### Week6

Program further division

Python scripts of Huff model

#### Week7 & 8 & 9 （Spring Break）

Huff Model Understanding

> 1. Essentially, it is OLS model like this!
>
> <img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/img/image-20220312183108213.png" width=20%>
>
> The below is just another form of this OLS model![image-20220312183224405](https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/img/image-20220312183224405.png)
>
> 2. The alpha, beta, theta are just the coefficients of this OLS model. (because it do the log transformation in the code)
>
> 3. The misunderstanding (maybe just for me) of Socially Aware Huff Model is that the "Socially Aware" just means it uses the "Flicker Photo Indicator"(which is public on the Internet and socially aware) as the attractiveness metric. That is.

The limitation of Current Huff Model

> 1. The original model didn't take temporal into account, therefore we need to change the model. Just like we did in the simple OLS model.
> 2. The original model just takes one attractiveness into account, but there should be more.

For our project

> 1. The assumption of the huff model, is that the "Attractiveness - here is the number of program " always have positive or negative relationships with "Y - # of Visits". However, through the K-means clustering, we find out some outliers, which demands exceed supplies or vice versa. How to give specific suggestions like in which month the programs should be deleted, or what programs should be deleted.
> 2. We can calculate the market area using huff model based on the assumption that (Attractiveness always have positive or negative relationships with # of visits). And then compare the huff model market area with service area to see the conflict zones.
> 3. If the assumptions are correct then the outliers in the K-Means should have the biggest conflict zones. So we can according to the difference to draw the specific suggestions.
> 4. Because our data is just for 2021, and we include the temporal term"Month", so we can not test the model. (if we do not include spatial fixed effect, then we can do the validation)

#### Week10

Distance Matrix

Options to build Attractiveness Matrix