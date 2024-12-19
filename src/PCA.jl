using DataFrames
using LinearAlgebra
using Plots
using Statistics

mutable struct PCA_res
    original_df::AbstractDataFrame
    projected_df::AbstractDataFrame
    eigenvalues::Vector
    eigenvectors::Matrix
end

function sub_PCA(M::AbstractMatrix)::Tuple{Matrix, Vector, Vector, Matrix}
    # on centre les données par colones
    M_bar = Matrix(scale(M))

    # on calcule les matrices de corrélations et de covariances
    cov_matrix =  (1/(size(M, 1) - 1)) * transpose(M_bar) * M_bar
    eigenvalues, eigenvectors = eigen(cov_matrix)

    # trie des valeurs propres et vecteurs propre
    sorted_indices = sortperm(eigenvalues, rev=true)
    eigenvalues = eigenvalues[sorted_indices]
    eigenvectors = eigenvectors[:, sorted_indices]

    projected_data = M_bar * eigenvectors

    return projected_data, sorted_indices, eigenvalues, eigenvectors

end

"""
Effectue une analyse en composante principal.

# param :
- df : Dataframe à analyser

# Exemple :
```{julia}
# import du dataframe
decathlon = CSV.read("data/decathlon.csv", DataFrame)

pca_res = PCA(decathlon)

# plot les variables
plot_var(pca_res)

# plot les composantes principales
plot_pc(pca_res)
```

"""
function PCA(df::AbstractDataFrame)
    df_truncated = select(df, Not(names(df, AbstractString)))

    var_pca = sub_PCA(Matrix(df_truncated))

    # choix des n première dimensions et projection
    projected_df = DataFrame(var_pca[1], Symbol.(names(df_truncated)[var_pca[2]]))
    
    # maintenant on créer le PCA_res
    return PCA_res(df, projected_df, var_pca[3], var_pca[4])

end

"""
Représente les variables selon les vecteurs propres

# param :
- pca_res : Résultats de la fonction PCA
- choosen_dim: tuple des dimensions voulues
"""
function plot_var(pca_res::PCA_res; choosen_dim::Tuple{Int, Int} = (1, 2))
    
    x = Vector(pca_res.eigenvectors[:,choosen_dim[1]]) 
    y = Vector(pca_res.eigenvectors[:,choosen_dim[2]]) 
    labels = names(pca_res.projected_df)

    # calcul des variances expliquées des dimensions choisi
    var1 = round(pca_res.eigenvalues[choosen_dim[1]] / sum(pca_res.eigenvalues)*100, digits=2) 
    var2 = round(pca_res.eigenvalues[choosen_dim[2]] / sum(pca_res.eigenvalues)*100, digits=2) 

    # ajout du plot du cercle
    theta = 0:0.01:2π
    x_circle = cos.(theta)
    y_circle = sin.(theta)
    p = plot(
        x_circle, 
        y_circle, 
        aspect_ratio=:equal, 
        xlabel="dim "*string(choosen_dim[1]) * " ($var1%)" , 
        ylabel="dim "*string(choosen_dim[2]) * "($var2%)", 
        title="Variables - PCA", legend=false, color=:black)

    quiver!(zeros(length(x)), zeros(length(y)), quiver=(x, y), 
     arrow=:stealth, color=:black)

    # Ajouter les labels
    for (i, txt) in enumerate(labels)
        annotate!(x[i], y[i], text(txt, :black, :left, 10))
    end
    return p

end


"""
Représente les proportions de variance expliquées par dimensions.

# param :
- pca_res : Résultats de la fonction PCA
"""
function plot_pc(pca_res::PCA_res)
    pc = Vector()
    for (i, eigen_val) in enumerate(pca_res.eigenvalues) 
        push!(pc, eigen_val / sum(pca_res.eigenvalues))
    end
    p = bar(pc, barorientation=:horizontal, title="Composantes principales", xlabel="composantes principales", ylabel="Variance expliquée", color=:orange, legend=false)
    return p
end


function scale(data::AbstractMatrix)
    # Calcul de la moyenne et de l'écart-type de chaque colonne
    means = mean(data, dims=1)
    stds = std(data, dims=1)

    # Appliquer le scalage (moyenne 0 et écart-type 1)
    return (data .- means) ./ stds
end




