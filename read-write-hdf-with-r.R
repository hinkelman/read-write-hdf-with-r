library(rhdf5)

path = "sjr1500_omr5000.h5"

file_contents <- h5ls(path)
unique(file_contents$group)

hydro_attr <- h5readAttributes(path, "hydro")
flow_attr <- h5readAttributes(path, "hydro/data/channel flow")

num_int <- hydro_attr$`Number of intervals`
time_int <- hydro_attr$`Time interval`  # minutes
start_dt <- flow_attr$start_time

datetimes <- seq.POSIXt(from = as.POSIXct(start_dt, tz = "UTC"),
                        by = paste(time_int, "mins"),
                        length.out = num_int)

head(datetimes)
summary(datetimes)

h5read(path, "hydro/geometry/channel_location")
h5read(path, "hydro/geometry/channel_number")[90:115]

flow <- h5read(path, "hydro/data/channel flow")
dim(flow)

area <- h5read(path, "hydro/data/channel area")
dim(area)

velocity <- flow/area
velocity[1, 1:5, 1:5]
