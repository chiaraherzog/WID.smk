#' WID-SMK
#'
#' Key function to compute mean WID smoke scores
#'
#' @param beta Preprocessed data matrix
#' @return Data frame with WID smk scores as columns and samples as rows
#' @export

WID_SMK <- function(beta,
                    return.basename = F){

  # initiate tmp
  tmp <- data.frame(basename = colnames(beta))
  WID_SMK_cpgs <- WID.smk:::WID_SMK_cpgs |>
    dplyr::filter(chr != "chrX")
  setnames <- unique(WID_SMK_cpgs$set)

  tmp$WID_SMK_distal_epithelial_hyperM <- NA
  tmp$WID_SMK_epithelial_hypoM <- NA
  tmp$WID_SMK_immune_hypoM <- NA
  tmp$WID_SMK_proximal_epithelial_hyperM <- NA

  for (i in 1:length(setnames)){
    x <- WID_SMK_cpgs[WID_SMK_cpgs$set==setnames[i],]$cg
    intersect <- intersect(x, rownames(beta))
    tmp[[paste0("WID_SMK_", setnames[i])]] <- colMeans(beta[intersect,])
  }

  # 450k version
  WID_SMK_cpgs_450 <- WID_SMK_cpgs[WID_SMK_cpgs$on_450k_array=="yes",]

  tmp$WID_SMK450_distal_epithelial_hyperM <- NA
  tmp$WID_SMK450_epithelial_hypoM <- NA
  tmp$WID_SMK450_immune_hypoM <- NA
  tmp$WID_SMK450_proximal_epithelial_hyperM <- NA

  for (i in 1:length(setnames)){
    x <- WID_SMK_cpgs_450[WID_SMK_cpgs_450$set==setnames[i],]$cg
    intersect <- intersect(x, rownames(beta))
    tmp[[paste0("WID_SMK450_", setnames[i])]] <- colMeans(beta[intersect,])
  }

  if(return.basename == F){
    tmp <- tmp[,-1] # remove basename column
  }

  return(tmp)

}
