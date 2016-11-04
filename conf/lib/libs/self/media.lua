local _M = {}

function _M.isMediaRequest(self, queryString)
    if queryString then
        local idx = 0
        idx = string.find(queryString, "^imageView/")
        if idx == 1 then
            return true
        end

        idx = string.find(queryString, "^imageInfo$")
        if idx == 1 then
            return true
        end

        idx = string.find(queryString, "^exif$")
        if idx == 1 then
            return true
        end

        idx = string.find(queryString, "^watermark/")
        if idx == 1 then
            return true
        end

        idx = string.find(queryString, "^vframe/")
        if idx == 1 then
            return true
        end

        idx = string.find(queryString, "^vinfo$")
        if idx == 1 then
            return true
        end
    end

    return false
end

return _M
