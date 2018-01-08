-- 垃圾收集器不是万能的
-- 比如，t = {c = t}，即使t=nil，该表仍然不会被清除。这种引用称之为弱引用
-- 同时，需要一种用户和垃圾收集器之间交互的机制，告知它哪些是弱引用

-- Weak tables are the mechanism that you use to tell Lua that a reference should not prevent the reclamation of an object.
-- A weak reference is a reference to an object that is not considered by the garbage collector.
-- If all references pointing to an object are weak, the object is collected and somehow these weak references are deleted.
-- Lua implements weak references as weak tables: A weak table is a table where all references are weak.
-- That means that, if an object is only held inside weak tables, Lua will collect the object eventually.
