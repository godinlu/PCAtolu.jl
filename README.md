# PCAtolu

[![Build Status](https://github.com/godinlu/PCAtolu.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/godinlu/PCAtolu.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This Package provide an easy way to do Principal Components Analysis.

## Installation

```bash
(@v1.11) pkg> add https://github.com/godinlu/PCAtolu.jl
```

## Basic Usage

```julia
using PCAtolu
using DataFrames
using CSV


decathlon = CSV.read("data/decathlon.csv", DataFrame)

pca_res = PCA(decathlon)

# Plot the eigen vectors of variables
plot_var(pca_res)

# Plot Explained variance of Principal components
plot_pc(pca_res)
```
