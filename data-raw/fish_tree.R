# Build the `fish_tree` data object: Fish Tree of Life actinopterygian
# phylogeny (actinopt_12k_raxml, https://fishtreeoflife.org/) pruned to the
# marine fish hosts of Caligus and Lepeophtheirus recorded in the cofid
# package (https://github.com/alrobles/cofid).
#
# Requires: the full tree from
# https://fishtreeoflife.org/downloads/actinopt_12k_raxml.tre.xz
# (also archived in cofid/data-raw/actinopt_12k_raxml.tre.xz)

library(ape)

tree_path <- "actinopt_12k_raxml.tre"
tr <- read.tree(tree_path)

interactions <- cofid::cofid
interactions$genus <- sub(" .*", "", interactions$source_taxon_name)
interactions <- interactions[interactions$genus %in%
                               c("Caligus", "Lepeophtheirus"), ]

tips_binomial <- gsub("_", " ", tr$tip.label)
hosts <- unique(interactions$target_taxon_name)
keep <- tr$tip.label[tips_binomial %in% hosts]

fish_tree <- keep.tip(tr, keep)
fish_tree$tip.label <- gsub("_", " ", fish_tree$tip.label)

usethis::use_data(fish_tree, overwrite = TRUE, compress = "xz")
