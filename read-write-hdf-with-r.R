library(rhdf5)

path = "sjr1500_omr5000.h5"
fc <- h5ls(path)
unique(fc$group)
h5readAttributes(path, "hydro")
h5readAttributes(path, "hydro/data/channel area")
