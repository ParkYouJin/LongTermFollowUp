dbms = "sql server"
server = Sys.getenv("server58")
user = Sys.getenv("userID")
password = Sys.getenv("userPW")
port = NULL

cdmDatabaseSchema = 'ICARUS.dbo'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                user = user,
                                                                password = password,
                                                                server = server,
                                                                port)

measurementConceptIdSet = c(3010813,3006504)

measurementData <- extractMeasurement(connectionDetails = connectionDetails,
                                      cdmDatabaseSchema = 'ICARUS.dbo',
                                      measurementConceptIdSet = c(measurementConceptIdSet))

head(measurementData)
