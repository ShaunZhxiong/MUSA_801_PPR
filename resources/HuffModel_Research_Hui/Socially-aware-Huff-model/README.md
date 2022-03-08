# Socially-aware-Huff-model

### Data and Code
- `./Data/` contains the data retrieved using [Flickr API](https://www.flickr.com/services/api/) in Acadia and Yosemite National Parks from Jan 1, 2010 to Dec 31, 2019. The example query used to access the data in Acadia National Park: 
  
  ```
  flickr.photos.search(min_taken_date = '2010-01-01', max_taken_date = '2019-12-31', accuracy = '11', bbox = '-68.5, 44.0, -68.0, 44.5', per_page = '100', extras='date_taken, tags, geo, views', page=1)['photos']['photo']
  ```
- `./Code/` contains the source code:
  - Step 1: `Trip Construction.ipynb`
    - A workflow to construct trip sequences, flow matrix and probability matrix from the geotagged photos. You can change the parameters in the model and generate your own output under the Binder environment.
  - Step 2: `SA-Huff_model_Acadia.ipynb` and `SA-Huff_model_Yosemite.ipynb` 
    - A workflow to calibrate the proposed socially-aware Huff model with the probability matrices generated from `Trip Construction.ipynb` for the two national parks. 
    - **Note**: The SA-Huff model files read data provided in `./Data/acadia_pmatrix/` and `./Data/yosemite_pmatrix/` by default. If you would like to generate your own output from `Trip Construction.ipynb` and feed into the SA-Huff model files in Binder, you can follow the instruction at the top of the files to switch the input.



# Notes

'position' is the data frame with the attraction locations









### Binder

A Binder-ready repository, which allows you to open the Jupyter Notebook and reproduce the code in an executable environment, can be accessed [HERE](https://mybinder.org/v2/gh/meilinshi/Socially-aware-Huff-model/HEAD). There is no need to download the data, code or software.
- **Note**: The `requirements.txt` file should list all Python libraries that the notebooks depend on, and they will be installed using:
  ```
  !pip install -r requirements.txt
  ```

### Abstract
Identifying determinants of tourist destination choice is an important task in the study of nature-based tourism. Traditionally, the study of tourist behavior relies on survey data and travel logs, which are labor-intensive and time-consuming. Thanks to location-based social networks, more detailed data is available at a finer grained spatio-temporal scale. This allows for better insights into travel patterns and interactions between attractions, e.g., parks. Meanwhile, such data sources also bring along a novel social influence component that has not yet been widely studied in terms of travel decisions. For example, social influencers post about certain places, which tend to influence destination choices of tourists. Therefore, in this paper, we propose a socially aware Huff model to account for this social factor in the study of destination choice. Moreover, with fine-grained social media data, interactions between attractions (i.e., the neighboring effects) can be better quantified and thus integrated into models as another factor. In our experiment, we calibrate a model by using trip sequences extracted from geotagged Flickr photos within two national parks in the United States. Our results demonstrate that the socially aware Huff model better simulates tourist travel preferences. In addition, we explore the significance of each factor and summarize the spatial-temporal travel pattern for each attraction. The socially aware Huff model and the calibration method can be applied to other fields such as promotional marketing.

### Interactive Visualization
Flow map visualization of trips in [Acadia National Park](https://flowmap.blue/from-url?flows=https://raw.githubusercontent.com/meilinshi/Socially-aware-Huff-model/master/acadia_tripflow.csv&locations=https://raw.githubusercontent.com/meilinshi/Socially-aware-Huff-model/master/acadia_attractions.csv) and [Yosemite National Park](https://flowmap.blue/from-url?flows=https://raw.githubusercontent.com/meilinshi/Socially-aware-Huff-model/master/yosemite_tripflow.csv&locations=https://raw.githubusercontent.com/meilinshi/Socially-aware-Huff-model/master/yosemite_attractions.csv) using [flowmap.blue](https://flowmap.blue/). 
- Attractions are represented as nodes. The size of nodes is determined by the total number of incoming and outgoing trips. The width of edges is determined by the number of trips.

