# create a df in the form of
# region 1960 1961 1962 1963 ... 2010

# first region
regions = colnames(df_quandl)[2:nrow(df_quandl)]
df_boxplot = data.frame(region = regions)

for (year in 1960:2010)
{
  # now values
  values=df_quandl[year==df_quandl$year, 2:nrow(df_quandl)]
  # wow, this is what R makes you do to convert the df to a vector
  values=as.numeric(as.vector(values[1,]))
  
  df_tmp = data.frame(region = regions, value = values)
  colnames(df_tmp) = c("region", as.character(year))
  df_boxplot = merge(df_boxplot, df_tmp)
}