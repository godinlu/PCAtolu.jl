using PCAtolu
using DataFrames
data = DataFrame(a=1:4, b=["M", "F", "F", "M"])

PCA(data)