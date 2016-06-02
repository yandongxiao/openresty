#
function assert() {
  if [[ ! $1 -eq $2 ]]; then
    echo "$1 != $2"
    exit 1
  fi
}

# 不管下面发送了几个请求给客户端，能够返回200的个数是与sleep有关系的
# 返回200的个数=sleep秒数 + burst数目 + rate
curl localhost &
assert $? 0
curl localhost &
assert $? 0

sleep 1

curl localhost &
assert $? 0

curl localhost &
assert $? 0

curl localhost &
assert $? 0
