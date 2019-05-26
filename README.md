# mobile-text-entry

Examining the effects of hand posture on mobile text entry performance for touch and gesture typing.

## Running Analyses

Execute the following bash commands withing the root directory to perform the following analyses.

### Speed analysis (pilot):

```
Rscript src/speed_analysis.r TEMA-logs/study
```

### Acccuracy analysis (pilot):

```
Rscript src/accuracy_analysis.r TEMA-logs/study
```

### NASA-TLX analysis:

```
Rscript src/NASA_TLX_analysis.r NASA_TLX_responses.csv
```