#' correct_ic
#'
#' Scale smoking indices, using values in TG study at M0 as reference
#'
#' @param data data frame consisting of at least scores and a column called smoking_history (either "Never smoker", "Ex-smoker", "Smoker). Scores must be present in tg data frame
#' @param scores Scores to be corrected
#' @return Data frame with additional column of scaled scores
#' @export

correct_ic <- function(data, scores = c("WID_SMK_epithelial_hypoM",
                                                  "WID_SMK_immune_hypoM",
                                                  "WID_SMK_distal_epithelial_hyperM",
                                                  "WID_SMK_proximal_epithelial_hyperM",
                                                  "WID_SMK450_epithelial_hypoM",
                                                  "WID_SMK450_immune_hypoM",
                                                  "WID_SMK450_distal_epithelial_hyperM",
                                                  "WID_SMK450_proximal_epithelial_hyperM"),
                       correction = "tg"){

  if(correction == "tg"){

    # Sum up residuals + relevant intercept (separate for never smokers, ex-smokers, and smokers) - using slopes defined in discovery set

    # Never smokers -----------------------
    if("Never smoker" %in% unique(data$smoking_history)){

      tmp <- data |>
        dplyr::filter(smoking_history %in% c("Never smoker")) |>
        droplevels()

      for (i in scores){

        if(!i %in% c("WID_SMK_immune_hypoM", "WID_SMK450_immune_hypoM", "cg05575921", "smoking_mrs")){
          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_nsmk[[i]]$coefficients[1]) + (tmp[[i]] - predict(WID.smk:::models_nsmk[[i]], newdata = tmp)) # intercept minus residual
        } else {
          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_nsmk[[i]]$coefficients[1] + models_nsmk[[i]]$coefficients[2]) + (tmp[[i]] - predict(WID.smk:::models_nsmk[[i]], newdata = tmp)) # intercept at ic = 1, minus residual
        }
      }
      datatmp <- tmp
    }


    # Ex-smokers -----------------------
    if("Ex-smoker" %in% unique(data$smoking_history)){

      tmp <- data |>
        dplyr::filter(smoking_history %in% c("Ex-smoker")) |>
        droplevels()

      for (i in scores){

        if(!i %in% c("WID_SMK_immune_hypoM", "WID_SMK450_immune_hypoM", "cg05575921", "smoking_mrs")){

          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_exsmk[[i]]$coefficients[1]) + (tmp[[i]] - predict(WID.smk:::models_exsmk[[i]], newdata = tmp)) # intercept minus residual
        } else {
          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_exsmk[[i]]$coefficients[1] + WID.smk:::models_exsmk[[i]]$coefficients[2]) + (tmp[[i]] - predict(WID.smk:::models_exsmk[[i]], newdata = tmp)) # intercept at ic = 1 minus residual
        }
      }

      if(exists("datatmp")){
        datatmp <- rbind(datatmp, tmp)
      } else {
        datatmp <- tmp
      }
    }

    # Smokers -----------------------
    if("Smoker" %in% unique(data$smoking_history)){

      tmp <- data |>
        dplyr::filter(smoking_history %in% c("Smoker")) |>
        droplevels()

      for (i in scores){

        if(!i %in% c("WID_SMK_immune_hypoM", "WID_SMK450_immune_hypoM", "cg05575921", "smoking_mrs")){

          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_smk[[i]]$coefficients[1]) + (tmp[[i]] - predict(WID.smk:::models_smk[[i]], newdata = tmp)) # intercept plus/minus residual
        } else {
          tmp[[paste0(i, "_corr")]] <- (WID.smk:::models_smk[[i]]$coefficients[1] + WID.smk:::models_smk[[i]]$coefficients[2]) + (tmp[[i]] - predict(WID.smk:::models_smk[[i]], newdata = tmp)) # intercept  at ic=1 plus/minus residual
        }
      }

      if(exists("datatmp")){
        datatmp <- rbind(datatmp, tmp)
      } else {
        datatmp <- tmp
      }

    }

    if(nrow(data) == nrow(datatmp)){
      data <- datatmp
      return(data)


    } else {
      stop("Smoking information not complete")
    }
  } else {
    types <- unique(data$smoking_history)

    for(t in types){
      tmp <- data |>
        dplyr::filter(smoking_history == t) |>
        droplevels()

      for (i in scores){
        model <- lm(tmp[[i]] ~ tmp$ic, data = tmp)
        if(!i %in% c("WID_SMK_immune_hypoM", "WID_SMK450_immune_hypoM", "cg05575921", "smoking_mrs")){
          tmp[[paste0(i, "_corr")]] <- (model$coefficients[1]) + (tmp[[i]] - predict(model, newdata = tmp)) # intercept minus residual
        } else {
          tmp[[paste0(i, "_corr")]] <- (model$coefficients[1] + model$coefficients[2]) + (tmp[[i]] - predict(model, newdata = tmp)) # intercept at ic = 1, minus residual
        }
      }

      if(t == types[1]){
        datatmp <- tmp
      } else {
        datatmp <- rbind(datatmp, tmp)
      }
    }


    if(nrow(data) == nrow(datatmp)){
      data <- datatmp
      return(data)
    } else {
      stop("Smoking information not complete")
    }

  }

}
