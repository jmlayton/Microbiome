library(dplyr)

gr_freq <- function(df,group){
  df_freq <- df %>% 
    group_by({{group}}) %>%
    dplyr::summarize(cnt=n()) %>%
    mutate(freq = formattable::percent(cnt / sum(cnt)))
  return(data.frame(df_freq))
}
ggplot_freq <- function(df, group) {
  p <- ggplot(tidyepd, aes(x={{group}}, y=freq)) +
    geom_line() +
    geom_point()
  return(p)
}
dfcol <- function(df) {
  colnames_tidyepd <- (colnames(df))
  return(data.frame(colnames(df)))
}
`%!in%` <- Negate(`%in%`)
