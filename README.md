# WID.smk package

<table border="0">
 <tr>
    <td width="50%"><img src="https://github.com/chiaraherzog/WID_SMK_code/blob/main/asset/widsmk.png" /></td>
    <td width="50%">The WID.smk package computes cell type-specific smoking related scores.</td>
 </tr>
</table>

## Installation

Installation can be achieved using devtools::install_github.

```
if(!require(devtools)){
	install.packages("devtools")
}

devtools::install_github("chiaraherzog/WID.smk")
```

## Use

Smoking indices are calculated using the `WID.smk::WID_SMK()` function on a beta matrix:

```
library(WID.smk)

out <- WID_SMK(beta)
```

To correct for immune cell composition in buccal, saliva or cervical samples (other samples have not been tested) you can use the WID.smk::correct_ic() function. Your phenotypic file at a minimum must contain the following information:

* `ic` column, inferred from `EpiDISH` package (for instance by default in the `eutopsQC` package)
* `smoking_history` column

Correction can be done externally, e.g. using existing datasets, or internally (recommended for new smoking histories), which extract slopes and intercepts from the data at hand.

```
pheno <- pheno |>
	correct_ic(correction = 'internal')
```

Some groups of CpGs exhibit a loss of methylation (hypomethylation) with smoking while others exhibit a gain (hypermethylation), which may seem confusing. To improve interpretability, indices can be scaled so smokers always exhibit higher values, and values are z-scaled:

```
pheno <- pheno ||>
	scale()
```

For further questions, please reach out or check out the [demo](https://github.com/chiaraherzog/HEAP-demo/).