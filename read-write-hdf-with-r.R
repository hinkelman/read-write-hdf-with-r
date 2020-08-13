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

flow_attr <- h5read(path, "hydro/data/channel flow", read.attributes = TRUE)
str(flow_attr)
attr(flow_attr, "start_time")

flow <- h5read(path, "hydro/data/channel flow")
dim(flow)

area <- h5read(path, "hydro/data/channel area")
dim(area)

velocity <- flow/area
velocity[1, 1:5, 1:5]

pre_slice <- function(dim1, dim2, dim3){
  h5read(path, "hydro/data/channel flow", index = list(dim1, dim2, dim3))
  h5closeAll() }

post_slice <- function(dim1, dim2, dim3){
  h5read(path, "hydro/data/channel flow")[dim1, dim2, dim3, drop = FALSE]
  h5closeAll() }

microbenchmark::microbenchmark(
  pre_slice(1, 1:52, 1:144), 
  post_slice(1, 1:52, 1:144),
  pre_slice( 1:2, 1:465, 1:1297),
  post_slice(1:2, 1:465, 1:1297),
  pre_slice( 1, sample(1:517, 52), sample(1:1441, 144)), 
  post_slice(1, sample(1:517, 52), sample(1:1441, 144)),
  pre_slice( 1, sample(1:517, 104), sample(1:1441, 288)), 
  post_slice(1, sample(1:517, 104), sample(1:1441, 288)),
  times = 25L)

h5createFile("ex_hdf5file.h5")

# write a matrix
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "ex_hdf5file.h5","B")

str(readH5("ex_hdf5file.h5","B"))