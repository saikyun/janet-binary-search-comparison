(import build/binary-search :as bs)

(defn binary-search-closest*
  [vs c offset]
  (if (zero? (length vs))
    offset
    (let [i (math/floor (/ (length vs) 2))
          v (vs i)]
      (case (c v)
        -1 (binary-search-closest*
             (array/slice vs 0 i)
             c
             offset)
        0  (+ offset i)
        1  (binary-search-closest*
             (array/slice vs (inc i))
             c
             (+ offset (inc i)))))))

(defn binary-search-closest
  ``
  Binary searches sorted array `vs` using single arity function `c`.
  `c` is called on elements of `vs`, and is expected to return `-1`, `0` or `1` (like `compare`).
  Returns index of match.
  If an exact match can't be found, return the closest index, rounded upwards.
  
  (binary-search-closest [0 1 2] (partial compare 1)) #=> 1
  (binary-search-closest [0 1 2] (partial compare 2)) #=> 2
  (binary-search-closest [0 1 2] (partial compare 1.5)) #=> 2
  ``
  [vs c]
  (binary-search-closest* vs c 0))

(defn binary-search-closest3*
  [vs bottom top c]
  (if (>= bottom top)
    top
    (let [i (math/floor (/ (- top bottom) 2))
          v (vs (+ i bottom))]
      (case (c v)
        -1 (binary-search-closest3*
             vs
             bottom
             (+ bottom i)
             c)
        0  i
        1  (binary-search-closest3*
             vs
             (inc (+ bottom i)) 
             top
             c)))))

(defn binary-search-closest3
  ``
  Binary searches sorted array `vs` using single arity function `c`.
  `c` is called on elements of `vs`, and is expected to return `-1`, `0` or `1` (like `compare`).
  Returns index of match.
  If an exact match can't be found, return the closest index, rounded upwards.
  
  (binary-search-closest [0 1 2] (partial compare 1)) #=> 1
  (binary-search-closest [0 1 2] (partial compare 2)) #=> 2
  (binary-search-closest [0 1 2] (partial compare 1.5)) #=> 2
  ``
  [vs c]
  (binary-search-closest3* vs 0 (length vs) c))

(defn binary-search-closest2
  [vs c]
  (var res nil)
  (var bottom 0)
  (var top (length vs))
  (while (nil? res)
    (if (>= bottom top)
      (set res top)
      (let [i (math/floor (/ (- top bottom) 2)) 
            v (vs (+ i bottom))]
        (case (c v)
          -1 (set top (+ bottom i))
          0  (set res (+ bottom i))
          1  (set bottom (inc (+ bottom i)))))))
  res)

(var spent 0)
(loop [i :range [2000 20000]
       :let [r (range i)
             c (partial compare (math/floor (* i (math/random))))]]
  (def start (os/clock)) 
  (binary-search-closest r c)
  (+= spent (- (os/clock) start)))
(print "recursive (array/slice): " spent " seconds")

(var spent 0)
(loop [i :range [2000 20000]
       :let [r (range i)
             c (partial compare (math/floor (* i (math/random))))]]
  (def start (os/clock)) 
  (binary-search-closest2 r c)
  (+= spent (- (os/clock) start)))
(print "imperative: " spent " seconds")

(var spent 0)
(loop [i :range [2000 20000]
       :let [r (range i)
             c (partial compare (math/floor (* i (math/random))))]]
  (def start (os/clock)) 
  (binary-search-closest3 r c)
  (+= spent (- (os/clock) start)))
(print "recursive: " spent " seconds")

(var spent 0)
(loop [i :range [2000 20000]
       :let [r (range i)
             c (partial compare (math/floor (* i (math/random))))]]
  (def start (os/clock)) 
  (bs/binary-search-closest-c r c)
  (+= spent (- (os/clock) start)))
(print "native: " spent " seconds")


(var spent 0)
(loop [i :range [2000 20000]
       :let [r (range i)
             v (math/floor (* i (math/random)))
             c (partial compare v)]]
  (def start (os/clock)) 
  (bs/binary-search-closest-c-int r v)
  (+= spent (- (os/clock) start)))
(print "native (int): " spent " seconds")
