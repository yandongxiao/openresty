local cjson = require "cjson.safe"

local _M = {
    bucket2mirrorCache = nil,
    domain2bucketCache = nil,
    bucket2refererCache = nil,
}

require "resty.http"

function _M.setDomain2BucketCache(self, cache)
    _M.domain2bucketCache = cache
end

function _M.setBucket2MirrorCache(self, cache)
    _M.bucket2mirrorCache = cache
end

function _M.setBucket2RefererCache(self, cache)
    _M.bucket2refererCache = cache
end

-- TODO
-- 1. cjson.decode may return nil
-- 2. targetURI should be a table contains multiple backend servers
function _M.updateBucket2MirrorCache(self, httpc, targetURI, cacheExpireTime)
    local res, err = httpc:request_uri(targetURI, {method = "GET", headers = whitelist()}) 
    if not res then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketMirrorSource: ", err)
    elseif res.status ~= ngx.HTTP_OK then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketMirrorSource, ErrCode = ", res.status)
    else
        local bucket2mirrorJson = cjson.decode(res.body)
        if type(bucket2mirrorJson["MirrorSources"]) == "table" then
            for _, bucket2mirror in pairs(bucket2mirrorJson["MirrorSources"]) do
                _M.bucket2mirrorCache:set(bucket2mirror["BucketName"], bucket2mirror["MirrorSource"], cacheExpireTime)
            end
        end
    end
end

function _M.updateDomain2BucketCache(self, httpc, targetURI, cacheExpireTime)
    local res, err = httpc:request_uri(targetURI, {method = "GET", headers = whitelist()}) 
    if not res then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketDomainBinding: ", err)
    elseif res.status ~= ngx.HTTP_OK then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketDomainBinding:, ErrCode = ", res.status)
    else
        local bucket2domainsJson = cjson.decode(res.body)
        if type(bucket2domainsJson["DomainBindings"]) == "table" then
            for _, bucket2domains in pairs(bucket2domainsJson["DomainBindings"]) do
                for _, domain in pairs(bucket2domains["Domains"]) do
                    _M.domain2bucketCache:set(domain, bucket2domains["BucketName"], cacheExpireTime)
                end
            end
        end
    end
end

function _M.updateBucket2RefererCache(self, httpc, targetURI, cacheExpireTime)
    local res, err = httpc:request_uri(targetURI, { method = "GET", headers = whitelist() }) 
    if not res then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketReferer: ", err)
    elseif res.status ~= ngx.HTTP_OK then
        ngx.log(ngx.ERR, "[InternalError] Fail to ListBucketReferer::, ErrCode = ", res.status)
    else
        local bucket2refererJson = cjson.decode(res.body)
        if type(bucket2refererJson["Referers"]) == "table" then
            for _, bucket2referer in pairs(bucket2refererJson["Referers"]) do
                _M.bucket2refererCache:set(bucket2referer["BucketName"], cjson.encode(bucket2referer), cacheExpireTime)
            end
        end
    end
end

function whitelist()
    local headers = {}
    headers["x-cos-whitelist"] = "nginx nginx"
    return headers
end

return _M
