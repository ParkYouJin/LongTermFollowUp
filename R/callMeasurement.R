#'call measurement data i neede to calculate
#'@param connectionDetails
#'@param cdmDatabaseSchema
#'@param vocabularyDatabaseSchema
#'@param measurementConceptIdSet   vector of measurement concept ids I need
#'@export

extractMeasurement <- function(connectionDetails,
                               cdmDatabaseSchema,
                               vocabularyDatabaseSchema = cdmDatabaseSchema,
                               measurementConceptIdSet){

  measurementConceptIdSet = paste(measurementConceptIdSet, collapse = ",")
  measurementSql <- ' select * FROM (select * FROM @cdmDatabaseSchema.measurement WHERE measurement_concept_id in (@measurementConceptIdSet)) measure
                      LEFT JOIN (select concept_id,concept_name as measurement_concept_name FROM @vocabularyDatabaseSchema.concept) measureVoca
                      ON measure.measurement_concept_id = measureVoca.concept_id
                      LEFT JOIN (select concept_id as unit_concept_id_key,concept_name as unit_concept_name FROM @vocabularyDatabaseSchema.concept) unitVoca
                      ON measure.unit_concept_id = unitVoca.unit_concept_id_key'
  measurementSql <- SqlRender::render(sql = measurementSql,
                                      cdmDatabaseSchema = cdmDatabaseSchema,
                                      vocabularyDatabaseSchema = vocabularyDatabaseSchema,
                                      measurementConceptIdSet = measurementConceptIdSet)

  ParallelLogger::logInfo("Call measurement data I need")
  measurementCollect <- DatabaseConnector::querySql(connection = DatabaseConnector::connect(connectionDetails = connectionDetails),
                                                    sql = measurementSql,
                                                    snakeCaseToCamelCase = TRUE)

  return(measurementCollect)
}
