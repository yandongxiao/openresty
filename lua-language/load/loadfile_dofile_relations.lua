-- loadfile 与 dofile 的另外一个区别：
-- 抛开f()不讲
-- loadfile返回错误，dofile抛出异常(assert的缘故)
function dofile (filename)
    local f = assert(loadfile(filename))
    return f()
end
