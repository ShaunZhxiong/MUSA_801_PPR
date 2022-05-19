# Allocating Programming Resources Using A Mobility-Based Information System

Team: Shaun Zheng, Lan Xiao, Jeff Stern, Hui Tian

[Markdown](Submission/phillyPark.html)

[Management Plan](https://docs.google.com/spreadsheets/d/1FgCO618cihtmxwfZZv87nweTDBh2rQip/edit?usp=sharing&ouid=107802804023877926203&rtpof=true&sd=true) (Keep Updating till the end of the project)

# Additional repositories
* Philadelphia Parks and Rec Data Dashboard: https://github.com/jeffstern/ppr-dashboard ([live link](https://ppr-dashboard-xfw9y.ondigitalocean.app/))
* PPR Interactive Huff Model Visualization: https://github.com/jeffstern/ppr_park_huffmodel ([live link](https://ppr-dashboard-xfw9y.ondigitalocean.app/huff-example)
* Huff Model NPM package: https://github.com/jeffstern/huffmodel (https://npmjs.com/package/huffmodel)

# Abstract
Currently, the Philadelphia Department of Parks & Recreation (PPR) owns 524 facilities across the city and host thousands of programs and events every year that contribute to the wellness of people.From top down, the hierarchy of their service system is: Districts -> Service Areas -> Facilities -> Programs and Permits.

In the past, staffing in PPR estimates the demand for its programming based on program data (like registered attendance) and other proxy measures about park visits (e.g. total trash collected). However, these measures may not be fully reliable and accurate. How can PPR make smarter decisions about allocating programs in the parks and recreation facilities? We will refer to a data-driven approach to help them find the dynamic relationship between planned activities and visitors.

Only recently, with the dynamic data collected by SafeGraph and other cell phone data carriers, it is now possible to analyze large data sets of cell phone location activity, including where people are traveling and how long they stay. SafeGraph’s mobile device panels get anonymous data about users’ foot traffic from numerous smartphone apps and could be considered as a selected sample to understand people’s travel pattern. These data are further aggregated to answer a series questions like how often do people visit a location or how long do they stay in a location.

By incorporating this novel dataset, we can help the PPR to analyze if their programming meet citizens’ demands and to better assign their program resources with SafeGraph’s Pattern data. With understanding of the imbalance between demand and supply, we can adjust the quantity of programs and events, like increasing number in low-supplied facilities and reducing number in over-supplied facilities. The prediction outcome of market area can be used to suggest PPR’s future programming strategies

In order to know how many additional programs are needed and how the adjustment will affect other facilities, we will refer to the Huff Model. In spatial analysis, the Huff model is a widely used tool for predicting the probability of a consumer visiting a site, as a function of the distance from the origin to the destination, its attractiveness, and the relative attractiveness of alternatives. With the predicted probability of a consumer visiting a facility, we could interpret and normalize it to reflect the quantity of visitors from a census block group to a certain facility. In that case, we can help the PPR better understand the use of their facilities and provide recommendations on how to allocate programming resources better within Program Service Areas and the types of programs they should offer to meet diverse user demands.

The eventually user interface will be the Dashboard. That will convey the PPR related information, useful exploratory analysis, and the outcome of market area from the huff model in the end. This dashboard will provide data visualization of their existing programs, permits and estimated number of visits in each facility, service area, and district, as well as display proposed activities to visitors in the future.

# Images

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211111701.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509210934833.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211203820.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211257829.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211635047.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211721926.png" width=60%>

<img src="https://raw.githubusercontent.com/ShaunZhxiong/ImgGarage/main/ShaunZhxiong/ImgGarage/img/image-20220509211834283.png" width=60%>
