M = {
    num = 1
}

function M.add()
    M.num = M.num + 1
end

function M.val()
    return M.num
end

return M
