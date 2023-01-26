# Data files are in row = genes and col = samples format
# df = data frame

# Load in and format data file
df <- as.data.frame(read.csv('RNAseq_data.csv'))
df <- na.omit(df)
rownames(df) <- df$GeneId
df <- df[, 9:11] # selecting 3 columns from df
df <- MC_HSD_df[, -2] # removing the column in df at 2 index
df$pval <- -log10(df$pval)
colnames(df) <- c("log2(FoldChange)", "-log10(Pval)")

# Load in ggplot2 and install if needed
BiocManager::install("ggplot2")
library(ggplot2)

# Add column that distinguishes significant vs not significant in data
df$significant <- ifelse(df$`-log10(Pval)` > 1.301, "Significant (P < 0.05)", "Not Significant")

# Plot the volcano plot and save to a pdf file - run these commands at the same exact time for the pdf to save properly
pdf(file = "volcanoPlot.pdf", width = 12, height = 9)
ggplot(df) + 
      geom_point(aes(`log2(FoldChange)`,`-log10(Pval)`,col= significant)) + 
      theme(legend.title=element_blank(),text = element_text(size= 13)) +
      scale_color_manual(values=c("lightgreen", "darkgreen")) + theme_classic() + ggtitle("Volcano Plot")
      
# Can change parameters from code above to match what you would like - title, color, etc.
# Can add 'xlim(X,Y)' or 'ylim(X,Y)' to above to make X or Y axis cutoffs

# Save the df file that we used for volcano plot
write.csv(df, "df.csv")
