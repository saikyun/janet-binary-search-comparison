(declare-project
  :name "binary search comparison"
  :author "saikyun"
  :license "MIT"
  :description "Performance comparison between different ways of implementing binary search."
  :url "https://github.com/saikyun/janet-binary-search-comparison"
  :repo "git+https://github.com/saikyun/janet-binary-search-comparison")

(declare-native
  :name "binary-search"
  :source @["binary_search.c"])
