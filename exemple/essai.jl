using PCAtolu
using DataFrames
using CSV


decathlon = CSV.read("data/decathlon.csv", DataFrame)

pca_res = PCA(decathlon)
plot_var(pca_res)
plot_pc(pca_res)


