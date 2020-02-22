
#'@import dplyr
#'@export

checkMeasurement <- function(measurementData,
                             checkUnit = TRUE){
  # head(measurementData)
  if(checkUnit){
    totalMeasurementCount <- measurementData %>% group_by(measurementConceptId) %>% summarise(totalCount = n())
    unitMeasurementCount  <- measurementData %>% group_by(measurementConceptId,unitConceptId,unitConceptName) %>% summarise(count = n())
    unitProportion <- left_join(totalMeasurementCount,unitMeasurementCount,by = "measurementConceptId") %>%
      mutate(unitProportion = (count/totalCount)*100)
  }


}
