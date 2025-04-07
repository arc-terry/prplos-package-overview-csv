
# Generate package overview report

```bash

$ bash gen_version_report.sh

======================
         (0) 20191212
         (1) 20200220
         (2) 75373dc891
         (3) 9d2efd
         (4) UPDK-9.1.50
         (5) UPDK-9.1.55
         (6) UPDK-9.1.60
         (7) UPDK-9.1.60.1
         (8) UPDK-9.1.60.2
         (9) UPDK-9.1.60.2.1
         (10) UPDK-9.1.65
         (11) prplmesh_whm_temp
         (12) prplos-23.05_v0.1.2
         (13) prplos-23.05_v0.1.3
         (14) prplos-23.05_v0.1.4
         (15) prplos-23.05_v0.2.0
         (16) prplos-23.05_v0.2.1
         (17) prplos-next-2.2-features-merged
         (18) prplos-v1.2
         (19) prplos-v1.3
         (20) prplos-v1.4
         (21) prplos-v1.5
         (22) prplos-v2.0-preview
         (23) prplos-v2.1-preview
         (24) prplos-v2.2
         (25) prplos-v2.3-preview
         (26) prplos-v2.3-preview2
         (27) prplos-v3.0.0
         (28) prplos-v3.0.0-preview1
         (29) prplos-v3.0.1
         (30) prplos-v3.0.2
         (31) prplos-v3.0.3
         (32) prplos-v3.1.0
         (33) prplos-v3.2.0
         
         ... ignore ...

         (459) remotes/origin/ynezz/usp-testing
         (460) remotes/origin/ynezz/vincent-strace
         (461) remotes/origin/yuce/dev_latest-3.2_20241009
         (462) remotes/origin/yuce/dev_latest-3.2_20241011
         (463) remotes/origin/yuce/latest-3.2_new_components
         (464) remotes/origin/yuce/nightly
         (465) remotes/origin/yuce/prplos-23.05_with_signoffs
         (466) remotes/origin/yuce/prplos-23.05_without_bot_commits
======================
select: 33 # enter target tag/branch id


# It will generate report to "output/<target-branch-or-tag-name>" folder
output/
└── prplos-v3.2.0
    ├── prplos-v3.2.0.csv
    └── sum.index

```



# Generate the compare report between two branchs/tags


```bash

# if we generate multiple overview reports (i.e. mainline-23.05, prplos-v3.1.0, and prplos-v3.2.0 )

output/
├── mainline-23.05
│   ├── mainline-23.05.csv
│   └── sum.index
└── prplos-v3.2.0
    ├── prplos-v3.2.0.csv
    └── sum.index

# we can generate compare report
#usage: compare.sh <A_csv_file> <B_csv_file>

$ bash compare.sh output/prplos-v3.2.0/prplos-v3.2.0.csv output/mainline-23.05/mainline-23.05.csv


# It will generate compare report to "output/compare" folder

output/
├── compare
│   └── prplos-v3.2.0_vs_mainline-23.05.csv
├── mainline-23.05
│   ├── mainline-23.05.csv
│   └── sum.index
└── prplos-v3.2.0
    ├── prplos-v3.2.0.csv
    └── sum.index



```




