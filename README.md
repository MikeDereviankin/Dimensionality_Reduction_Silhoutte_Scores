# Linear Mixing Model of Dimensionality Reduction to Reconstruct Fingerprints

## Introduction
 
This R code was developed to perform a linear mixing model of dimensionality reduction to reconstruct fingerprints. The code uses principle component analysis (PCA), t-distributed stochastic neighbor embedding (t-SNE), and uniform manifold approximation and projection (UMAP) techniques to reduce the dimensionality of the input data. The reduced data sets are then clustered using K-means clustering, and the silhouette score is calculated for each cluster to evaluate the clustering quality. The code outputs a plot that compares the silhouette scores for each clustering method.

## Why this Code is Helpful

Fingerprint identification is a crucial tool in forensic science, and reconstructing partial or degraded latent fingerprints is often challenging. This R code aims to reduce the dimensionality of the input data and cluster it to identify patterns in the fingerprint data, making it easier to identify the unique characteristics of individual fingerprints.

The code provides a comparison of different dimensionality reduction techniques (PCA, t-SNE, and UMAP), giving the user the flexibility to choose the technique that works best for their data. The code outputs a plot that compares the clustering quality of each technique, providing a visual representation of the results.

## General Ideas on the Overall Concepts

PCA, t-SNE, and UMAP are commonly used techniques for dimensionality reduction. The basic idea behind these techniques is to reduce the complexity of high-dimensional datasets by projecting them onto a lower-dimensional space.

K-means clustering is a popular unsupervised clustering algorithm used to identify patterns in data. It groups data points based on their proximity to the nearest cluster center, and the silhouette score is used to evaluate the quality of the clustering.

This R code uses a linear mixing model to generate reduced-dimensional data sets, which are then clustered using K-means clustering. The resulting silhouette scores provide a measure of the effectiveness of the clustering, and the plot of silhouette scores allows for easy comparison of different dimensionality reduction techniques.

Overall, this R code provides a useful framework for processing and analyzing fingerprint data, and provides a starting point for further exploration of different dimensionality reduction and clustering techniques.

## Input Data

After installing the required packages and obtaining the input dataset, you can run the code in R by simply copying and pasting it into an R session. Before running the code, make sure to set the working directory to the location where the input dataset is stored.

The code will automatically load the required packages and input dataset. After running the code, you can view the resulting plots or other outputs in the R session.

## Usage

After installing the required packages and obtaining the input dataset, you can run the code in R by simply copying and pasting it into an R session. Before running the code, make sure to set the working directory to the location where the input dataset is stored.

The code will automatically load the required packages and input dataset. After running the code, you can view the resulting plots or other outputs in the R session.

## Output

The output of this code includes a plot that compares the silhouette scores of each clustering method (PCA, t-SNE, and UMAP), as well as clustered data sets and the calculated silhouette scores for each clustering method.

## Mike's Helpful Suggestions

 1. Optimizing the UMAP
Once the input data is loaded, the script calculates the UMAP and tSNE projections. It sets the matrix of the data to be used in the UMAP calculation by only selecting certain columns (specified by the user) of the input dataset. The user can then manually set the parameters for the UMAP calculation, including n_components, n_neighbors, and min_dist. The tSNE calculation is performed using the Rtsne function, with the user specifying the dimensions (3), perplexity (30), and the check_duplicates parameter set to FALSE.

The user can use the sihoutte scores to determine which clustering best spreads out the K-mean clusters. Play around with the parameters and see what visualization brings the best power in explaining the unique K-means clusters of fingeprints!

2. Quick change of columns used for dimensionality reduction -> simply replace all the columns in the code with the ones you need and it should be fairly quick. 

3. Play around with normalization of fingerprints. This workflow is a great example of where the user can try different means of normalizations and have a quantitative way (silhoutte scores) to determine which methods best spreads out the fingerprints. 
