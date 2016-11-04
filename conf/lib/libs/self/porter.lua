local _M = {
    headObjectURI = nil,
    porterURI = nil,
}

function _M.setHeadObjectURI(self, uri)
    _M.headObjectURI = uri
end

function _M.setPorterURI(self, uri)
    _M.porterURI = uri
end

-- TODO
-- 1. head object may return 304
-- 2. string concatenation not efficient
-- 3. migrate should cover HEAD object
function _M.migrate(self, mirror, bucketName, objectName)

    if objectName:len() == 0 then
        return
    end

    res = ngx.location.capture(_M.headObjectURI..objectName, { method = ngx.HTTP_HEAD, copy_all_vars = true })
    if res.status == ngx.HTTP_NOT_FOUND then
        ngx.exec(_M.porterURI.."?source="..mirror..objectName.."&targetBucket="..bucketName.."&targetObject="..objectName)
    end
end

return _M
