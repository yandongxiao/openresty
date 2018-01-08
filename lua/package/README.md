### package

- package最主要的功能是防止命名冲突；
- LUA并没有提供专门的package语法，而是建议用户通过table来实现；
- 用户用LUA实现了一个module，本质上是表；

### 如何优雅的做到以下事情

- package的公开域和私有域；
- package内部函数之间调用形式，是否也必须是xxx.func；
- package名字的修改，是否会影响多行代码；