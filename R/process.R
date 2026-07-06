library(fs)
library(vroom)
library(arrow)

cache_dir <- "raw"
data_dir <- "brick"

fs::dir_create(data_dir)

csv_files <- fs::dir_ls(cache_dir, recurse = TRUE, glob = "*.csv")

for (csv_file in csv_files) {
    rel_path <- fs::path_rel(csv_file, cache_dir)
    parquet_path <- file.path(data_dir, fs::path_ext_set(rel_path, "parquet"))
    fs::dir_create(fs::path_dir(parquet_path))
    # Read every column as character. vroom's default type guessing samples only
    # leading rows and guessed logical for curated-sparse columns whose leading
    # rows were empty (e.g. Loinc.AskAtOrderEntry, HL7_FIELD_SUBFIELD_ID,
    # ValidHL7AttachmentRequest, PanelsAndForms.ConditionForInclusion,
    # AnswerList.SubsequentTextPrompt), silently coercing later values to NA.
    arrow::write_parquet(
        vroom::vroom(csv_file, col_types = vroom::cols(.default = vroom::col_character())),
        parquet_path
    )
}
