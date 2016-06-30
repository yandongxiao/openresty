account = require "account"

c1 = account.new(10)
c2 = account.new(10)
c1:deposit(100)
c1:withdraw(15)
c1:withdraw(15)

c2:deposit(200)
c2:withdraw(15)
c2:withdraw(15)

print(c1.balance)
print(c2.balance)
