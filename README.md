# mobile-text-entry

Examining the effects of hand posture on mobile text entry performance for touch and gesture typing.

## Abstract

The "best" technique for text entry using a touchscreen is highly contextual and depends on a variety of factors, including device size and mobility. So far, we are yet to discover one technique to rule them all. Two popular techniques for text entry on mobile devices are touch and gesture typing. Despite substantial research on smart features, such as auto-correction and prediction algorithms, and on the comparative performance of touch and gesture typing, one under-researched area is how hand posture effects performance. To address this, we performed a study to investigate the effects of hand posture on touch and gesture typing speed and accuracy on smart touchscreen keyboards. Our results show that hand posture significantly effects text entry speed, and that there are significant combined effects of hand posture and text entry technique. These results have implications for designers investigating mobile text entry or text entry on soft keyboards where hand posture is constrained.

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