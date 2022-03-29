####### VMT Analysis
### This is the code for the SB375 VMT analysis that was used in Appendix D, Attachemnt 2 for the 2021 Regional Plan.
### https://sdforward.com/docs/default-source/final-2021-regional-plan/appendix-d---scs-documentation-and-related-information.pdf?sfvrsn=ebc1fd65_2
### Author: Neeco Beltran 
### Date: January 2021

# User Input --------------------------------------------------------------
sql_access <- TRUE ### Does user have SANDAG database to query data using SQL?
## If not, they can use static input files by inputting FALSE instead of TRUE.
## The static input file is the same file read in by the query from the database (lines 44-83).

# Digit Options and Working Directory -------------------------------------
options(scipen=10000) ## Remove scientific notation.
setwd("T:/data/vmt/2020_SB375/nbe_analysis/")

# Load Packages -----------------------------------------------------------
checkpoint_package <- "checkpoint" ## Install checkpoint package to use packages as they existed on a specified date.
need_to_install_checkpoint <- checkpoint_package[!(checkpoint_package %in% installed.packages()[,"Package"])]

if(length(need_to_install_checkpoint)) install.packages(need_to_install_checkpoint)

lapply(checkpoint_package, library, character.only = TRUE)

create_checkpoint("2021-01-31") ## Uses packages as they existed on this date. For reproducibility purposes.

packages_vector <- c("tidyverse", "openxlsx", "readxl", "data.table", "odbc", "strucchange", "checkpoint")
need_to_install <- packages_vector[!(packages_vector %in% installed.packages()[,"Package"])]

if(length(need_to_install)) install.packages(need_to_install)

lapply(packages_vector, library, character.only = TRUE)


# Reading In/Filtering Data -----------------------------------------------
#### Reading in Data
if(sql_access){
  sort(unique(odbcListDrivers()[[1]]))
  con1 <- dbConnect(odbc(), 
                    Driver = "SQL Server", 
                    Server = "DDAMWSQL16", 
                    Database = "travel_data", 
                    Trusted_Connection = "True")
  
  query <- "with [daily_vmt] AS (
                SELECT
                    CONVERT(DATE, [timestamp]) AS [date]
                    ,SUM([total_flow] * [station_length]) AS [vmt]
                    ,AVG(1.0 * [percentage_observed]) AS [percentage_observed]
                FROM
                    [pems].[station_day]
                WHERE
                    [total_flow] IS NOT NULL
                    AND [station_length] IS NOT NULL
                    AND CONVERT(DATE, [timestamp]) >= '2016-01-01'
                GROUP BY
                    CONVERT(DATE, [timestamp]))
            SELECT
                [daily_vmt].[date]
                ,YEAR([daily_vmt].[date]) AS [year]
                ,DATENAME(quarter, [daily_vmt].[date]) AS [quarter]
                ,DATENAME(weekday, [daily_vmt].[date]) AS [day_of_week]
                ,RTRIM(ISNULL([holiday].[holiday], 'Not Applicable')) AS [holiday]
                ,RTRIM(ISNULL([holiday].[type], 'Not Applicable')) AS [holiday_type]
                ,CASE WHEN [holiday].[date] IS NULL THEN 0
                      WHEN [holiday].[date] IS NOT NULL THEN 1
                      END AS [holiday_indicator]
                ,[daily_vmt].[vmt]
                ,[daily_vmt].[percentage_observed]
            FROM
                [daily_vmt]
            LEFT OUTER JOIN
                [pems].[holiday]
            ON
                [daily_vmt].[date] = [holiday].[date]
            WHERE
                -- only use Tuesday-Thursday
                DATENAME(weekday, [daily_vmt].[date]) IN ('Tuesday',
                                                          'Wednesday',
                                                          'Thursday')
                AND [holiday].[date] IS NULL  -- remove holidays
                AND YEAR([daily_vmt].[date]) IN (2016, 2019, 2020)
            ORDER BY
                [daily_vmt].[date]"
  pems_all <- dbFetch(dbSendQuery(con1, query))
  
  pems2016 <- pems_all %>% filter(year == 2016)
  pems2019 <- pems_all %>% filter(year == 2019)
  pems2020 <- pems_all %>% filter(year == 2020)
} else {
  pems_all <- read.csv("./inputs/vmt_weekday_non_holiday_analysis.csv", fileEncoding = "UTF-8-BOM")
  
  pems2016 <- pems_all %>% filter(year == 2016)
  pems2019 <- pems_all %>% filter(year == 2019)
  pems2020 <- pems_all %>% filter(year == 2020)
}

