library(purrr)
library(rvest)
library(getPass)
library(dplyr)
library(httr)
library(fs)
library(stringr)

cache_dir <- "cache"
fs::dir_create(cache_dir)

download_url <- "https://loinc.org/download/loinc-complete/"
login_url <- "https://loinc.org/wp-login.php"

# get credentials
message("You will need to create a free account at https://loinc.org/join/")
if (interactive()) {
    username <- readline("LOINC username: ")
} else {
    cat("LOINC username: ")
    username <- readLines("stdin", n = 1)
}
password <- getPass("LOINC Passwd: ")

# login
login_submit_res <- login_url |>
    read_html() |>
    html_form() |>
    pluck(1) |>
    html_form_set(log = username, pwd = password) |>
    html_form_submit()

# get login cookie
auth_cookie_value <- login_submit_res$cookies |>
    dplyr::filter(grepl("wordpress_logged_in", name))
auth_cookie <- c()
auth_cookie[auth_cookie_value$name] <- auth_cookie_value$value

# go to download link
download_redirect_url <- download_url |>
    httr::GET(set_cookies(.cookies = auth_cookie)) |>
    pluck("url")

# accept agreement
accept_license_form <- download_redirect_url |>
    httr::GET(set_cookies(.cookies = auth_cookie)) |>
    read_html() |>
    html_form() |>
    pluck(2)

accept_license_resp <- httr::POST(
    url = accept_license_form$action,
    body = list(tc_accepted = 1, tc_submit = "Download"),
    encode = accept_license_form$enctype,
    set_cookies(.cookies = auth_cookie)
)

filename <- accept_license_resp |>
    pluck("headers") |>
    pluck("content-disposition") |>
    stringr::str_match("filename=\"(.*)\"") |>
    pluck(2)

writeBin(accept_license_resp$content, con = file.path(cache_dir, filename))