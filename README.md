# janet-binary-search-comparison
Comparing the performance of multiple implementations of [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm).

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


## Notes

### Docstring for 1-4
```
Binary searches sorted array `vs` using single arity function `c`.
`c` is called on elements of `vs`, and is expected to return `-1`, `0` or `1` (like `compare`).
Returns index of match.
If an exact match can't be found, return the closest index, rounded upwards.

(binary-search-closest [0 1 2] (partial compare 1)) #=> 1
(binary-search-closest [0 1 2] (partial compare 2)) #=> 2
(binary-search-closest [0 1 2] (partial compare 1.5)) #=> 2
```

### 1. recursive (array/slice)

My first implementation, which uses `array/slice` to cut the array in half. It's also recursive.
My guess is that it's slowest because it's creating many intermediate arrays when calling `array/slice`.

### 2. imperative

I just made a loop which gradually changes the `bottom` and `top` index rather than slicing. At first I thought it was faster because of using loop rather than recursion, but I realized that maybe the problem was with the `array/slice`ing, so...

### 3. recursive

Uses the `bottom`/`top` approach of 2., while still using recursion. This is slightly faster than the loop, which is pretty cool.

### 4. native

I figured I might as well try it in c, and it seems to shave off 10-20% -- I guess C is just a bit better at looping (since otherwise the algorithm is the same as 2. and 3.). But maybe there's more to it.

### 5. native (int)

This one cheats a bit by not being as generic as 1-4. 1-4 allows one to send a single arity function to do the comparison (e.g. `(comp |(:x $) (partial compare 4))`), while this solution just takes an int and compares it directly to the elements of an array. So, if you have a sorted array of ints you can go 80% faster.
