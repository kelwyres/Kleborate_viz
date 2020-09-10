#!/usr/bin/Rscript

# Load libraries
suppressMessages(library(ggplot2))
suppressMessages(library(ggthemes))
suppressMessages(library(shinydashboard))
suppressMessages(library(RColorBrewer))
suppressMessages(library(dplyr))
suppressMessages(library(plotly))
suppressMessages(library(heatmaply))
suppressMessages(library(reshape2))
suppressMessages(library(vegan))
suppressMessages(library(ComplexHeatmap))
suppressMessages(library(readxl))
suppressMessages(library(pheatmap))
suppressMessages(library(ggrepel))
suppressMessages(library(shinythemes))

#Input = automatic
#data <- read.csv("/data/EuSCAPE-Kleborate-AMR_comparison_forR.csv")
amr_df <- data.frame(data)

carb_summary <- as.character(amr_df$Bla_carb!="-")
carb_Omp_summary <- as.character(amr_df$Bla_carb)

carb_summary <- replace(carb_summary,carb_summary=="TRUE","Carbapenemase")
carb_summary <- replace(carb_summary,carb_summary=="FALSE","none")

carb_Omp_summary <- replace(carb_Omp_summary,amr_df$Bla_carb=="-" & amr_df$Omp=="-","none")
carb_Omp_summary <- replace(carb_Omp_summary,amr_df$Bla_carb!="-" & amr_df$Omp=="-","Carbapenemase")
carb_Omp_summary <- replace(carb_Omp_summary,amr_df$Bla_carb!="-" & amr_df$Omp!="-","Carbapenemase+Omp")
carb_Omp_summary <- replace(carb_Omp_summary,amr_df$Bla_carb=="-" & amr_df$Omp!="-","Omp")

amr_df$carb_summary <- factor(carb_summary, levels=c("none","Carbapenemase"))
amr_df$carb_Omp_summary <- factor(carb_Omp_summary, levels=c("none","Omp","Carbapenemase","Carbapenemase+Omp"))

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_summary)) + geom_boxplot() + geom_jitter() +
theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_hline(yintercept=8, linetype="dashed", color = "red") +
theme_classic() + ylab("MIC Imipenem") + xlab("Reported carbapenemase") + scale_y_continuous(trans = "log2")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_summary)) + geom_boxplot() + geom_jitter(aes(colour=ST_to_plot)) +
theme(axis.text.x = element_text(angle = 90, hjust = 1)) + geom_hline(yintercept=8, linetype="dashed", color = "red") +
theme_classic() + ylab("MIC Imipenem") + xlab("Reported carbapenemase") + scale_y_continuous(trans = "log2")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_Omp_summary)) + geom_boxplot() + geom_jitter() +
theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous(trans="log2") +
geom_hline(yintercept=8, linetype="dashed", color = "red") + theme_classic() + ylab("MIC Meropenem") + xlab("Reported carbapenemase")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_Omp_summary)) + geom_boxplot() + geom_jitter(aes(colour=ST_to_plot)) +
theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous(trans="log2") +
geom_hline(yintercept=8, linetype="dashed", color = "red") +theme_classic() + ylab("MIC Meropenem") + xlab("Reported carbapenemase")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_summary)) + geom_boxplot() + geom_jitter() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
geom_hline(yintercept=8, linetype="dashed", color = "red")+theme_classic() + ylab("MIC Meropenem") + xlab("Reported carbapenemase") + scale_y_continuous(trans = "log2")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_summary)) + geom_boxplot() + geom_jitter(aes(colour=CG_to_plot)) +
theme(axis.text.x = element_text(angle = 90, hjust = 1))+ geom_hline(yintercept=8, linetype="dashed", color = "red") +
theme_classic() + ylab("MIC Meropenem") + xlab("Reported carbapenemase") + scale_y_continuous(trans = "log2")

ggplot(amr_df, aes(y=Meropenem_MIC,x= carb_Omp_summary)) + geom_boxplot() + geom_jitter(aes(colour=CG_to_plot)) +
theme(axis.text.x = element_text(angle = 90, hjust = 1))+ scale_y_continuous(trans="log2") +
geom_hline(yintercept=8, linetype="dashed", color = "red") + theme_classic() + ylab("MIC Meropenem") + xlab("Reported carbapenemase")