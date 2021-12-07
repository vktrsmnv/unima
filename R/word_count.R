#' Word Count
#' @param file A path to a .Rmd file
#' @keywords Word count
#' @importFrom magrittr %>%
#' @import dplyr
#' @import tibble
#' @import readr
#' @import tidytext
#' @importFrom rlang .data
#' @examples
#' # count_words("test.Rmd")
#' @export
#'
count_words <- function(file) {
  wc <- readr::read_lines(file) %>%
    tibble::as_data_frame() %>%
    remove_front_matter() %>%
    remove_code_chunks() %>%
    remove_inline_code() %>%
    remove_appendix() %>%
    remove_html_comment() %>%
    tidytext::unnest_tokens(output = rlang::.data$words, input = rlang::.data$value) %>%
    nrow()
  return(wc)
}

# Helper function for removing unwanted lines from count
# Checks is value is odd.
is_odd <- function(x, val) {
  x %% 2 == 1
}

# Helper function to remove front matter (lines starting with "---" and
# anything between)
remove_front_matter <- function(x) {
  dplyr::mutate(x, is_code = cumsum(grepl("^---", rlang::.data$value))) %>%
    dplyr::group_by(rlang::.data$is_code) %>%
    dplyr::mutate(start_end = lag(rlang::.data$is_code, 1)) %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is_odd(rlang::.data$is_code), !is.na(rlang::.data$start_end)) %>%
    dplyr::select(-rlang::.data$is_code, -rlang::.data$start_end)
}

# Helper function for removing knitr code chunks (lines starting with "```"
# and anything in between)
remove_code_chunks <- function(x) {
  dplyr::mutate(x, is_code = cumsum(grepl("^```", rlang::.data$value))) %>%
    dplyr::group_by(rlang::.data$is_code) %>%
    dplyr::mutate(start_end = lag(rlang::.data$is_code, 1)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(is_odd = is_odd(rlang::.data$is_code)) %>%
    dplyr::filter(rlang::.data$is_odd != TRUE, !is.na(rlang::.data$start_end)) %>%
    dplyr::select(-rlang::.data$is_code, -rlang::.data$start_end, -rlang::.data$is_odd)
}

# Helper function to remove inline code (lines starting with "`r")
remove_inline_code <- function(x) {
  dplyr::filter(x, !grepl("`r", rlang::.data$value))
}

# Helper function to remove HTML comments (lines starting with "<!--" and "-->")
remove_html_comment <- function(x) {
  dplyr::mutate(x, start_comment = cumsum(grepl("^<!--", rlang::.data$value)),
         end_comment = cumsum(grepl("^-->", rlang::.data$value))) %>%
    dplyr::group_by(rlang::.data$start_comment, rlang::.data$end_comment) %>%
    dplyr::mutate(start_end = dplyr::lag(rlang::.data$start_comment, 1)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(remove = if_else(rlang::.data$start_comment - rlang::.data$end_comment == 1 |
                              is.na(rlang::.data$start_end), 1, 0)) %>%
    dplyr::filter(remove != TRUE) %>%
    dplyr::select(-rlang::.data$start_comment, -rlang::.data$end_comment, -rlang::.data$remove)
}

remove_appendix<- function(x) {
  dplyr::mutate(x, is_code = cumsum(grepl("^<!---TC:ignore--->", rlang::.data$value))) %>%
    dplyr::group_by(rlang::.data$is_code) %>%
    dplyr::mutate(start_end = lag(rlang::.data$is_code, 1)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(is_odd = is_odd(rlang::.data$is_code)) %>%
    dplyr::filter(rlang::.data$is_odd != TRUE, !is.na(rlang::.data$start_end)) %>%
    dplyr::select(-rlang::.data$is_code, -rlang::.data$start_end, -rlang::.data$is_odd)
}
