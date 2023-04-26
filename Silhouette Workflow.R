#Author: M. Dereviankin
#Date: 2-March-2023
#Title: Linear Mixing Model of Dimensionality Reduction to Reconstruct Fingerprints
#Summary:This code loads a data set, performs PCA, t-SNE, and UMAP dimensionality reduction 
#techniques, performs K-means clustering on each reduced data set, and calculates the silhouette 
#score for each cluster. Finally, the code creates a plot that compares the silhouette scores for 
#each dimensionality reduction technique.

#load codes from Github

library(rARPACK)
library(MASS)
library(dimRed)
library(uwot)
library(cluster)
library(phateR)
library(factoextra)
library(umap)
library(Rtsne)
library(ggplot2)
library(mclust)
library(ellipse)
library(gridExtra)

#load the practice data

data = read.csv("data.csv")

#Perform UMAP/t-SNE/PCA

# Perform PCA
pca <- prcomp(data[, 66:114], scale. = TRUE)
pca_scores <- as.data.frame(pca$x[,1:2])
pca_cluster <- kmeans(pca_scores, centers = 5)#centers is the number of proposed end-members
pca_cluster_int <- as.integer(pca_cluster$cluster)
pca_dist <- dist(pca_scores) # Compute the Euclidean distance matrix between the PCA scores

# Perform t-SNE
tsne <- Rtsne(data[, 66:114], dims = 2, perplexity = 30)
tsne_scores <- Rtsne(data[, 66:114], dims = 2, perplexity = 30)$Y %>% as.data.frame()
tsne_cluster <- kmeans(tsne_scores, centers = 5) #centers is the number of proposed end-members
tsne_cluster_int <- as.integer(tsne_cluster$cluster)
tsne_dist <- dist(tsne_scores)

# Perform UMAP
set.seed(123)
umap <- umap(data[, 66:114], n_components = 2, metric = "euclidean")
umap_scores <- umap(data[, 66:114], n_components = 2, metric = "euclidean", n_neighbors = 15, min_dist = 0.4) %>% as.data.frame()
umap_cluster <- kmeans(umap_scores, centers = 5) #centers is the number of proposed end-members
umap_cluster_int <- as.integer(umap_cluster$cluster)
umap_dist <- dist(umap_scores) # Compute the Euclidean distance matrix between the PCA scores

# Calculate silhouette score for each method
pca_sil <- silhouette(pca_cluster_int, as.dist(pca_dist))
umap_sil <- silhouette(umap_cluster_int, as.dist(umap_dist))
tsne_sil <- silhouette(tsne_cluster_int, as.dist(tsne_dist))

# Create a data frame with the silhouette scores for each method
pca_sil_df <- as.data.frame(pca_sil)
umap_sil_df <- as.data.frame(umap_sil)
tsne_sil_df <- as.data.frame(tsne_sil)

df <- data.frame(Method = c(rep("PCA", nrow(pca_sil_df)), 
                            rep("UMAP", nrow(umap_sil_df)), 
                            rep("t-SNE", nrow(tsne_sil_df))),
                 Silhouette = c(pca_sil_df$sil_width, umap_sil_df$sil_width, tsne_sil_df$sil_width))

#Create df for all the dimensionality reduction techniques
pca_df <- data.frame(x = pca$x[, 1], y = pca$x[, 2], 
                     Cluster = as.factor(pca_cluster$cluster), 
                     Silhouette = pca_sil[, 3])

tsne_df <- data.frame(x = tsne_scores[, 1], y = tsne_scores[, 2], 
                      Cluster = as.factor(tsne_cluster_int), 
                      Silhouette = tsne_sil[, 3])

umap_df <- data.frame(x = umap_scores[, 1], y = umap_scores[, 2], 
                      Cluster = as.factor(umap_cluster_int), 
                      Silhouette = umap_sil[, 3])

# Create a plot of silhouette scores
ggplot(df, aes(x = Method, y = Silhouette, fill = Method)) +
  geom_boxplot() +
  scale_fill_manual(values = c("#00AFBB", "#E7B800", "#FC4E07")) +
  theme_classic() +
  labs(title = "Silhouette Scores",
       x = "Method",
       y = "Silhouette Score")

#combined plot
# Create ggplot for t-SNE
tsne_plot <- ggplot(tsne_df, aes(x = x, y = y, color = factor(Cluster))) +
  geom_point(size = 2) +
  ggtitle("t-SNE") +
  theme_bw() +
  labs(caption = paste0("Silhouette Score: ", round(mean(tsne_sil[, 3]), 2))) +
  theme(plot.title = element_text(hjust = 0.5))

# Create ggplot for UMAP
umap_plot <- ggplot(umap_df, aes(x = x, y = y, color = factor(Cluster))) +
  geom_point(size = 2) +
  ggtitle("UMAP") +
  theme_bw() +
  labs(caption = paste0("Silhouette Score: ", round(mean(umap_sil[, 3]), 2))) +
  theme(plot.title = element_text(hjust = 0.5))

# Create ggplot for PCA
pca_plot <- ggplot(pca_df, aes(x = x, y = y, color = factor(Cluster))) +
  geom_point(size = 2) +
  ggtitle("PCA") +
  theme_bw() +
  labs(caption = paste0("Silhouette Score: ", round(mean(pca_sil[, 3]), 2))) +
  xlab(paste0("PC1 (", round(summary(pca)$importance[2,1],2)*100, "%)")) +
  ylab(paste0("PC2 (", round(summary(pca)$importance[2,2],2)*100, "%)")) +
  theme(plot.title = element_text(hjust = 0.5))

# Combine ggplots using grid.arrange()
gridExtra::grid.arrange(pca_plot, tsne_plot, umap_plot, ncol = 3)