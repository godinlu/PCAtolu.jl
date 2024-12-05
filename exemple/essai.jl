using PCAtolu
using DataFrames
using CSV


decathlon = CSV.read("data/decathlon.csv", DataFrame)

pca_res = PCA(decathlon, ind_colname="Column1", n_components=2)

#pca_res
#plot_ind(pca_res, ind_col="")

