# janet-binary-search-comparison
Comparing the performance of multiple implementations of binary search

## Try it
```
jpm build
janet binary_search.janet
#=>
recursive (array/slice): 0.671159 seconds
imperative: 0.118109 seconds
recursive: 0.112909 seconds
native: 0.0939085 seconds
native (int): 0.0539043 seconds
```
