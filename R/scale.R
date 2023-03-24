#' scale
#'
#' Scale smoking indices, using values in TG study at M0 as reference
#'
#' @param data data frame consisting of at least scores. Scores must be present in tg data frame
#' @param scores Scores to be normalised
#' @return Data frame with additional column of scaled scores
#' @export

scale <- function(data, scores =  c("WID_SMK_epithelial_hypoM",
                                  "WID_SMK_immune_hypoM",
                                  "WID_SMK_distal_epithelial_hyperM",
                                  "WID_SMK_proximal_epithelial_hyperM",
                                  "WID_SMK450_epithelial_hypoM",
                                  "WID_SMK450_immune_hypoM",
                                  "WID_SMK450_distal_epithelial_hyperM",
                                  "WID_SMK450_proximal_epithelial_hyperM")){
    for(i in scores){
    i = paste0(i, "_corr")
    data[[paste0(i, "_z")]] <- NA
    if(grepl("hypoM", i)){
      data[[paste0(i, "_z")]] <- -((data[[i]] - WID.smk:::mu[[i]])/WID.smk:::sigma[[i]])
    } else {
      data[[paste0(i, "_z")]] <- ((data[[i]] - WID.smk:::mu[[i]])/WID.smk:::sigma[[i]])
    }
  }
    return(data)
}
