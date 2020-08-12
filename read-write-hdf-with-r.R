library(rhdf5)

path = "sjr1500_omr5000.h5"
file_contents <- h5ls(path)
unique(file_contents$group)
h5readAttributes(path, "hydro")
h5readAttributes(path, "hydro/data/channel area")