#### Speed/EMFAC Data
## Regular
EMFAC_df <- read_excel("./inputs/EMFAC2014-SANDAG-2020_fix-MCYnotSR3-155-Annual-2020-sb375.xlsx", sheet = 3)
EMFAC_df <- EMFAC_df[49:72, 4:20] ## Relevant speeds and vehicle types.
names(EMFAC_df)[4] <- "05mph"
EMFAC_df <- gather(EMFAC_df, Speed, Percentage, `05mph`:`70mph`, factor_key = TRUE)
EMFAC_df$Test <- "Standard"

## Full Adj
EMFAC_full_adj <- read_excel("./inputs/EMFAC2014-SANDAG-2020_fix-MCYnotSR3-155-Annual-2020-sb375_CONFIG3.xlsx", sheet = 3)
EMFAC_full_adj_df <- EMFAC_full_adj[49:72, 4:20]
names(EMFAC_full_adj_df)[4] <- "05mph"
EMFAC_full_adj_long <- gather(EMFAC_full_adj_df, Speed, Percentage, `05mph`:`70mph`, factor_key = TRUE)
EMFAC_full_adj_long$Test <- "Full Adjustment"

## Speed Adj
EMFAC_speed_adj <- read_excel("./inputs/EMFAC2014-SANDAG-2020_fix-MCYnotSR3-155-Annual-2020-sb375_Speed.xlsx", sheet = 3)
EMFAC_speed_adj_df <- EMFAC_speed_adj[49:72, 4:20]
names(EMFAC_speed_adj_df)[4] <- "05mph"
EMFAC_speed_adj_long <- gather(EMFAC_speed_adj_df, Speed, Percentage, `05mph`:`70mph`, factor_key = TRUE)
EMFAC_speed_adj_long$Test <- "Speed Adjustment"

## VMT Adj
EMFAC_vmt_adj <- read_excel("./inputs/EMFAC2014-SANDAG-2020_fix-MCYnotSR3-155-Annual-2020-sb375_VMT.xlsx", sheet = 3)
EMFAC_vmt_adj_df <- EMFAC_vmt_adj[49:72, 4:20]
names(EMFAC_vmt_adj_df)[4] <- "05mph"
EMFAC_vmt_adj_long <- gather(EMFAC_vmt_adj_df, Speed, Percentage, `05mph`:`70mph`, factor_key = TRUE)
EMFAC_vmt_adj_long$Test <- "VMT Adjustment"

# VMT Plots ----------------------------------------------------------------
## Daily VMT in San Diego County by Year
ggplot(pems_all, aes(x = as.Date(yday(date), "2020-01-01"), y = vmt, 
  color = factor(year(date)))) + geom_line() + 
  scale_x_date(breaks = seq(as.Date("2020-01-01"), 
                            as.Date("2020-12-31"), by = "1 month"), date_labels ="%b") +
  labs(x = "Month", y = "VMT", color = "Year") + ggtitle("Daily VMT (T/W/Th Non-Holiday) in San Diego County by Year") +
  scale_color_manual(values=c("#66097F", "#4B9CE2", "#FF7707")) +
  geom_vline(xintercept = as.Date("2020-03-12"), linetype = "dashed") +
  annotate("text", x = as.Date("2020-03-06"), y = 32500000, label = "Pre-COVID", angle = 90) +
  annotate("text", x = as.Date("2020-05-08"), y = 32500000, label = "COVID Crash", angle = 90) +
  geom_vline(xintercept = as.Date("2020-05-14"), linetype = "dashed") +
  geom_vline(xintercept = as.Date("2020-07-07"), linetype = "dashed") + 
  annotate("text", x = as.Date("2020-07-01"), y = 30000000, label = "COVID Balancing", angle = 90) +
  annotate("text", x = as.Date("2020-09-15"), y = 25000000, label = "COVID Stasis", angle = 0) 

