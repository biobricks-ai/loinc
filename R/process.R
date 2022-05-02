library(fs)
library(vroom)
library(arrow)

cache_dir <- "cache"
data_dir <- "data"

fs::dir_create(data_dir)

arrow::write_parquet(
    vroom::vroom(file.path(cache_dir, "LoincTable", "Loinc.csv")),
    file.path(data_dir,"Loinc.parquet")
)

arrow::write_parquet(
    vroom::vroom(file.path(cache_dir,"LoincTable","MapTo.csv")),
    file.path(data_dir,"MapTo.parquet")
)
