local Set = require "set"

local set1 = Set.new {10, 20, 30}
local set2 = Set.new {20, 30, 40}
local set3 = Set.new {2, 3, 40}

local set = set1 + set2
set = set + set3
print(set)
