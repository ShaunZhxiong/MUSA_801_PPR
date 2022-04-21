## In data_for_prediction.csv:

**origin**: ID for cbg
**id**: ID for PPR property,equal to OBJECTID in propertyWithPlaceKey.geojson
**distance**: predictor D
**centrality**: predictor C
**prob**: actual value of y, DEPENENT variable
**area- permitCap**: predictors A1, A2, A3....

-----------------------------

## In parameter_for_prediction.csv**:

**origin**: ID for cbg
**beta**: parameter for centrality (predictor C)
**theta**: parameter for distance (predictor D)
**r2**: model score for this origin, will not be used in prediction
**alpha1 - alpha15**: parameter for predictors A, Corresponding to the order area - permitCap

-----------------------------

## Huff model formular:
https://escholarship.org/uc/item/3p8337sr#page=22