## Daily VMT in San Diego County by Year (Quarterly)
ggplot(pems_all, aes(x = as.Date(yday(date), "2016-01-01"), y = vmt, 
                     color = factor(year(date)))) + geom_line() + 
  scale_x_date(breaks = seq(as.Date("2016-01-01"), 
                            as.Date("2016-12-31"), by = "3 months"), labels = c("Q1", "Q2", "Q3", "Q4")) +
  labs(x = "Quarter", color = "Year") + ggtitle("Daily VMT in San Diego County by Year (Quarterly)") +
  scale_color_manual(values=c("#66097F", "#4B9CE2", "#FF7707")) +
  geom_vline(xintercept = as.Date("2016-03-12"), linetype = "twodash") +
  geom_text(aes(x = as.Date("2016-02-10"), label="Pre-COVID", y = 20000000), color = "black", angle = 0, size = 4) +
  geom_text(aes(x = as.Date("2016-04-13"), label="Post-COVID", y = 20000000), color = "black", angle = 0, size = 4) +
  geom_vline(xintercept = as.Date("2016-06-17"), linetype = "dashed", size = 0.3) +
  geom_text(aes(x = as.Date("2016-07-21"), label ="COVID Stasis", y = 20000000), color = "black", angle = 0, size = 4) 


# EMFAC Speed Bins Plots --------------------------------------------------
#### Standard
ggplot(EMFAC_df, aes(fill = Speed, y = Percentage, x = Hour)) +
  geom_bar(position = "stack", stat = "identity") +
  ggtitle("Percentage of Speeds by Hour in San Diego County (Unadjusted)") +
  theme(plot.title = element_text(size = 11)) +
  scale_x_continuous(breaks = seq(2, 24, by = 2)) +
  scale_fill_manual(values=c("#00ADFF", "#A1AF8E", "#BDBDBD", "#5A5A5A", "#15FF00", "#85D983", "#FFC800", "#D28D16", "#90610F", "#9EC7FF", "#3C8FFF", "#245EAD", "#173967", "#000000"))

#### Full Adjustment
ggplot(EMFAC_full_adj_long, aes(fill = Speed, y = Percentage, x = Hour)) +
  geom_bar(position = "stack", stat = "identity") +
  ggtitle("Percentage of Speeds by Hour in San Diego County (Full Adjustment)") +
  theme(plot.title = element_text(size = 11)) +
  scale_x_continuous(breaks = seq(2, 24, by = 2)) +
  scale_fill_manual(values=c("#00ADFF", "#A1AF8E", "#BDBDBD", "#5A5A5A", "#15FF00", "#85D983", "#FFC800", "#D28D16", "#90610F", "#9EC7FF", "#3C8FFF", "#245EAD", "#173967", "#000000"))

#### Speed Adjustment
ggplot(EMFAC_speed_adj_long, aes(fill = Speed, y = Percentage, x = Hour)) +
  geom_bar(position = "stack", stat = "identity") +
  ggtitle("Percentage of Speeds by Hour in San Diego County (Speed Adjustment)") +
  theme(plot.title = element_text(size = 11)) +
  scale_x_continuous(breaks = seq(2, 24, by = 2)) +
  scale_fill_manual(values=c("#00ADFF", "#A1AF8E", "#BDBDBD", "#5A5A5A", "#15FF00", "#85D983", "#FFC800", "#D28D16", "#90610F", "#9EC7FF", "#3C8FFF", "#245EAD", "#173967", "#000000"))

