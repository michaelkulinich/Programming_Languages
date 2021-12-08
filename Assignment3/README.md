Pointers were fun. 

I loved this because it made getting the value of an address easier. Came in handy for insert and delete. It was difficult to create these methods, but what helped was testing things in the command line before we wrote them into our functions. This gave us an opportunity to look at what :env was returning and seeing the connections being made between our linked list. Made linked lists, and the addresses each node pointed to a lot clearer.
```val get = \a. 
    head(!a);;
```


We found this memory model to be very interesting. Although it was very abstract, it did a great job demonstrating how memory allocation works on the heap and on the stack. Playing around with this memory model hands on, actually helped us understand how pointers work in C++. Pointers felt very unknown and uncomfortable previously, but now they make so much more sense, thanks to this assignment. It was cool making our own linked list and manually manipulating the pointers.

One thing we were confused about at first was how when we insert a new node, we would still only see the head of the node on the stack. How do we access all of these inserted nodes? Where do all of these inserted nodes go?
```
val insert = \e. \a.
    let val b = newCList e in
    b := [get b,next(a)];
    a := [get a, b]
;;
```
Well we understood that the new node, “b” is local to this function call and is deallocated off the stack automatically. Its heap memory however does persist and stay even after the function call ends. This was very interesting to see 

