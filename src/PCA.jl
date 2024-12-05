using DataFrames
using LinearAlgebra

mutable struct sub_PCA
    projected_df::AbstractDataFrame
    eigenvalues::Vector
    eigenvectors::Matrix
end

mutable struct PCA_res
    original_df::AbstractDataFrame
    ind_PCA::sub_PCA
    var_PCA::sub_PCA
end

function sub_PCA(M::Matrix)::Tuple{Matrix, Vector, Vector, Matrix}
    # on centre les données par colones
    M_bar = Matrix(center(M))

    # on calcule les matrices de corrélations et de covariances
    cov_matrix = (1/size(M, 1)) * transpose(M_bar) * M_bar
    eigenvalues, eigenvectors = eigen(cov_matrix)

    # trie des valeurs propres et vecteurs propre
    sorted_indices = sortperm(eigenvalues, rev=true)
    eigenvalues = eigenvalues[sorted_indices]
    eigenvectors = eigenvectors[:, sorted_indices]

    projected_data = M_bar * eigenvectors

    return projected_data, sorted_indices, eigenvalues, eigenvectors

end

function PCA(
    df::AbstractDataFrame;
    ind_colname::Union{String, Nothing} = nothing,
    n_components::Union{Int, Nothing} = nothing
)
    df_truncated = select(df, Not(names(df, AbstractString)))

    ind_pca = sub_PCA(Matrix(df_truncated))
    var_pca = sub_PCA(transpose(Matrix(df_truncated)))
    

    # choix des n première dimensions et projection
    # if isnothing(n_components) 
    #     projected_data = M_bar * eigenvectors
    #     projected_df = DataFrame(projected_data, Symbol.(names(df_truncated)[sorted_indices]))
    # else
    #     projected_data = M_bar * eigenvectors[:, 1:n_components]
    #     projected_df = DataFrame(projected_data, Symbol.((names(df_truncated)[sorted_indices])[1:n_components]))
    # end
    # projected_df[!, ind_colname] = df[:, ind_colname]
    # return PCA_res(
    #     df, projected_df, eigenvalues, eigenvectors
    # )

end

function center(data::Matrix)::Matrix{Float64}
    res = similar(data, Float64)
    j = 1
    for col in eachcol(data)
        res[:, j] .= col .- mean(col)
        j += 1
    end
    return res
end


function mean(arr::AbstractVector)
    return sum(arr) / length(arr)
end

function var(arr::Array)
    mean((arr .- mean(arr)).^2)
end