#### VMT Adjustment
ggplot(EMFAC_vmt_adj_long, aes(fill = Speed, y = Percentage, x = Hour)) +
  geom_bar(position = "stack", stat = "identity") +
  ggtitle("Percentage of Speeds by Hour in San Diego County (VMT Adjustment)") +
  theme(plot.title = element_text(size = 11)) +
  scale_x_continuous(breaks = seq(2, 24, by = 2)) +
  scale_fill_manual(values=c("#00ADFF", "#A1AF8E", "#BDBDBD", "#5A5A5A", "#15FF00", "#85D983", "#FFC800", "#D28D16", "#90610F", "#9EC7FF", "#3C8FFF", "#245EAD", "#173967", "#000000"))


# Means and Medians -------------------------------------------------------
mean(pems2020$vmt[pems2020$date >= '2020-01-01' & pems2020$date <= '2020-12-31']) ## Whole Year
mean(pems2020$vmt[pems2020$date >= '2020-01-01' & pems2020$date <= '2020-03-31']) ## Q1
mean(pems2020$vmt[pems2020$date >= '2020-04-01' & pems2020$date <= '2020-06-30']) ## Q2
mean(pems2020$vmt[pems2020$date >= '2020-07-01' & pems2020$date <= '2020-09-30']) ## Q3
mean(pems2020$vmt[pems2020$date >= '2020-10-01' & pems2020$date <= '2020-12-31']) ## Q4
mean(pems2020$vmt[pems2020$date >= '2020-01-01' & pems2020$date <= '2020-03-12']) ## Pre-COVID
median(pems2020$vmt[pems2020$date >= '2020-01-01' & pems2020$date <= '2020-03-12']) ## Pre-COVID Median
mean(pems2020$vmt[pems2020$date >= '2020-03-17' & pems2020$date <= '2020-12-31']) ## Post-COVID 
median(pems2020$vmt[pems2020$date >= '2020-03-17' & pems2020$date <= '2020-12-31']) ## Post-COVID Median
mean(pems2020$vmt[pems2020$date >= '2020-03-17' & pems2020$date <= '2020-05-14']) ## COVID Crash
mean(pems2020$vmt[pems2020$date >= '2020-05-19' & pems2020$date <= '2020-07-07']) ## COVID Balancing
median(pems2020$vmt[pems2020$date >= '2020-05-19' & pems2020$date <= '2020-07-07']) ## COVID Balancing Median
mean(pems2020$vmt[pems2020$date >= '2020-07-08' & pems2020$date <= '2020-12-31']) ## COVID Stasis
mean((pems2020$vmt[(pems2020$date >= '2020-01-01' & pems2020$date <= '2020-03-12') |
                   pems2020$date >= '2020-07-08' & pems2020$date <= '2020-12-31'])) ## Pre COVID and COVID stasis

# Structural Breaks Analysis -------------------------------------------------
ts2020 <- as.ts(pems2020[, c(8)]) ## Time series object for VMT
bp_ts2020 <- breakpoints(ts2020 ~ 1, breaks = 3) ## Find breakpoints (Specify 3 breakpoints)
options(scipen = 0)

model_with_bp <- lm(ts2020 ~ breakfactor(bp_ts2020, breaks = 3)) ## Returns time series regression with breakpoints.
model_without_bp <- lm(ts2020 ~ 1) ## Returns time series regression without breakpoints (i.e. straight line).

### Plots 2020 VMT overlaid with time series regression with and without breakpoints.
options(scipen = 100000) 
plot(ts2020, main = "2020 VMT (T/W/Th Non-Holiday) in San Diego County with Breakpoints", ylab = "VMT", xlab = "Time Index") 
lines(ts(fitted(model_with_bp), start = 0), col = 4) ## With breakpoints
lines(ts(fitted(model_without_bp), start = 0), col = "#838383", lty = 2) ## Without breakpoints
lines(bp_ts2020) ## Plots the VMT time series

bp_ts2020$breakpoints ### Returns the location index of the breakpoints.
pems2020$date[bp_ts2020$breakpoints] ### Return date based on index of breakpoint.
